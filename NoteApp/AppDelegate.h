//
//  AppDelegate.h
//  NoteApp
//
//  Created by Vincent on 2017/3/13.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"//!1
@import SystemConfiguration;//!1
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic) Reachability *reachability;//!1


@end

