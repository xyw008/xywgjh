//
//  ATJumpAnimation.h
//  LearnPinyin
//
//  Created by HJC on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ATJumpAnimation;
@protocol ATJumpAnimationDelegate <NSObject>
@optional
- (void) ATJumpAnimationWillStartJumpUp:(ATJumpAnimation*)animation;    // 就要开始跳起
- (void) ATJumpAnimationWillStartJumpDown:(ATJumpAnimation*)animation;  // 就要开始下落
- (void) ATJumpAnimationDidStop:(ATJumpAnimation*)animation;            // 动画全部做完
@end



// 跳动效果
@interface ATJumpAnimation : NSObject
{
@private
    UIImageView*                _shadowImageView;
    UIColor*                    _shadowColor;
//    UIView*                     _attachedView;
    CGFloat                     _duration;
    CGFloat                     _jumpHeight;
    BOOL                        _isAnimating;
//    id<ATJumpAnimationDelegate> _delegate;
}
@property (nonatomic, assign)   UIView* attachedView;       // 附加的view, 表示那个view需要做跳动
@property (nonatomic, assign)   CGFloat duration;           // 全部动画时间
@property (nonatomic, readonly) CGFloat durationOfJumpUp;   // 跳起过程的时间
@property (nonatomic, readonly) CGFloat durationOfJumpDown; // 下落的时间
@property (nonatomic, strong)   UIColor* shadowColor;       // 影子颜色
@property (nonatomic, assign)   CGFloat jumpHeight;         // 跳起的高度
@property (nonatomic, readonly) BOOL    isAnimating;        // 判断是否在动画
@property (nonatomic, assign)   id      delegate;           

- (id) init;

// 开始执行动画
- (void) startAnimation;

// 停止动画
- (void) stopAnimation;

@end

