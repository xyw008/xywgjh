//
//  AppUIElement.m
//  MaxDoodle
//
//  Created by gnef_jp on 13-1-3.
//  Copyright (c) 2013年 appletree. All rights reserved.
//

#import "AppSmallUtils.h"
#import "AppUIElement.h"

#pragma mark- ActivityIndicatorView
@implementation ActivityIndicatorView

- (void) dealloc
{
    CAAnimation* rotation = [_rotationLayer animationForKey:@"Rotation"];
    rotation.delegate = nil;
    [_rotationLayer removeAllAnimations];
}


- (void) _setLoadingImage
{
    UIImage* loadingImage = [UIImage imageNamed:@"common_loading.png"];
    loadingImage = [loadingImage changeImageWithColor:_color];
    
    _rotationLayer.contents = (id)loadingImage.CGImage;
}


- (void) awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
    _rotationLayer = [[CALayer alloc] init];
    _rotationLayer.frame = self.bounds;
    [self _setLoadingImage];
    [self.layer addSublayer:_rotationLayer];
}


- (void) setColor:(UIColor *)color
{
    [self _setLoadingImage];
}


- (void) startAnimating
{
    if (!_isAnimating)
    {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        animation.duration = 1.5;
        animation.repeatCount = FLT_MAX;
        animation.cumulative = YES;
        animation.delegate = self;
        [_rotationLayer addAnimation:animation forKey:@"Rotation"];
        _isAnimating = YES;
    }
}


- (void) stopAnimating
{
    if (_isAnimating)
    {
        [_rotationLayer removeAllAnimations];
        _isAnimating = NO;
    }
}


- (void) animationDidStart:(CAAnimation *)anim
{
    _isAnimating = YES;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _isAnimating = NO;
}

@end




#pragma mark- LineSpacingTextView
@interface UITextView ()
- (id)styleString; // make compiler happy
@end

@implementation LineSpacingTextView


- (id)styleString
{
    return [[super styleString] stringByAppendingString:@"; line-height: 37px"];
}

@end





