//
//  NoteViewController.h
//  NoteApp
//
//  Created by user33 on 2017/3/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h" // #8的動作
@protocol NoteViewControllerDelegate <NSObject>//@8自訂一個協定
-(void)didFinishUpdateNote:(Note*)note;

@end
@interface NoteViewController : UIViewController
@property(nonatomic) Note * currentNote;//#8動作
@property(nonatomic,weak) id<NoteViewControllerDelegate>  delegate;//@5 @7 改成ID 抽象畫不用＊@8讓ID有個協定可以遵循
@end
