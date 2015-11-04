//
//  MyPopupController.h
//  KidsPainting
//
//  Created by HJC on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTapView.h"

#define kATPopupControllerAnimationDruation 0.3

@class ATPopupController;
@protocol ATPopupControllerDelegate <NSObject>
@optional
- (void) ATPopupControllerDidShow:(ATPopupController*)aController;
- (void) ATPopupControllerDidHidden:(ATPopupController *)aController;
- (void) ATPopupControllerWillHidden:(ATPopupController *)aController;
@end



typedef enum
{
    ATPopupBehavior_AutoHidden,     // 自动隐藏
    ATPopupBehavior_ManualHidden,   // 手动隐藏
    ATPopupBehavior_MessageBox,     // 类似对话框，屏蔽外面的消息
} ATPopupBehaviorType;



@interface ATPopupController : NSObject
{
@protected
    UIView*                         _contentView;
    ATTapView*                      _tapView;
    ATPopupBehaviorType             _behaviorType;
//    id<ATPopupControllerDelegate>   _delegate;
    BOOL                            _animated;
}
@property (nonatomic, readonly) ATTapView*          tapView;
@property (nonatomic, readonly) UIView*             contentView;
@property (nonatomic, assign)   id                  delegate;
@property (nonatomic, assign)   ATPopupBehaviorType behavior;
@property (nonatomic, assign)   BOOL                animated;


+ (NSString*) nameOfShowAnimation;
+ (NSString*) nameOfHideAnimation;


- (id) initWithContentView:(UIView*)aView;

- (void) showInView:(UIView*)inView animated:(BOOL)animated;
- (void) hideAnimatied:(BOOL)animated;



@end


