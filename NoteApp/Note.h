//
//  Note.h
//  NoteApp
//
//  Created by user33 on 2017/3/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h> <~UIImage 定義在這裡面
@import  UIKit;
@import  CoreData; //使用coredata要先IMPORT
//上面是UIKit是定義UIimage
//@interface Note : NSObject<NSCoding>
//$2 要用資料庫打下面
@interface Note : NSManagedObject

@property(nonatomic) NSString *noteID;
@property(nonatomic) NSString *text;
//@property(nonatomic) UIImage *image; 不嚷他直接存照片
//＠10存圖檔名稱,NOTE ID(XXX-sddd-dsds).jpg ,如果這欄位有職表示使用者選過圖片
@property (nonatomic) NSString *imageName;
-(UIImage *)image; //改從系統債入圖片變成uiiamge
-(UIImage*) thumbnailImage; //@14縮圖
//上面三行propert 宣告三個區域變數
@end








