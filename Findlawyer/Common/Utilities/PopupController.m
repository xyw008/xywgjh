//
//  PopupController.m
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PopupController.h"

@implementation PopupController

@synthesize contentView = _contentView;
@synthesize delegate = _delegate;
@synthesize behavior = _behaviorType;
@synthesize tapView = _tapView;
@synthesize animated = _animated;

- (void) dealloc
{
    [self clearViews];
    
    _tapView.delegate = nil;
}

- (id) initWithContentView:(UIView*)aView
{
    self = [super init];
    if (self)
    {
        _animated = YES;
        _contentView = aView;
        // 将模式设置为自动隐藏
        _behaviorType = PopupBehavior_AutoHidden;
    }
    return self;
}

- (void)clearViews
{
    [_contentView removeFromSuperview];
    _contentView = nil;
    [_tapView removeFromSuperview];
    _tapView = nil;
}

- (void)removeViewsFromSuperview
{
    if (_tapView.superview)
    {
        [_tapView removeFromSuperview];
    }
    
    if (_contentView.superview)
    {
        [_contentView removeFromSuperview];
    }
}

- (void)setTopframe:(CGRect)topframe
{
    _tapView.frame = topframe;
}

+ (NSString*) nameOfShowAnimation
{
    return @"AnimationShow";
}


+ (NSString*) nameOfHideAnimation
{
    return @"AnimationHide";
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:[[self class] nameOfShowAnimation]])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([_delegate respondsToSelector:@selector(PopupControllerDidShow:)])
        {
            [_delegate PopupControllerDidShow:self];
        }
    }
    else if ([animationID isEqualToString:[[self class] nameOfHideAnimation]])
    {
//        [self clearViews];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([_delegate respondsToSelector:@selector(PopupControllerDidHidden:)])
        {
            [_delegate PopupControllerDidHidden:self];
        }
    }
}

- (void)showInView:(UIView *)inView animatedType:(PopAnimatedType)type
{
    if (_tapView && _tapView.superview)
    {
        [_tapView removeFromSuperview];
        _tapView = nil;
    }
    
    if (_contentView && _contentView.superview)
    {
        [_contentView removeFromSuperview];
    }
    
    if (_behaviorType == PopupBehavior_AutoHidden || _behaviorType == PopupBehavior_MessageBox)
    {
        _tapView = [[ATTapView alloc] initWithFrame:inView.bounds];
        _tapView.backgroundColor = [UIColor blackColor];
        _tapView.alpha = 0.5f;
        _tapView.delegate = self;
        
        [inView addSubview:_tapView];
    }
    
    [inView addSubview:_contentView];
    
    // 执行动画
    if (_animated)
    {
        void (^animationBeginBlock)();
        void (^animationExecuteBlock)();
        
        _animatedType = type;
        
        WEAKSELF
        switch (_animatedType)
        {
            case PopAnimatedType_Fade:
            {
                animationBeginBlock = ^{
                    _contentView.alpha = 0.0;
                };
                
                animationExecuteBlock = ^{
                    _contentView.alpha = 1.0;
                };
            }
                break;
            case PopAnimatedType_CurlUp:
            {
                animationBeginBlock = ^{
                    _contentView.transform = CGAffineTransformIdentity;
                    
                    _contentView.alpha = 0.0;
                    _contentView.frame = CGRectMake(0, 0, _contentView.frameWidth, _contentView.frameHeight);
                    _contentView.transform = CGAffineTransformMakeTranslation(0, -_contentView.boundsHeight);
                };
                
                animationExecuteBlock = ^{
                    _contentView.alpha = 1.0;
                    _contentView.transform = CGAffineTransformIdentity;
                };
            }
                break;
            case PopAnimatedType_CurlDown:
            {
                animationBeginBlock = ^{
                    _contentView.transform = CGAffineTransformIdentity;
                    
                    _contentView.alpha = 0.0;
                    _contentView.frame = CGRectMake(0, inView.frameHeight - _contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
                    _contentView.transform = CGAffineTransformMakeTranslation(0, _contentView.boundsHeight);
                };
                
                animationExecuteBlock = ^{
                    _contentView.alpha = 1.0;
                    _contentView.transform = CGAffineTransformIdentity;
                };
            }
                break;
            case PopAnimatedType_MiddleFlyIn:
            {
                
                animationBeginBlock = ^{
                    _contentView.transform = CGAffineTransformIdentity;
                    
                    _contentView.alpha = 0.0;
                    _contentView.center = CGPointMake(CGRectGetWidth(inView.frame) / 2, CGRectGetHeight(inView.frame) / 2);
                    _contentView.transform = CGAffineTransformMakeScale(2, 2);
                };
                
                animationExecuteBlock = ^{
                    _contentView.alpha = 1.0;
                    _contentView.transform = CGAffineTransformIdentity;
                };
            }
                break;
            default:
                break;
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
       
        _tapView.alpha = 0.0f;
        animationBeginBlock();
        
        [UIView beginAnimations:[[self class] nameOfShowAnimation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:kPopupControllerAnimationDruation];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
      
        _tapView.alpha = 0.5f;
        animationExecuteBlock();
        
        [UIView commitAnimations];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(PopupControllerDidShow:)])
        {
            [_delegate PopupControllerDidShow:self];
        }
    }
}

- (void)hide
{
    if (_animated)
    {
        void (^animationExecuteBlock)();
        
        WEAKSELF
        switch (_animatedType)
        {
            case PopAnimatedType_Fade:
            {
                animationExecuteBlock = ^{
                    _contentView.alpha = 0.0;
                };
            }
                break;
            case PopAnimatedType_CurlUp:
            {
                animationExecuteBlock = ^{
                    _contentView.alpha = 0.0;
                    _contentView.transform = CGAffineTransformMakeTranslation(0, -_contentView.boundsHeight);
                };
            }
                break;
            case PopAnimatedType_CurlDown:
            {
                animationExecuteBlock = ^{
                    _contentView.alpha = 0.0;
                    _contentView.transform = CGAffineTransformMakeTranslation(0, _contentView.boundsHeight);
                };
            }
                break;
            case PopAnimatedType_MiddleFlyIn:
            {
                
                animationExecuteBlock = ^{
                    _contentView.alpha = 0.0;
                    _contentView.transform = CGAffineTransformMakeScale(2, 2);
                };
            }
                break;
            default:
                break;
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [UIView beginAnimations:[[self class] nameOfHideAnimation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:kPopupControllerAnimationDruation];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        _tapView.alpha = 0.0f;
        animationExecuteBlock();
        
        [UIView commitAnimations];
    }
    else
    {
        [self removeViewsFromSuperview];
        
        if ([_delegate respondsToSelector:@selector(PopupControllerDidHidden:)])
        {
            [_delegate PopupControllerDidHidden:self];
        }
    }
}

- (void) ATTapViewDidTouchBegin:(ATTapView*)aView
{
    if (_behaviorType == PopupBehavior_AutoHidden)
    {
        if ([_delegate respondsToSelector:@selector(PopupControllerWillHidden:)])
        {
            [_delegate PopupControllerWillHidden:self];
        }
    }
}

- (void) ATTapViewDidTouchEnded:(ATTapView*)aView
{
    [_contentView endEditing:YES];
    
    if (_behaviorType == PopupBehavior_AutoHidden)
    {
        [self hide];
    }
}

@end
