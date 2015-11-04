//
//  CardFlipView.m
//  AppleTreePageInterface
//
//  Created by David on 11-6-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ATFlipAnimationView.h"
#import <QuartzCore/QuartzCore.h>


//////////////////////////////////////////
@interface ATFlipAnimationView() 
- (void) _animationLeftToRight;
- (void) _animationRightToLeft;
@end



@implementation ATFlipAnimationView
@synthesize duration = _animationDuration;
@synthesize animationType = _animationType;
@synthesize delegate = _delegate;


- (void) dealloc
{
//	[_leftFromLayer release];
//	[_rightFromLayer release];
//    
//	[_leftToLayer release];
//	[_rightToLayer release];
//    
//    [_fromBlackLayer release];
//    [_toBlackLayer release]; 
//    [_flipLayer release];
//    
//    [super dealloc];
}



- (CGSize) _halfSize
{
    CGSize size = self.bounds.size;
    size.width *= 0.5;
    return size;
}



- (id) initWithSize:(CGSize)imageSize
{
    self = [super initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    if (self)
    {
        _flipLayer = [[CALayer alloc] init];
        _flipLayer.frame = self.bounds;
        _flipLayer.opaque = YES;
        [self.layer addSublayer:_flipLayer];
        
        self.backgroundColor = [UIColor clearColor];
        _animationType = ATFlipAnimationType_RightToLeft;
        
        _fromBlackLayer = [[CALayer alloc] init];
        _fromBlackLayer.backgroundColor = [UIColor blackColor].CGColor;
        _fromBlackLayer.opacity = 0.0f;
        
        _toBlackLayer = [[CALayer alloc] init];
        _toBlackLayer.backgroundColor = [UIColor blackColor].CGColor;
        _toBlackLayer.opacity = 0.0f;
    }
    return self;
}




- (void) _resetLayers
{
    [self.layer removeAllAnimations];
    [_flipLayer removeAllAnimations];
    
    _flipLayer.sublayerTransform = CATransform3DIdentity;
    _flipLayer.transform = CATransform3DIdentity;
    
    [_leftToLayer removeFromSuperlayer];
    [_rightToLayer removeFromSuperlayer];
    [_leftFromLayer removeFromSuperlayer];
    [_rightFromLayer removeFromSuperlayer];
    [_fromBlackLayer removeFromSuperlayer];
    [_toBlackLayer removeFromSuperlayer];
}



- (void) startAnimation
{
    [self _resetLayers];

    [CATransaction begin];
    [CATransaction setCompletionBlock:^(void){
        if ([_delegate respondsToSelector:@selector(flipAnimationViewDidFinishAnimation:)])
        {
            [_delegate flipAnimationViewDidFinishAnimation:self];
        }
    }];
    
    switch (_animationType) 
    {
        case ATFlipAnimationType_LeftToRight:
            [self _animationLeftToRight];
            break;
            
        case ATFlipAnimationType_RightToLeft:
            [self _animationRightToLeft];
            break;
            
        default:
            break;
    }
    
    [CATransaction commit];
}



- (CABasicAnimation*) _createAnimationWithKeyPath:(NSString*)keyPath 
                                        fromTrans:(CATransform3D)from
                                          toTrans:(CATransform3D)to
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = [NSValue valueWithCATransform3D:from];
    animation.toValue = [NSValue valueWithCATransform3D:to];
    animation.duration = _animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}


- (CAKeyframeAnimation*) _createKeyAnimationWithKeyPath:(NSString*)keyPath
                                              fromTrans:(CATransform3D)from
                                               midTrans:(CATransform3D)min
                                                toTrans:(CATransform3D)to
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = [NSArray arrayWithObjects:
                        [NSValue valueWithCATransform3D:from],
                        [NSValue valueWithCATransform3D:min],
                        [NSValue valueWithCATransform3D:to], nil];
    animation.duration = _animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}


- (void) _addBlackAnimations
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = _animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_fromBlackLayer addAnimation:animation forKey:nil];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = _animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_toBlackLayer addAnimation:animation forKey:nil];
}



