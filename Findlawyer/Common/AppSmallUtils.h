//
//  AppSmallUtils.h
//  PaintingBoard
//
//  Created by HJC on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

///////////////////////////////////////////////////////////////////////////
@interface AppCommonTool : NSObject

+ (NSString *) systemLanguage;

+ (void) warningNullText:(UIView*)view;

@end

////////////////////////////////////////////////////////////////////////

@interface UIView(_iOSUtils_Addtions)

- (UIButton*) buttonWithTouchUpInsideAction:(SEL)action;
- (UIButton*) buttonWithTag:(NSInteger)tag;

@end


///////////////////////////////////////////////////////////////////////////


@interface UIImage(_iOSUtils_Addtions)

- (NSArray*) imagesBySplitingColumn:(NSInteger)column row:(NSInteger)row;

@end

///////////////////////////////////////////////////////////////////////////
@interface UIImageView (Image_Animation)

- (void) setImage:(UIImage *)image animation:(BOOL)animation;

@end
///////////////////////////////////////////////////////////////////////////
@interface UIView (Color_Point)

- (UIColor *) colorOfPoint:(CGPoint)point;

@end

///////////////////////////////////////////////////////////////////////////

@interface UILabel (Lable_Height)

//获取label换行应有的高度（本身设置了高度、宽度、text的情况下使用）
- (CGFloat)labelHeight;

/**
 * 获取label 换行后的高度
 * 参数： text:宽度:默认高度
 */
 
- (CGFloat)labelText:(NSString*)text width:(CGFloat)width defaultHeight:(CGFloat)height;

/**
 * 类方法获取label 换行后的高度
 * 参数： text:宽度:默认高度:字体大小
 */

+ (CGFloat)labelText:(NSString*)text width:(CGFloat)width defaultHeight:(CGFloat)height font:(UIFont*)font;


@end

///////////////////////////////////////////////////////////////////////////

@interface UIImage (Color_Change)

- (UIImage*)changeImageWithColor:(UIColor*)color;

@end


///////////////////////////////////////////////////////////////////////////
@interface UIImage (Blur)
//-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end

///////////////////////////////////////////////////////////////////////////

@interface NSString(Network_Decode)

- (NSString*) networkDecode;

@end

///////////////////////////////////////////////////////////////////////////

@interface NSString(TimeStamp_Date)

- (NSDate*) ymdToDate;
+ (NSString*) nowDateForFormat:(NSString*)format;

@end




