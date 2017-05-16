//
//  FixViewController.m
//  NoteApp
//
//  Created by 安德烈 on 2017/5/15.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "FixViewController.h"
#import "HomeViewController.h"
#import "ListViewController.h"
@interface FixViewController ()
{
    HomeViewController *homeViewController;
}
@end

@implementation FixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    homeViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"home"];
}
- (IBAction)people:(id)sender {
    ListViewController * listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"people"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:navi animated:YES completion:nil];
    

}
- (IBAction)Homeview:(id)sender{
    [self presentViewController:homeViewController animated:YES completion:nil];
}
- (IBAction)Mapview:(id)sender{
    [homeViewController goBtnPressed:sender];
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
