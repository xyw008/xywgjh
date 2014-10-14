//
//  PopupController.h
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTapView.h"

#define kPopupControllerAnimationDruation 0.2

@class PopupController;
@protocol PopupControllerDelegate <NSObject>
@optional
- (void) PopupControllerDidShow:(PopupController*)aController;
- (void) PopupControllerDidHidden:(PopupController *)aController;
- (void) PopupControllerWillHidden:(PopupController *)aController;
@end



typedef enum
{
    PopupBehavior_AutoHidden,     // 自动隐藏
    PopupBehavior_ManualHidden,   // 手动隐藏
    PopupBehavior_MessageBox,     // 类似对话框，屏蔽外面的消息
} PopupBehaviorType;


typedef enum
{
    PopAnimatedType_Fade,         // 淡入淡出
    PopAnimatedType_CurlUp,       // 由上到下出现
    PopAnimatedType_CurlDown,     // 由下到上出现
    PopAnimatedType_MiddleFlyIn,  // 由中间飞入出现
    
}PopAnimatedType;


@interface PopupController : NSObject
{
@protected
    UIView*                                 _contentView;
    ATTapView*                              _tapView;
    PopupBehaviorType                       _behaviorType;
    PopAnimatedType                         _animatedType;
    __weak id<PopupControllerDelegate>      _delegate;
    BOOL                                    _animated;
    /*
    CGRect                                  _tapFrame;
     */
    
}
@property (nonatomic, readonly) ATTapView*          tapView;
@property (nonatomic, readonly) UIView*             contentView;
@property (nonatomic, weak)     id                  delegate;
@property (nonatomic, assign)   PopupBehaviorType   behavior;   // default is PopupBehavior_AutoHidden
@property (nonatomic, assign)   BOOL                animated;   // default is YES


+ (NSString*) nameOfShowAnimation;
+ (NSString*) nameOfHideAnimation;

- (id) initWithContentView:(UIView*)aView;

- (void) showInView:(UIView *)inView animatedType:(PopAnimatedType)type;

- (void) hide;

@end


