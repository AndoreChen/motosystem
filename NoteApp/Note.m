//
//  Note.m
//  NoteApp
//
//  Created by user33 on 2017/3/14.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "Note.h"

@implementation Note
//$5 設定dynamic
@dynamic noteID;
@dynamic text;
@dynamic imageName;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.noteID =[[NSUUID UUID] UUIDString]; //設定唯一,不會重複的類別
    }
    return self;
}
//$7 coredata, 會再新增之前執行
-(void)awakeFromInsert{
    self.noteID =[[NSUUID UUID] UUIDString];

}
//@16將照片文字存擋
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //從檔案解回變物件
        self.text = [coder decodeObjectForKey:@"text"]; //上面KEY值要跟下面一樣
        self.imageName = [coder decodeObjectForKey:@"imageName"];
        self.noteID = [coder decodeObjectForKey:@"noteID"];
        
    }
    return self;
}
   //物件寫到檔案
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.text forKey:@"text"];//@text上面就要Text
    [aCoder encodeObject:self.imageName forKey:@"imageName"];
    [aCoder encodeObject:self.noteID forKey:@"noteID"];
    
}

-(UIImage *)image{
    NSString *docPath = [NSHomeDirectory()
                         stringByAppendingPathComponent:@"Documents"];
    //@12圖檔真實位置，/home/Documents/xxxx.jpg
    NSString *imagePath = [ docPath stringByAppendingPathComponent:self.imageName];
      //@13 窄入後是沒有cache
    return  [UIImage imageWithContentsOfFile:imagePath];
}
//@14 將image檔案做縮圖 280頁
-(UIImage*) thumbnailImage{
    UIImage *image = [self image];
    if ( !image){
        return nil;
    }
    CGSize thumbnailSize = CGSizeMake(50, 50); //設定縮圖大小
    CGFloat scale = [UIScreen mainScreen].scale; //找出目前螢幕的scale，視網膜技術為2.0
    //產生畫布，第一個參數指定大小,第二個參數YES:不透明（黑色底）,false表示透明背景,scale為螢幕scale
    UIGraphicsBeginImageContextWithOptions(thumbnailSize, NO, scale);
    
    //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
    //最小值MIN會變成UIViewContentModeScaleAspectFit
    CGFloat widthRatio = thumbnailSize.width / image.size.width;
    CGFloat heightRadio = thumbnailSize.height / image.size.height;
    CGFloat ratio = MAX(widthRatio,heightRadio);
    
    CGSize imageSize = CGSizeMake(image.size.width*ratio, image.size.height*ratio);
    //@14 下行做完切成原型圖 上面YES要改成NO
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height)];
    [circlePath addClip];
    
    
    [image drawInRect:CGRectMake(-(imageSize.width-thumbnailSize.width)/2.0, -(imageSize.height-thumbnailSize.height)/2.0,
                                 imageSize.width, imageSize.height)];
    
    
    [image drawInRect:CGRectMake(-(imageSize.width-thumbnailSize.width)/2.0,
                            -(imageSize.height-thumbnailSize.height)/2.0,
                                 imageSize.width, imageSize.height)];
    //上方式顯示圓型
    
    //取得畫布上的縮圖
    image = UIGraphicsGetImageFromCurrentImageContext();
    //關掉畫布
    UIGraphicsEndImageContext();
    return image;
    
}

@end
