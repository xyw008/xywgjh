//
//  MyPopupController.m
//  KidsPainting
//
//  Created by HJC on 11-11-3.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATPopupController.h"

@implementation ATPopupController
@synthesize contentView = _contentView;
@synthesize delegate = _delegate;
@synthesize behavior = _behaviorType;
@synthesize tapView = _tapView;
@synthesize animated = _animated;

- (void) dealloc
{
    [_contentView removeFromSuperview];
    [_contentView release];
    _contentView = nil;
    
    [_tapView removeFromSuperview];
    [_tapView release];
    _contentView = nil;
    [super dealloc];
}



- (id) initWithContentView:(UIView*)aView
{
    self = [super init];
    if (self)
    {
        _animated = YES;
        _contentView = [aView retain];
        //将模式设置为手动隐藏
        _behaviorType = ATPopupBehavior_AutoHidden;
    }
    return self;
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
        if ([_delegate respondsToSelector:@selector(ATPopupControllerDidShow:)])
        {
            [_delegate ATPopupControllerDidShow:self];
        }
    }
    else if ([animationID isEqualToString:[[self class] nameOfHideAnimation]])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if ([_delegate respondsToSelector:@selector(ATPopupControllerDidHidden:)])
        {
            [_delegate ATPopupControllerDidHidden:self];
        }
    }
}



- (void) showInView:(UIView*)inView animated:(BOOL)animated
{
    if (_behaviorType == ATPopupBehavior_AutoHidden ||
        _behaviorType == ATPopupBehavior_MessageBox)
    {
        if (_tapView == nil)
        {
            _tapView = [[ATTapView alloc] initWithFrame:inView.bounds];
            _tapView.alpha = 1.0f;
            _tapView.backgroundColor = [UIColor clearColor];
            _tapView.delegate = self;
        }
        _tapView.frame = inView.bounds;

        [_tapView removeFromSuperview];
        [inView addSubview:_tapView];
    }
        
    [_contentView removeFromSuperview];
    [inView addSubview:_contentView];
    
    if (animated)
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        _contentView.alpha = 0.0f;
        
        [UIView beginAnimations:[[self class] nameOfShowAnimation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:kATPopupControllerAnimationDruation];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        _contentView.alpha = 1.0f;
        
        [UIView commitAnimations];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(ATPopupControllerDidShow:)])
        {
            [_delegate ATPopupControllerDidShow:self];
        }
    }
}



- (void) hideAnimatied:(BOOL)animated
{
    if (animated)
    {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView beginAnimations:[[self class] nameOfHideAnimation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:kATPopupControllerAnimationDruation];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        _contentView.alpha = 0.0f;
        
        [UIView commitAnimations];
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(ATPopupControllerDidHidden:)])
        {
            [_delegate ATPopupControllerDidHidden:self];
        }
    }
}

- (void) ATTapViewDidTouchBegin:(ATTapView*)aView
{
    if ([_delegate respondsToSelector:@selector(ATPopupControllerWillHidden:)])
    {
        [_delegate ATPopupControllerWillHidden:self];
    }
}



- (void) ATTapViewDidTouchEnded:(ATTapView*)aView
{
    [_contentView endEditing:YES];
    if (_behaviorType == ATPopupBehavior_AutoHidden)
    {
        [self hideAnimatied:_animated];
    }
}


@end
