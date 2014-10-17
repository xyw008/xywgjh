//
//  MyPopupController.m
//  KidsPainting
//
//  Created by HJC on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "YGPopupController.h"



@implementation YGPopupController
@synthesize contentView = _contentView;
@synthesize delegate = _delegate;
@synthesize behavior = _behaviorType;
@synthesize tapView = _tapView;
@synthesize animated = _animated;

- (void) dealloc
{
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    _tapView.delegate = nil;
    [_tapView removeFromSuperview];
    _contentView = nil;
}



- (id) initWithContentView:(UIView*)aView
{
    self = [super init];
    if (self)
    {
        _animated = YES;
        _contentView = aView;
        //将模式设置为手动隐藏
        _behaviorType = YGPopupBehavior_AutoHidden;
    }
    return self;
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
        if ([_delegate respondsToSelector:@selector(YGPopupControllerDidShow:)])
        {
            [_delegate YGPopupControllerDidShow:self];
        }
    }
    else if ([animationID isEqualToString:[[self class] nameOfHideAnimation]])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([_delegate respondsToSelector:@selector(YGPopupControllerWillHidden:)])
        {
            [_delegate YGPopupControllerDidHidden:self];
        }
    }
}

- (void) showInView:(UIView*)inView animated:(YGPopAnimatedType)type isSetFrame:(BOOL)isFrame
{
    if (_behaviorType == YGPopupBehavior_AutoHidden ||
        _behaviorType == YGPopupBehavior_MessageBox)
    {
        if (_tapView == nil)
        {
            _tapView = [[ATTapView alloc] init];
            _tapView.alpha = 0.5f;
            _tapView.delegate = self;
        }
        if (isFrame) {
            _tapView.frame = _tapFrame;
        }else
        {
            _tapView.frame = inView.bounds;
        }
        
        [_tapView removeFromSuperview];
        [inView addSubview:_tapView];
    }
    
    [_contentView removeFromSuperview];
    [inView addSubview:_contentView];
    
    CGRect startFrame = CGRectMake(0, 0, 0, 0);
    CGRect moveToFrame = CGRectMake(0, 0, 0, 0);
    
    _animatedType = type;
    switch (type)
    {
        case YGPopAnimatedType_Nothing:
            if ([_delegate respondsToSelector:@selector(YGPopupControllerDidShow:)])
            {
                [_delegate YGPopupControllerDidShow:self];
            }
            //注意这里直接 return
            return;
        case YGPopAnimatedType_Alpha:
            startFrame = _contentView.frame;
            moveToFrame = _contentView.frame;
            break;
        case YGPopAnimatedType_CurlUp:
            startFrame = CGRectMake(0, -_contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
            moveToFrame = CGRectMake(0, 0, _contentView.frameWidth, _contentView.frameHeight);
            break;
        case YGPopAnimatedType_CurlDown:
            startFrame = CGRectMake(0, inView.frameHeight + _contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
            moveToFrame = CGRectMake(0, inView.frameHeight - _contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
            break;
        default:
            break;
    }
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    _contentView.frame = startFrame;
    _contentView.alpha = 0.0f;
    _tapView.alpha = 0.0f;
    [UIView beginAnimations:[[self class] nameOfShowAnimation] context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:kYGPopupControllerAnimationDruation];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    _contentView.frame = moveToFrame;
    _contentView.alpha = 1.0f;
    _tapView.alpha = 0.5f;
    [UIView commitAnimations];
    
}

- (void) showInView:(UIView*)inView animated:(BOOL)animated
{
    if (animated)
    {
        [self showInView:inView animated:YGPopAnimatedType_Alpha isSetFrame:NO];
    }else
    {
        [self showInView:inView animated:YGPopAnimatedType_Nothing isSetFrame:NO];
    }
//    [self showInView:inView animated:animated isSetFrame:NO];
}

- (void)showInView:(UIView *)inView animated:(BOOL)animated tapFrame:(CGRect)frame
{
    _tapFrame = frame;
    [self showInView:inView animated:YGPopAnimatedType_Alpha isSetFrame:YES];
}

- (void)showInView:(UIView *)inView animatedType:(YGPopAnimatedType)type
{
    [self showInView:inView animated:type isSetFrame:NO];
}

- (void) hideAnimatied:(BOOL)animated
{
    if (animated)
    {
        CGRect moveToFrame = CGRectMake(0, 0, 0, 0);
        switch (_animatedType)
        {
            case YGPopAnimatedType_Nothing:
            case YGPopAnimatedType_Alpha:
                moveToFrame = _contentView.frame;
                break;
            case YGPopAnimatedType_CurlUp:
                moveToFrame = CGRectMake(0, -_contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
                break;
            case YGPopAnimatedType_CurlDown:
                moveToFrame = CGRectMake(0, _contentView.frameOrigin.y + _contentView.frameHeight, _contentView.frameWidth, _contentView.frameHeight);
                break;
            default:
                break;
        }
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView beginAnimations:[[self class] nameOfHideAnimation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:kYGPopupControllerAnimationDruation];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        _contentView.frame = moveToFrame;
        if (YGPopAnimatedType_Alpha)
        {
            _contentView.alpha = 0.0f;
            _tapView.alpha = 0.0f;
        }
        [UIView commitAnimations];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(YGPopupControllerDidHidden:)])
        {
            [_delegate YGPopupControllerDidHidden:self];
        }
    }
}

- (void) ATTapViewDidTouchBegin:(ATTapView*)aView
{
    if ([_delegate respondsToSelector:@selector(YGPopupControllerWillHidden:)])
    {
        [_delegate YGPopupControllerWillHidden:self];
    }
}


- (void) ATTapViewDidTouchEnded:(ATTapView*)aView
{
    [_contentView endEditing:YES];
    if (_behaviorType == YGPopupBehavior_AutoHidden)
    {
        [self hideAnimatied:_animated];
    }
}


@end
