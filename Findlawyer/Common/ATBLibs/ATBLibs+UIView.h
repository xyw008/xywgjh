//
//  ATBLibs+UIView.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView(ATBLibsAddtions)

@property (nonatomic, assign) CGPoint   frameOrigin;    // 相当于self.frame.origin
@property (nonatomic, assign) CGSize    frameSize;      // 相当于self.frame.size
@property (nonatomic, assign) CGSize    boundsSize;     // 相当于self.bounds.size

@property (nonatomic, assign) CGFloat   boundsHeight;   // 相当于self.bounds.size.height
@property (nonatomic, assign) CGFloat   boundsWidth;    // 相当于self.bounds.size.width

@property (nonatomic, assign) CGFloat   frameHeight;   // 相当于self.frame.size.height
@property (nonatomic, assign) CGFloat   frameWidth;    // 相当于self.frame.size.width

@property (nonatomic, assign) CGFloat   frameOriginX;   // 相当于self.frame.origin.x
@property (nonatomic, assign) CGFloat   frameOriginY;   // 相当于self.frame.origin.y

// 查找属于cls类的子view, 另外可以指定是否递归遍历
- (id)  viewIsKindOf:(Class)cls recursive:(BOOL)recursive;

// 查找指定tag的子view
- (id)  viewWithTag:(NSInteger)tag recursive:(BOOL)recursive;


// 将view上面的内容转成图片, 这函数只能在主线程中调用
- (UIImage*) renderToImage;


// 相当于将autoresizingMask设置为
// UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
// UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
- (void) keepAutoresizingInMiddle;
- (void) keepAutoresizingInFull;



// 从nib文件中装载view
+ (id) loadFromNibNamed:(NSString*)name isKindOf:(Class)cls;
+ (id) loadFromNibNamed:(NSString*)name;
+ (id) loadFromNib;


// delay = 0.0, completion = NULL
+ (void) animateWithDuration:(NSTimeInterval)duration
                     options:(UIViewAnimationOptions)options 
                  animations:(void (^)(void))animations;

// 添加方法
- (void)addTarget:(id)target action:(SEL)action;

// 移除方法
- (void)removeGestureWithTarget:(id)target andAction:(SEL)action;

/// 加边框
- (void)addBorderToViewWitBorderColor:(UIColor *)borderColor borderWidth:(float)borderWidth;

/// 加阴影
- (void)shadowWithShadowColor:(UIColor *)color shadowRadius:(float)radius shadowOffset:(CGSize)offset shadowOpacity:(float)opacity;

/// 加圆角
- (void)setRadius:(CGFloat)radius;

@end




////////////////////////////////////////////////////////////
@interface UIViewController(ATBLibsAddtions)
+ (id) loadFromNibNamed:(NSString*)name;
+ (id) loadFromNib;
@end


////////////////////////////////////////////////////////////




///////////////////////////////
@interface UILabel(ATBLibsAddtions)
- (id) initWithText:(NSString*)text font:(UIFont*)font;
@end




@interface UISegmentedControl(ATBLibsAddtions)
+ (UISegmentedControl*) barSegmentWithTitles:(NSString*)title, ...;
@end




//////////////////////
extern CGFloat ATMaxWidthOfViews(NSArray* views);
extern CGFloat ATMaxHeightOfViews(NSArray* views);
extern CGFloat ATTotalWidthOfViews(NSArray* views);
extern CGFloat ATTotalHeightOfViews(NSArray* views);


