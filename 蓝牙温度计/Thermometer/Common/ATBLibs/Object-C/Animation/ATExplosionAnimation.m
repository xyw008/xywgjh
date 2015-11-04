//
//  ATExplosionAnimation.m
//  ATBLibs
//
//  Created by HJC on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATExplosionAnimation.h"
#import <QuartzCore/QuartzCore.h>


@implementation ATExplosionAnimation
@synthesize attachedView = _attachedView;
@synthesize explosionPoint = _explosionPoint;
@synthesize delegate = _delegate;


- (void) dealloc
{
    for (UIView* aView in _smallImageViews)
    {
        [aView removeFromSuperview];
    }
//    [_image release];
//    [_smallImageViews release];
//    [super dealloc];
}



- (id) initWithImage:(UIImage*)image
{
    self = [super init];
    if (self)
    {
        _image = image;
        _smallImageViews = [[NSMutableArray alloc] initWithCapacity:20];
        self.imageCount = 20;
    }
    return self;
}



static CAAnimationGroup* _ExplosionAnimation(CGPoint center, CGFloat degree, CGFloat radius)
{
    CGPoint toPoint = center;
    toPoint.x += radius * cos(degree) - rand()% 50;
    toPoint.y += radius * sin(degree) - rand()% 50;
    
    CABasicAnimation* posAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    posAnimation.fromValue = [NSValue valueWithCGPoint:center];
    posAnimation.toValue = [NSValue valueWithCGPoint:toPoint];
    
    
    CAKeyframeAnimation* opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:1.0], 
                               [NSNumber numberWithFloat:1.0], 
                               [NSNumber numberWithFloat:0.0], nil];
    
    opacityAnimation.keyTimes = [NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0], 
                                 [NSNumber numberWithFloat:0.9], 
                                 [NSNumber numberWithFloat:1.0], nil];
    
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values =  [NSArray arrayWithObjects:
                         [NSNumber numberWithFloat:1.0], 
                         [NSNumber numberWithFloat:2.5], 
                         [NSNumber numberWithFloat:1.0], 
                         [NSNumber numberWithFloat:1.5], nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0], 
                          [NSNumber numberWithFloat:0.45], 
                          [NSNumber numberWithFloat:0.9], 
                          [NSNumber numberWithFloat:1.0], nil];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:posAnimation, opacityAnimation, animation, nil];
    return group;
}



- (void) startAnimation
{
    for (UIView* aView in _smallImageViews)
    {
        if (aView.superview != _attachedView)
        {
            [aView removeFromSuperview];
            [_attachedView addSubview:aView]; 
        }
    }
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^
     {
         for (UIView* aView in _smallImageViews)
         {
             [aView removeFromSuperview];
         }
         
         if ([_delegate respondsToSelector:@selector(ATExplosionAnimationDidStop:)])
         {
             [_delegate ATExplosionAnimationDidStop:self];
         }
     }];
    
    CGFloat angle = 0.0f;
    for (UIView* aView in _smallImageViews)
    {
        
        CGFloat radian = (M_PI / 180.0f * angle);
        CGFloat time = (rand() % 15) / 20.0;
        CAAnimation* animation = _ExplosionAnimation(_explosionPoint, radian, 100);
        animation.delegate = self;
        animation.duration = time;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [aView.layer addAnimation:animation forKey:nil];
        aView.alpha = 0.0f;
        angle += 30;
    }
    
    [CATransaction commit];
}


- (void) setImageCount:(NSInteger)count
{
    if (count > [_smallImageViews count])
    {
        NSInteger tmp = count - [_smallImageViews count];
        for (NSInteger idx = 0; idx < tmp; idx++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
            imageView.frame = CGRectMake(0, 0, 10, 10);
            [_smallImageViews addObject:imageView];
        }
    }
    else if (count < [_smallImageViews count])
    {
        NSInteger total = [_smallImageViews count];
        for (NSInteger idx = count; idx < total; idx++)
        {
            UIView* aView = [_smallImageViews objectAtIndex:idx];
            [aView removeFromSuperview];
        }
        
        while ([_smallImageViews count] != count)
        {
            [_smallImageViews removeLastObject];
        }
    }
}


- (NSInteger) imageCount
{
    return [_smallImageViews count];
}



@end
