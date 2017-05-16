// 客戶資料第一頁
#import "ListViewController.h"
#import "Note.h"
#import "NoteCell.h"//下午#5
#import "NoteViewController.h"
#import "CoreDataHelper.h"
#import "HomeViewController.h"
@import MessageUI; //428 @@3
@import  StoreKit; //428 @@2
@import  Firebase; //428 @@4
@import GoogleMobileAds; //428 $$1


@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,NoteViewControllerDelegate,GADBannerViewDelegate>
{
    HomeViewController *homeViewController;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray<Note*> *data;//generic 範型
@property(nonatomic) GADBannerView *bannerView;//$$2 428
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;


@end

@implementation ListViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.data = [NSMutableArray array];//model
//        [self loadFromFile];
        [self queryFromCoreData];
        //新(save) 刪除(save) 修改 查詢
    }
    
    //3/17 @10 註冊對 NoteUpdated事件有興趣。發生時呼叫finishUpdate方法
    [[NSNotificationCenter defaultCenter]
     addObserver:self //誰
     selector:@selector(finishUpdate:)//方法
     name:@"NoteUpdated"// 事件
     object:nil];
    return self;
}
//@3/17 11 課本263~265頁接收通知的方法
-(void)finishUpdate:(NSNotification *)notification{
    
    Note *note = notification.userInfo[@"note"];//從通知物件中可以取出Note物件
    //取得位置
    NSInteger index =  [self.data indexOfObject:note];
    //組成nsindexpath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    //tableview 更新特定位置的cell
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(void)dealloc{
    //＠12取消所有的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    homeViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //#6上行是設定左上方的按鈕
    
    //428 $$6 改回IOS6以前設定
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent =NO;
    
    // 428 $$3 廣告設置
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.bannerView.adUnitID = @"ca-app-pub-1147209557956753/3964514225";
    self.bannerView.delegate = self;
    
    self.bannerView.rootViewController =  self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
//    // 428 $$ 5
//    self.tableView.tableHeaderView =self.bannerView;
    
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    //#7 這裡不用切換
    [self.tableView setEditing:editing animated:YES];
    
}
#pragma mark NSArchiving
-(void)loadFromFile{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"notes.archive"];
    //從檔案解回變成NSArray<Note*>
    NSArray *notesInFiles = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    //轉成Mutable型式
    self.data = [NSMutableArray arrayWithArray:notesInFiles];
    /*
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"data"];
    if(data){
    self.data = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
     */
}
-(void)saveToFile{
    NSString *docPath = [NSHomeDirectory()
                         stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"notes.archive"];
    //寫到檔案
    [NSKeyedArchiver archiveRootObject:self.data toFile:filePath];
    //3/21$1 save to NSUserDefault
    //不用指定檔案路徑 系統會定時儲存NSUser Defaults
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"data"];
                    
}
#pragma mark coredata
//$6 save coredata方法
-(void)saveToCoreData{
    CoreDataHelper *helper = [CoreDataHelper sharedInstance];
    NSError *error =nil;
    [helper.managedObjectContext save:&error];
    if (error) {
        NSLog(@"error while saving core data %@",error);
    }
}
-(void)queryFromCoreData{
    CoreDataHelper *coreData = [CoreDataHelper sharedInstance];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    
    NSError *error = nil;
    //取得查詢結果
    NSArray *results = [coreData.managedObjectContext executeFetchRequest:request error:&error];
    
    if ( error ){
        NSLog(@"error %@",error);
        self.data = [NSMutableArray array];
    }else{
        //組成data
        self.data = [NSMutableArray arrayWithArray:results];
    }
}

- (IBAction)edit:(id)sender {
    
    //  [self. tableView setEditing:!self.tableView.isEditing];
    //上方加個 setEditing:後“”" ! “”“”的!是可以切換的意思,速度比較快
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    //上方是比較慢的顯示方式
}
//4/12 下午第一個 上傳的圖
- (IBAction)upload:(id)sender {
    
    
    //428 @@1 10.3版本才支援
    if ( NSClassFromString(@"SKStoreReviewController")){
        [SKStoreReviewController requestReview];
    }

//    @[][0];
    
    UIBarButtonItem *item = sender;
    UIActivityIndicatorView *view=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    item.customView=view;//customView旋轉的畫面
    [view startAnimating];
    
    //sync 是同步 asyc 是非同步
    //global 是背景執行緒 main是主執行緒
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //模擬上傳停止三秒
        [NSThread sleepForTimeInterval:3];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //UIxxx 要在thread 1（main thread）執行
            item.customView=nil;
        });
    });
}

- (IBAction)addNote:(id)sender {
    
    //428 @@5
    [FIRAnalytics logEventWithName:@"add_note" parameters:nil];
    
    //STEP 1 .model中要先修改
//    Note *note = [[Note alloc] init];
    //$4 使用CoreDataHelper
    CoreDataHelper *helper = [CoreDataHelper sharedInstance];
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:helper.managedObjectContext];
    
    note.text =NSLocalizedString(@"new.note", @"說明欄位沒功用");
    [self.data insertObject:note atIndex:0];
