//
//  NoteViewController.m
//  NoteApp
//
//  Created by user33 on 2017/3/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "NoteViewController.h"
#import "ListViewController.h"
@import  GoogleMobileAds ; // 428 %%1
@interface NoteViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,GADInterstitialDelegate>// 428 %%1
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) BOOL isNewImage; //@新增有個布林值
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property(nonatomic) NSLayoutConstraint *ratioConstraint; //4/12
@property(nonatomic)GADInterstitial *interstitial; //428 %%1
@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //#9 下行是把note 的資料傳到下一行資料出來 課本245頁資料傳書
    self.textView.text = self.currentNote.text;
    self.imageView.image = self.currentNote.image;
    
    //@15 設計一個橘色編筐
    self.imageView.layer.borderWidth = 10;
    self.imageView.layer.borderColor= [UIColor orangeColor].CGColor;
    //@16 設計一個圓角編筐
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;
    //4/12
    if ( self.presentingViewController ){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"cancel", @"") style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    }
    // 4/12 4:3的條件
    self.ratioConstraint = [self.imageView.heightAnchor constraintEqualToAnchor:self.imageView.widthAnchor multiplier:0.75];
    //4/12 只有垂直向才有 4:3條件
    if (self.traitCollection.verticalSizeClass== UIUserInterfaceSizeClassRegular) {
        self.ratioConstraint.active =YES;
        
//        //428 橫幅廣告%%2
//        self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1147209557956753/8115512223"];
//        self.interstitial.delegate = self;
        GADRequest *request = [GADRequest request];
//        [request setTestDevices:@[kGADSimulatorID]];//設定模擬器載入假廣告
        [self.interstitial loadRequest:request];
        
    }
   }

//4/12
-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if ( newCollection.verticalSizeClass ==
        UIUserInterfaceSizeClassCompact){
        //橫向
        //不能4:3
        self.ratioConstraint.active = NO;
        
    }else{
        //直向
        //4：3
        self.ratioConstraint.active = YES;
    }
    //重算toolbar高度
    [self.toolbar invalidateIntrinsicContentSize];
}

//4/12
-(void)cancel{
    if ( self.presentingViewController ){
        ListViewController * listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"people"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:listViewController];
        [self presentViewController:navi animated:YES completion:nil];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

//3/17 @1
- (IBAction)done:(id)sender {
    self.currentNote.text = self.textView.text;
    if ( self.isNewImage ){
        
        //設定檔名. noteID.jpg
        self.currentNote.imageName = [NSString stringWithFormat:@"%@.jpg",self.currentNote.noteID];
        //home + Documents
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //圖檔真實位置，/home/Documents/xxxx.jpg
        NSString *imagePath = [docPath stringByAppendingPathComponent:self.currentNote.imageName];
        //轉成JPEG格式的NSData
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1);
        //寫入指定的位置
        [imageData writeToFile:imagePath atomically:YES];
    }

    //3/17@9
     //如果協定是optional，則必須要先檢查才能呼叫
     if ( [self.delegate respondsToSelector:@selector(didFinishUpdateNote:)]){
     [self.delegate didFinishUpdateNote:self.currentNote];
     }
     
    /*做@11的動作
    //@ 13 發送通知，並傳入self.currentNote，key值為"note"
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"NoteUpdated"
     object:nil userInfo:@{@"note":self.currentNote}];
     */
    

    [self.delegate didFinishUpdateNote:self.currentNote];//@6將屬性delegate
    
    //428 %%3
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }else{
    
    if ( self.presentingViewController ){
        ListViewController * listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"people"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:listViewController];
        [self presentViewController:navi animated:YES completion:nil];
    }else{
    [self.navigationController popViewControllerAnimated:YES];//@6
    }
    }
////    把畫面上的狀態更新回Note物件
//    UIViewController *secondVC =  self.navigationController.viewControllers[1];
//    [self.navigationController popToViewController:secondVC animated:YES];
//    

}

- (IBAction)camera:(id)sender {
    //@12相機的方法
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    //sourceType 指定
    pickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
    
}
#pragma mark UIImagePickerControllerDelegate 
//@13
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //@14 讓相簿選擇秀出來
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageView.image =image ;
    self.isNewImage =YES ;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark GADInterstitialDelegate
//428 %%4
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    if ( self.presentingViewController ){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
//428 %%5
-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    
    //使用者下載應用程式，有賺錢
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ( self.presentingViewController  ){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
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
