//
//  ServiceViewController.m
//  
//
//  Created by user33 on 2017/5/9.
//
//

#import "ServiceViewController.h"

@interface ServiceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *input1;
@property (weak, nonatomic) IBOutlet UITextField *input2;
@property (weak, nonatomic) IBOutlet UITextField *input3;
@property (weak, nonatomic) IBOutlet UITextField *input4;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)sum:(id)sender {
    NSString * text1 = self.input1.text ;
    NSString * text2 = self.input2.text;
    NSString * text3 = self.input3.text;
    NSString * text4 = self.input4.text;
    NSInteger value1 = [text1 integerValue];
    NSInteger value2 = [text2 integerValue];
    NSInteger value3 = [text3 integerValue];
    NSInteger value4 = [text4 integerValue];
    NSString * result = [NSString stringWithFormat:@"%ld",(value1 + value2+ value3+ value4)];
    
    self.resultLabel.text = result;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
