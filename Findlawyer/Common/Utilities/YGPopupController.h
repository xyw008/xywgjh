//
//  MyPopupController.h
//  KidsPainting
//
//  Created by HJC on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTapView.h"

#define kYGPopupControllerAnimationDruation 0.3

@class YGPopupController;
@protocol YGPopupControllerDelegate <NSObject>
@optional
- (void) YGPopupControllerDidShow:(YGPopupController*)aController;
- (void) YGPopupControllerDidHidden:(YGPopupController *)aController;
- (void) YGPopupControllerWillHidden:(YGPopupController *)aController;
@end



typedef enum
{
    YGPopupBehavior_AutoHidden,     // 自动隐藏
    YGPopupBehavior_ManualHidden,   // 手动隐藏
    YGPopupBehavior_MessageBox,     // 类似对话框，屏蔽外面的消息
} YGPopupBehaviorType;


typedef enum
{
    YGPopAnimatedType_Nothing,//没动画
    YGPopAnimatedType_Alpha,//只是加半透明
    YGPopAnimatedType_CurlUp,//由上到下出现
    YGPopAnimatedType_CurlDown,//由下到上出现
}YGPopAnimatedType;


@interface YGPopupController : NSObject
{
@protected
    UIView*                                 _contentView;
    ATTapView*                              _tapView;
    YGPopupBehaviorType                     _behaviorType;
    YGPopAnimatedType                       _animatedType;
    __weak id<YGPopupControllerDelegate>    _delegate;
    BOOL                                    _animated;
    CGRect                                  _tapFrame;
    
}
@property (nonatomic, readonly) ATTapView*          tapView;
@property (nonatomic, readonly) UIView*             contentView;
@property (nonatomic, weak)     id                  delegate;
@property (nonatomic, assign)   YGPopupBehaviorType behavior;
@property (nonatomic, assign)   BOOL                animated;


+ (NSString*) nameOfShowAnimation;
+ (NSString*) nameOfHideAnimation;

- (id) initWithContentView:(UIView*)aView;

- (void) showInView:(UIView*)inView animated:(BOOL)animated;
- (void) showInView:(UIView*)inView animated:(BOOL)animated tapFrame:(CGRect)frame;
- (void) showInView:(UIView *)inView animatedType:(YGPopAnimatedType)type;

- (void) hideAnimatied:(BOOL)animated;



@end