- (void) _animationLeftToRight
{    
    CGSize halfSize = [self _halfSize];
    CGRect leftRect = CGRectMake(0, 0, halfSize.width, halfSize.height);
    CGRect rightRect = CGRectMake(halfSize.width, 0, halfSize.width, halfSize.height);
    
    _leftToLayer.frame = leftRect;
    [self.layer addSublayer:_leftToLayer];
    
    _rightFromLayer.frame = rightRect;
    [self.layer addSublayer:_rightFromLayer];
    
    _flipLayer.zPosition = 0.1;
    _leftFromLayer.frame = leftRect;
    [_flipLayer addSublayer:_leftFromLayer];
    
    _fromBlackLayer.frame = leftRect;
    _fromBlackLayer.zPosition = _leftFromLayer.zPosition + 0.01;
    [_flipLayer addSublayer:_fromBlackLayer];
    
    _rightToLayer.frame = leftRect;
    _rightToLayer.zPosition = -1;
    _rightToLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [_flipLayer addSublayer:_rightToLayer];
    
    _toBlackLayer.frame = leftRect;
    _toBlackLayer.zPosition = _rightToLayer.zPosition - 0.01;
    [_flipLayer addSublayer:_toBlackLayer];
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0 / 2000.0;
    _flipLayer.sublayerTransform = trans;
    
    trans = CATransform3DRotate(_flipLayer.sublayerTransform, M_PI, 0, 1, 0);
    CATransform3D min = CATransform3DRotate(_flipLayer.sublayerTransform, M_PI / 2.0, 0, 1, 0);
    
    CAKeyframeAnimation* animation = [self _createKeyAnimationWithKeyPath:@"sublayerTransform"
                                                                fromTrans:_flipLayer.sublayerTransform
                                                                 midTrans:min
                                                                  toTrans:trans];
    [_flipLayer addAnimation:animation forKey:nil];
    _flipLayer.sublayerTransform = trans;
    
    [self _addBlackAnimations];
}


- (void) _animationRightToLeft
{
    CGSize halfSize = [self _halfSize];
    CGRect leftRect = CGRectMake(0, 0, halfSize.width, halfSize.height);
    CGRect rightRect = CGRectMake(halfSize.width, 0, halfSize.width, halfSize.height);
    
    _leftFromLayer.frame = leftRect;
    [self.layer addSublayer:_leftFromLayer];
    
    _rightToLayer.frame = rightRect;
    [self.layer addSublayer:_rightToLayer];
    
    _flipLayer.zPosition = 0.1;
    _rightFromLayer.frame = rightRect;
    _rightToLayer.zPosition = 0;
    [_flipLayer addSublayer:_rightFromLayer];
    
    _fromBlackLayer.frame = rightRect;
    _fromBlackLayer.zPosition = _rightToLayer.zPosition + 0.01;
    [_flipLayer addSublayer:_fromBlackLayer];
    
    _leftToLayer.frame = rightRect;
    _leftToLayer.zPosition = -1;
    _leftToLayer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    [_flipLayer addSublayer:_leftToLayer];
    
    _toBlackLayer.frame = rightRect;
    _toBlackLayer.zPosition = _leftToLayer.zPosition - 0.01;
    [_flipLayer addSublayer:_toBlackLayer];
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0 / 2000.0;
    _flipLayer.sublayerTransform = trans;
    
    trans = CATransform3DRotate(_flipLayer.sublayerTransform, -M_PI, 0, 1, 0);
    CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                          fromTrans:_flipLayer.sublayerTransform
                                                            toTrans:trans];
    [_flipLayer addAnimation:animation forKey:nil];
    _flipLayer.sublayerTransform = trans;
    
    [self _addBlackAnimations];
}



static void _configureLayer(CALayer*__strong* player, UIImage* image, CGSize size)
{
    if (*player == nil)
    {
        *player = [[CALayer alloc] init];
    }
    CALayer* layer = *player;
    layer.transform = CATransform3DIdentity;
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.contents = (id)image.CGImage;
    layer.zPosition = 0.0f;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
}



- (void) setFromImage:(UIImage *)fromImage
{
    CGSize halfSize = [self _halfSize];
    _configureLayer(&_leftFromLayer, fromImage, halfSize);
    _leftFromLayer.contentsGravity = kCAGravityLeft;
    _leftFromLayer.masksToBounds = YES;
    
    _configureLayer(&_rightFromLayer, fromImage, halfSize);
    _rightFromLayer.contentsGravity = kCAGravityRight;
    _rightFromLayer.masksToBounds = YES;
}



- (void) setToImage:(UIImage *)toImage
{
    CGSize halfSize = [self _halfSize];
    _configureLayer(&_leftToLayer, toImage, halfSize);
    _leftToLayer.contentsGravity = kCAGravityLeft;
    _leftToLayer.masksToBounds = YES;
    
    _configureLayer(&_rightToLayer, toImage, halfSize);
    _rightToLayer.contentsGravity = kCAGravityRight;
    _rightToLayer.masksToBounds = YES;
}



@end
