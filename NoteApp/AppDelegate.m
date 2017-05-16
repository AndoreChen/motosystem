//
//  AppDelegate.m
//  NoteApp
//
//  Created by Vincent on 2017/3/13.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h> //428 !!1
#import <Crashlytics/Crashlytics.h> //428 !!1
@import Firebase; //428 ##1
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 428 ##2
    [FIRApp configure];
    // 428 !!2
        [Fabric with:@[[Crashlytics class]]];
    //!2
    self.reachability=[Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    [self networkChange];
    NSLog(@"home = %@",NSHomeDirectory()); //系統呼叫根目錄
    NSLog(@"boundle %@" ,[NSBundle mainBundle].bundlePath);
    
    return YES;
}
-(void)networkChange{
    if ([self.reachability currentReachabilityStatus]== ReachableViaWiFi) {
        NSLog(@"wifi");
    }else if([self.reachability currentReachabilityStatus]== ReachableViaWiFi) {
        NSLog(@"4G");
    }else if ([self.reachability currentReachabilityStatus]== ReachableViaWiFi) {
        NSLog(@"no internet connection");
        NSLog(@"@@@@@@@");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
