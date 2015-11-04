//
//  UIView+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by Sam Soffes on 2/15/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import <UIKit/UIKit.h> 

/**
 Provides extensions to `UIView` for various common tasks.
 */
typedef void (^animationExecuteBlock)();

/**
 @ 修改描述     划线的位置
 @ 修改人       龚俊慧
 @ 修改时间     2014-09-18
 */
typedef enum
{
    ViewDrawLinePostionType_Top,
    ViewDrawLinePostionType_Bottom,
    ViewDrawLinePostionType_Left,
    ViewDrawLinePostionType_Right,
    
}ViewDrawLinePostionType;

@interface UIView (SSToolkitAdditions)

@property(nonatomic) CGSize  size;
@property(nonatomic) CGPoint origin;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;


///-------------------------
/// @name Taking Screenshots
///-------------------------

/**
 Takes a screenshot of the underlying `CALayer` of the receiver and returns a `UIImage` object representation.
 
 @return An image representing the receiver
 */
- (UIImage *)imageRepresentation;


///-------------------------
/// @name Hiding and Showing
///-------------------------

/**
 Sets the `alpha` value of the receiver to `0.0`.
 */
- (void)hide;

/**
 Sets the `alpha` value of the receiver to `1.0`.
 */
- (void)show;


///------------------------
/// @name Fading In and Out
///------------------------

/**
 Fade out the receiver.
 
 The receiver will fade out in `0.2` seconds.
 */
- (void)fadeOut;

/**
 Fade out the receiver and remove from its super view
 
 The receiver will fade out in `0.2` seconds and be removed from its `superview` when the animation completes.
 */
- (void)fadeOutAndRemoveFromSuperview;

/**
 Fade in the receiver.
 
 The receiver will fade in in `0.2` seconds.
 */
- (void)fadeIn;


///----------------------------------
/// @name Managing the View Hierarchy
///----------------------------------

/**
 Returns an array of the receiver's superviews.
 
 The immediate super view is the first object in the array. The outer most super view is the last object in the array.
 
 @return An array of view objects containing the receiver
 */
- (NSArray *)superviews;

/**
 Returns the first super view of a given class.
 
 If a super view is not found for the given `superviewClass`, `nil` is returned.
 
 @param superviewClass A Class to search the `superviews` for
 
 @return A view object or `nil`
 */
- (id)firstSuperviewOfClass:(Class)superviewClass;


/****************************************View调试********************************************************************/
- (void)printSubviews;
- (void)printSubviewsWithIndentString:(NSString *)indentString;

- (NSArray *)subviewsMatchingClass:(Class)aClass;
- (NSArray *)subviewsMatchingOrInheritingClass:(Class)aClass;

- (void)populateSubviewsMatchingClass:(Class)aClass
                              inArray:(NSMutableArray *)array
                           exactMatch:(BOOL)exactMatch;


/****************************************动画效果********************************************************************/


- (void)startRotationAnimatingWithDuration:(CGFloat)duration;                   //开始旋转动画
- (void)stopRotationAnimating;                                                  //停止旋转动画
- (void)pauseAnimating;                                                         //暂停动画
- (void)resumeAnimating;                                                        //恢复动画

- (void)animationRevealWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;         //揭开
- (void)animationFadeWithExecuteBlock:(animationExecuteBlock)block;                                           //渐隐渐消
- (void)animationFlipWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;           //翻转
- (void)animationRotateAndScaleEffectsWithExecuteBlock:(animationExecuteBlock)block;                          //各种旋转缩放效果
- (void)animationRotateAndScaleDownUpWithExecuteBlock:(animationExecuteBlock)block;                           //旋转同时缩小放大效果
- (void)animationPushWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;           //push
- (void)animationCurlWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;           //Curl
- (void)animationUnCurlWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;         //UnCurl
- (void)animationMoveWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;           //Move
- (void)animationCubeWithExecuteBlock:(animationExecuteBlock)block direction:(NSString *)direction;           //立方体
- (void)animationRippleEffectWithExecuteBlock:(animationExecuteBlock)block;                                   //水波纹
- (void)animationCameraEffectWithExecuteBlock:(animationExecuteBlock)block type:(NSString *)type;             //相机开合
- (void)animationSuckEffectWithExecuteBlock:(animationExecuteBlock)block;                                     //吸收
- (void)animationBounceOutWithExecuteBlock:(animationExecuteBlock)block;
- (void)animationBounceInWithExecuteBlock:(animationExecuteBlock)block;
- (void)animationBounceWithExecuteBlock:(animationExecuteBlock)block;


/**
 *  产生一个Image的倒影，并把这个倒影图片加在一个View上面。
 *  @param  image:被倒影的原图。
 *  @param  frame:盖在上面的图。
 *  @param  opacity:倒影的透明度，0为完全透明，即倒影不可见;1为完全不透明。
 *  @param  view:倒影加载在上面。
 *  return  产生倒影后的View。
 */
+ (UIView *)reflectImage:(UIImage *)image withFrame:(CGRect)frame opacity:(CGFloat)opacity atView:(UIView *)view;

/// 划线
- (void)addLineWithPosition:(ViewDrawLinePostionType)position lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth;
- (void)addLineWithPosition:(ViewDrawLinePostionType)position startPointOffset:(CGFloat)startOffset endPointOffset:(CGFloat)endOffset lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth;

@end