//   [self saveToFile];//新save
//   $5 Core data 得save
    [self saveToCoreData];
    
    //step2 通知TableView新增畫面
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //4月12日 下面1
    NoteViewController *noteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"noteViewController"]; 
    noteViewController.currentNote = note;
    noteViewController.delegate = self;
    //@4/12 #2
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:noteViewController];
    
    [self presentViewController:navi animated:YES completion:nil];
    
    
}
#pragma mark UITableViewDelegate
//點擊時,受到的通知 #2 變灰灰的
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //反向選取 #3 設定完點擊就會反白
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Note *note = self.data[indexPath.row];
    
    NSLog(@" %@ selected",note.text);
  /*  //下方是課本235~237頁
      NoteViewController *noteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"noteViewController"];
    
    [self.navigationController pushViewController:noteViewController animated:YES];
    //上方是課本235~237頁 切換頁面
   */
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count; //產生幾筆行數
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //下面是設定notecell
    // NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customcell" forIndexPath:indexPath];
    // cell.label1.text = note.text;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.showsReorderControl = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Note *note = self.data[indexPath.row];
    cell.textLabel.text = note.text;
    cell.imageView.image = [note thumbnailImage]; //@14
    
    //4/24日期
    NSDate *date = [NSDate date];
    /*
     //西元年 #1
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterFullStyle timeStyle:NSDateFormatterNoStyle];
     */
    //民國年//#2
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierRepublicOfChina];
    [formatter setCalendar:calendar];//設定民國歷
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    cell.detailTextLabel.text = [formatter stringFromDate:date];
    return cell;
}
//3/15 #2
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self.tableView reloadData];//偷懶得做法把資料做更新
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


    //上段從 -UITableViewCell往下 是將note0--9

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( editingStyle == UITableViewCellEditingStyleDelete){
        //移除model中相對應的note物件
        
        Note *note = self.data[indexPath.row];
        CoreDataHelper *helper = [CoreDataHelper sharedInstance];
        [helper.managedObjectContext deleteObject:note];
        [self saveToCoreData];
        
        [self.data removeObjectAtIndex:indexPath.row];
        //刪(save)
        //[self saveToFile];
        //通知tableview刪除該位置cell
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //換model位置
    Note *note = self.data[sourceIndexPath.row];
    //先移除
    [self.data removeObject:note];
    //插到指定位置
    [self.data insertObject:note atIndex:destinationIndexPath.row];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// #8要記得去noteviewcontroller.h設屬性
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ( [segue.identifier isEqualToString:@"noteSegue"]){
        //下行取得下一組畫面
        NoteViewController *noteViewController = segue.destinationViewController;
        //下行取得使用者點選的位置
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        //下行取得對應的Note物件
        Note *note = self.data[indexPath.row];
        //下行傳給noteViewController
        noteViewController.currentNote = note;
        noteViewController.delegate = self; //設一個屬性叫delegate
    }
}
//@5等一下NoteViewController如果使用者按下done,呼叫目前的方法，
//並傳入修改的note   (方法）
-(void)didFinishUpdateNote:(Note *)note{
    //取得位置
    NSInteger index =  [self.data indexOfObject:note];
    //組成nsindexpath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    //tableview 更新特定位置的cell
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self saveToFile];
    [self saveToCoreData];
}
- (IBAction)Homeview:(id)sender {
    HomeViewController * homeviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:homeviewcontroller animated:YES completion:nil];
    
}

//428 @@3 email 設定

- (IBAction)help:(id)sender {
    
    if ( ![MFMailComposeViewController canSendMail]){
        NSLog(@"mail沒有設定");
        return;
    }
    
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
    mcvc.mailComposeDelegate = self;
    mcvc.title = @"I have qusetion";
    [mcvc setSubject:@"I have qusetion"];
    //應用程式版本，Target裏的Version
    NSString *version = [[NSBundle mainBundle]
                         objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *machine = [[UIDevice currentDevice] model];
    
    NSString *productName = [[NSBundle mainBundle]
                             objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *defaultBody = [NSString stringWithFormat:@"<br><br/><br/>Product: %@(%@)<br/>Device:%@",productName,version,machine];
    [mcvc setMessageBody:defaultBody isHTML:YES];
    //提供支援email
    NSString *email = @"yourEmailSupport@hotmail.com";
    //設定收件人
    [mcvc setToRecipients:[NSArray arrayWithObject:email]];
    [self presentViewController:mcvc animated:YES completion:nil];
}
//428 @@4 email 設定
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *resultTitle = nil;
    NSString *resultMsg = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            resultTitle = @"Email Saved";
            resultMsg = @"You saved the email as a draft";
            break;
        case MFMailComposeResultSent:
            resultTitle = @"Email Sent";
            resultMsg = @"Your email was successfully delivered";
            break;
        case MFMailComposeResultFailed:
            resultTitle = @"Email Failed";
            resultMsg = @"Sorry, the Mail Composer failed. Please try again.";
            break;
        default:
            resultTitle = @"Email Not Sent";
            resultMsg = @"Sorry, an error occurred. Your email could not be sent."; break;
    }
    if ( resultTitle ){
        UIAlertView *mailAlertView = [[UIAlertView alloc] initWithTitle:resultTitle
                                                                message:resultMsg delegate:self
                                                      cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [mailAlertView show];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Mapview:(id)sender {
    [homeViewController goBtnPressed:sender];
}

#pragma mark GADBannerViewDelegate
//428 $$ 6
-(void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
    if (![bannerView superview]) {
        [self.view addSubview:bannerView];
        self.topConstraint.active =NO; //將上方得條件拿掉
        
        NSArray *vs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][ad][tableView]" options:0 metrics:nil views:@{@"top":self.topLayoutGuide,@"ad":bannerView,@"tableView":self.tableView}]; // 垂直類型
        
        NSArray *hs = [NSLayoutConstraint constraintsWithVisualFormat:@"|[ad]|" options:0 metrics:nil views:@{@"ad":bannerView}];
        
        [NSLayoutConstraint activateConstraints:vs];
        [NSLayoutConstraint activateConstraints:hs];
        
    }
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
