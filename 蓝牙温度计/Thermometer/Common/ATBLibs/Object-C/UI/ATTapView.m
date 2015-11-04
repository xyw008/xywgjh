//
//  UIBlackTapView.m
//  KidsPainting
//
//  Created by HJC on 11-10-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATTapView.h"


@implementation ATTapView
@synthesize delegate = _delegate;
@synthesize ignoreTap = _ignoreTap;
@synthesize touchEvent = _touchEvent;

- (void) dealloc
{
//    SafelyRelease(&_touchEvent);
//    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.0f;
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ignoreTap)
    {
        [super touchesBegan:touches withEvent:event];
    }
    
    if ([_delegate respondsToSelector:@selector(ATTapViewDidTouchBegin:)])
    {
        [_delegate ATTapViewDidTouchBegin:self];
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ignoreTap)
    {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    UITouch* touch = [touches anyObject];
    BOOL hasAction = NO;
    
    if (touch.tapCount == 1)
    {
        if ([_delegate respondsToSelector:@selector(ATTapViewDidTap:)])
        {
//            [_touchEvent release];
//            _touchEvent = [event retain];
            _touchEvent = event;
            [_delegate ATTapViewDidTap:self];
            hasAction = YES;
        }
    }

    if (!hasAction)
    {
        if ([_delegate respondsToSelector:@selector(ATTapViewDidTouchEnded:)])
        {
//            [_touchEvent release];
//            _touchEvent = [event retain];
            _touchEvent = event;
            [_delegate ATTapViewDidTouchEnded:self];
        }
    }
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ignoreTap)
    {
        [super touchesMoved:touches withEvent:event];
    }
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ignoreTap)
    {
        [super touchesCancelled:touches withEvent:event];
    }
}


@end
