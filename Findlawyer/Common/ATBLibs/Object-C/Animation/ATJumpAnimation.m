//
//  ATJumpAnimation.m
//  LearnPinyin
//
//  Created by HJC on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATJumpAnimation.h"
#import <QuartzCore/QuartzCore.h>


@implementation ATJumpAnimation
@synthesize attachedView = _attachedView;
@synthesize duration = _duration;
@synthesize isAnimating = _isAnimating;
@synthesize delegate = _delegate;
@synthesize jumpHeight = _jumpHeight;
@synthesize shadowColor = _shadowColor;


- (void) dealloc
{
    [_shadowImageView release];
    [_shadowColor release];
    [super dealloc];
}


- (id) init
{
    if (self = [super init])
    {
        _jumpHeight = 23;
        _duration = 1;
    }
    return self;
}


- (CGFloat) durationOfJumpUp
{
    return (_duration * 0.4);
}


- (CGFloat) durationOfJumpDown
{
    return (_duration * 0.6);
}



- (void) startAnimation
{
    if (_isAnimating)
    {
        return;
    }
    
    _isAnimating = YES; 
	if(nil == _shadowImageView)
	{
        // 生成ShadowImage
        CGSize shadowSize = _attachedView.bounds.size;
        UIGraphicsBeginImageContext(shadowSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_attachedView.layer renderInContext:context];
        UIImage* shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIColor* shadowColor = _shadowColor;
        if (shadowColor == nil)
        {
            shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        }
        
        CGContextTranslateCTM(context, 0, -shadowSize.height);
        CGContextSetShadowWithColor(context, 
                                    CGSizeMake(0, shadowSize.height), 
                                    2, 
                                    shadowColor.CGColor);
        
        CGContextClearRect(context, CGRectMake(0, 0, shadowSize.width, shadowSize.height));
        [shadowImage drawAtPoint:CGPointMake(0, 0)];
        shadowImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _shadowImageView = [[UIImageView alloc] initWithImage:shadowImage];
        _shadowImageView.frame = _attachedView.frame;
        [_attachedView.superview insertSubview:_shadowImageView belowSubview:_attachedView];
	}
    
	_shadowImageView.hidden = NO;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:self.durationOfJumpUp];
    
    CGAffineTransform trans = CGAffineTransformMakeScale(1.2, 1.2);
    trans = CGAffineTransformRotate(trans, -2 * M_PI / 180.0);
    
    CGAffineTransform thisTrans = CGAffineTransformConcat(
                                                          CGAffineTransformMakeTranslation(0, -_jumpHeight), trans);
	_attachedView.transform = thisTrans;
	_shadowImageView.transform = trans;
    
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationFinishJumpUp)];
	[UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(ATJumpAnimationWillStartJumpUp:)])
    {
        [_delegate ATJumpAnimationWillStartJumpUp:self];
    }
}


- (void) _animationFinishJumpUp
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:self.durationOfJumpDown];
    
	_attachedView.transform = CGAffineTransformIdentity;
	_shadowImageView.transform = CGAffineTransformIdentity;
    _shadowImageView.alpha = 0.0;
    
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(_animationFinishJumpDown)];
	[UIView commitAnimations];
    
    if ([_delegate respondsToSelector:@selector(ATJumpAnimationWillStartJumpDown:)])
    {
        [_delegate ATJumpAnimationWillStartJumpDown:self];
    }
}



-(void) _animationFinishJumpDown
{    
    [_shadowImageView removeFromSuperview];
    [_shadowImageView release];
	_shadowImageView = nil;
    
    BOOL isAnimation = _isAnimating;
    _isAnimating = NO;
    if (isAnimation)
    {
        if ([_delegate respondsToSelector:@selector(ATJumpAnimationDidStop:)])
        {
            [_delegate ATJumpAnimationDidStop:self];
        }
    }
}



- (void) stopAnimation
{
    if (_isAnimating)
    {
        _isAnimating = NO;
        [_attachedView.layer removeAllAnimations];
        [_shadowImageView.layer removeAllAnimations];
        _attachedView.transform = CGAffineTransformIdentity;
        
        [_shadowImageView removeFromSuperview];
        [_shadowImageView release];
        _shadowImageView = nil;
    }
}


@end
