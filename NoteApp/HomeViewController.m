//
//  HomeViewController.m
//  NoteApp
//
//  Created by 安德烈 on 2017/5/11.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "HomeViewController.h"
#import "ListViewController.h"
#import "FixViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)people:(id)sender {
   ListViewController * listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"people"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:navi animated:YES completion:nil];

}

- (IBAction)FixPeople:(id)sender {
    FixViewController * fixViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"fix"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:fixViewController];
    [self presentViewController:navi animated:YES completion:nil];
    
}
- (IBAction)goBtnPressed:(id)sender {
    NSString * targetagess = @"台北市大安區復興南路一段390號";
    
    CLGeocoder *geocoder1 = [CLGeocoder new]; //此行是將上面的住址轉經緯度
    //426 !3
    [geocoder1 geocodeAddressString:targetagess completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"geocoder fail: %@", error);
            return ; //如果有error 就回傳error
        }
        
        if (placemarks.count == 0) {
            NSLog(@"Can't find any result.");
            return;
        }
        
        CLPlacemark * placemark = placemarks.firstObject;
        CLLocationCoordinate2D coordinate = placemark.location.coordinate ;
        
        NSLog(@"%@ ==> %f,%f",targetagess,coordinate.latitude,coordinate.longitude); //檢查經緯度正不正確
        
        // 決定來源的地圖總類 Decide Source MapItem
        
        CLLocationCoordinate2D sourceCoordinate =
        CLLocationCoordinate2DMake(249.86525, 121.515312);
        
        MKPlacemark *sourcePlace =[[MKPlacemark alloc]initWithCoordinate:sourceCoordinate];
        MKMapItem *sourceMapItem = [[MKMapItem alloc]initWithPlacemark:sourcePlace];
        
        // 426 !6 Decide Target MapItem
        MKPlacemark *targetPlace = [[MKPlacemark alloc]initWithPlacemark:placemark];
        MKMapItem *targetItem = [[MKMapItem alloc]initWithPlacemark:targetPlace];
        //options 426 !7
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                                  };
        // 426!8 下行是從現在位置導航到目的地
        //[targetItem openInMapsWithLaunchOptions:options];
        
        //426!9 下行是知道兩個位置的座標
        [MKMapItem openMapsWithItems:@[sourceMapItem,targetItem] launchOptions:options];
        
    }];
    
    //426!4 反過來用經緯度查住址 Reverse Geocoder
    CLGeocoder *geocoder2 = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:24.994323  longitude:121.541464];
    
    //Latitude緯度 longitude經度;
    
    [geocoder2 reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //426!5 //決定來源地圖種類
        CLPlacemark * placemark = placemarks.firstObject;
        NSLog(@"Address: %@", placemark.addressDictionary);
        NSLog(@"PostCode %@", placemark.postalCode);
        
        
        
    }];
    

    
    
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
