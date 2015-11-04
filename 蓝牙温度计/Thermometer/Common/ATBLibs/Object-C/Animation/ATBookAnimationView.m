//
//  BookOpenAnimtationView.m
//  ChineseCharacters
//
//  Created by HJC on 11-6-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBookAnimationView.h"


extern CGAffineTransform  ATBookTransformMake(CGPoint transition, CGFloat scale, CGFloat rotation)
{
    CGAffineTransform trans = CGAffineTransformMakeTranslation(transition.x, transition.y);
    trans = CGAffineTransformScale(trans, scale, scale);
    trans = CGAffineTransformRotate(trans, rotation);
    return trans;
}


//////////////////////////////////////////////////////////////////////////////

@implementation ATBookAnimationView
@synthesize animationType = _animationType;
@synthesize duration = _animationDuration;
@synthesize delegate = _delegate;


- (void) dealloc
{
//    [_leftPageLayer release];
//    [_rightPageLayer release];
//    [_frontCoverLayer release];
//    [_backCoverLayer release];
//    [_sideLayer release];
//    [_flipBookLayer release];
//    [_coverShadowLayer release];
//    [super dealloc];
}



- (CGSize) _halfSize
{
    CGSize size = self.bounds.size;
    size.width *= 0.5;
    return size;
}



- (id) initWithPageSize:(CGSize)size
{
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self)
    {
        _flipBookLayer = [[CALayer alloc] init];
        _flipBookLayer.frame = self.bounds;
        _flipBookLayer.opaque = YES;
        [self.layer addSublayer:_flipBookLayer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void) _resetLayers
{
    [self.layer removeAllAnimations];
    [_flipBookLayer removeAllAnimations];
    
    _flipBookLayer.sublayerTransform = CATransform3DIdentity;
    _flipBookLayer.transform = CATransform3DIdentity;
    self.layer.transform = CATransform3DIdentity;
    self.layer.sublayerTransform = CATransform3DIdentity;
    
    [_leftPageLayer removeFromSuperlayer];
    [_rightPageLayer removeFromSuperlayer];
    [_frontCoverLayer removeFromSuperlayer];
    [_backCoverLayer removeFromSuperlayer];
    [_sideLayer removeFromSuperlayer];
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




- (void) _initFrontAndBackLayer
{
    [self.layer addSublayer:_backCoverLayer];
    [self.layer addSublayer:_frontCoverLayer];
    [self.layer addSublayer:_sideLayer];
    [self.layer addSublayer:_coverShadowLayer];
    
    CGSize halfSize = [self _halfSize];
    CGRect centerRect;
    centerRect.origin = CGPointMake(halfSize.width * 0.5, 0);
    centerRect.size = halfSize;
    
    _backCoverLayer.frame = centerRect;
    _frontCoverLayer.frame = centerRect;
    
    CGRect shadowRect = CGRectInset(centerRect, -30, -30);
    shadowRect = CGRectOffset(shadowRect, 15, 20);
    _coverShadowLayer.frame = shadowRect;
    
    _backCoverLayer.transform = CATransform3DMakeRotation(M_PI / 180.0 * 180, 0, 1, 0);
    
    _frontCoverLayer.zPosition = MAX(0.1, _sideLayer.frame.size.width * 0.5);
    _coverShadowLayer.zPosition = _frontCoverLayer.zPosition * 0.5;
    _backCoverLayer.zPosition = MIN(-0.1, -_sideLayer.frame.size.width * 0.5);
    
    _sideLayer.position = CGPointMake(CGRectGetMinX(centerRect), CGRectGetMidY(centerRect));
    _sideLayer.transform = CATransform3DMakeRotation(M_PI / 180.0 * 90.0, 0, 1, 0);
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0 / 2000.0;
    self.layer.sublayerTransform = trans;
}



- (void) _initPageAndFrontLayer
{
    [_flipBookLayer addSublayer:_leftPageLayer];
    [_flipBookLayer addSublayer:_frontCoverLayer];
    [_flipBookLayer addSublayer:_sideLayer];
    [_flipBookLayer addSublayer:_coverShadowLayer];
    
    [self.layer addSublayer:_rightPageLayer];
    
    _rightPageLayer.zPosition = -0.1;
    _frontCoverLayer.zPosition = MAX(0.1, _sideLayer.frame.size.width);
    _coverShadowLayer.zPosition = _frontCoverLayer.zPosition * 0.5;
    
    CGSize halfSize = [self _halfSize];
    CGRect rightRect;
    rightRect.origin = CGPointMake(halfSize.width, 0);
    rightRect.size = halfSize;
    
    _leftPageLayer.anchorPoint = CGPointMake(0, 0.5);
    _frontCoverLayer.anchorPoint = CGPointMake(0, 0.5);
    
    _leftPageLayer.frame = rightRect;
    _rightPageLayer.frame = rightRect;
    _frontCoverLayer.frame = rightRect;
    
    CGRect shadowRect = CGRectInset(rightRect, -30, -30);
    shadowRect = CGRectOffset(shadowRect, 15, 20);
    _coverShadowLayer.frame = shadowRect;
    
    _sideLayer.anchorPoint = CGPointMake(1, 0);
    _sideLayer.position = CGPointMake(CGRectGetMaxX(rightRect), 0);
    _sideLayer.transform = CATransform3DMakeRotation(M_PI / 180.0 * 90.0, 0, 1, 0);
    
    
    CATransform3D originTrans = CATransform3DMakeTranslation(halfSize.width * 0.5, 0, 0);
    originTrans = CATransform3DRotate(originTrans, M_PI / 180.0 * 180, 0, 1, 0);
    originTrans = CATransform3DTranslate(originTrans, -halfSize.width * 0.5, 0, 0);
    _leftPageLayer.transform = originTrans;
    
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0 / 2000.0;
    _flipBookLayer.sublayerTransform = trans;
}



- (void) _initPageAndBackLayer
{
    [_flipBookLayer addSublayer:_rightPageLayer];
    [_flipBookLayer addSublayer:_backCoverLayer];
    [_flipBookLayer addSublayer:_sideLayer];
    
    [self.layer addSublayer:_leftPageLayer];
    
    _leftPageLayer.zPosition = -0.1;
    _backCoverLayer.zPosition = MAX(0.1, _sideLayer.frame.size.width);
    
    
    CGRect leftRect;
    CGSize halfSize = [self _halfSize];
    leftRect.origin = CGPointMake(0, 0);
    leftRect.size = halfSize;
    
    _rightPageLayer.anchorPoint = CGPointMake(1, 0.5);
    _backCoverLayer.anchorPoint = CGPointMake(1, 0.5);
    
    _leftPageLayer.frame = leftRect;
    _rightPageLayer.frame = leftRect;
    _backCoverLayer.frame = leftRect;
    
    _sideLayer.anchorPoint = CGPointMake(1, 0);
    _sideLayer.position = CGPointMake(CGRectGetMinX(leftRect), 0);
    _sideLayer.transform = CATransform3DMakeRotation(M_PI / 180.0 * 90.0, 0, 1, 0);
    
    
    CATransform3D originTrans = CATransform3DMakeTranslation(-halfSize.width * 0.5, 0, 0);
    originTrans = CATransform3DRotate(originTrans, M_PI / 180.0 * 180, 0, 1, 0);
    originTrans = CATransform3DTranslate(originTrans, halfSize.width * 0.5, 0, 0);
    _rightPageLayer.transform = originTrans;
    
    
    CATransform3D trans = CATransform3DIdentity;
    trans.m34 = -1.0 / 2000.0;
    _flipBookLayer.sublayerTransform = trans;
}





- (void) _animationFrontToPage
{
    [self _initPageAndFrontLayer];
    
    CATransform3D trans = CATransform3DRotate(_flipBookLayer.sublayerTransform, -M_PI, 0, 1, 0);
    CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                          fromTrans:_flipBookLayer.sublayerTransform
                                                            toTrans:trans];
    _flipBookLayer.sublayerTransform = trans;
    
    CGSize halfSize = [self _halfSize];
    trans = CATransform3DTranslate(CATransform3DIdentity, -halfSize.width * 0.5, 0, 0);
    CABasicAnimation* animation2 = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                           fromTrans:trans
                                                             toTrans:CATransform3DIdentity];
    [_flipBookLayer addAnimation:animation forKey:nil];
    [self.layer addAnimation:animation2 forKey:nil];
    
    if (_enableTransform)
    {
        CATransform3D trans = _transform3D;
        CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"transform"
                                                              fromTrans:trans
                                                                toTrans:CATransform3DIdentity];
        [self.layer addAnimation:animation forKey:nil];
    }
}



- (void) _animationBackToPage
{
    [self _initPageAndBackLayer];
    
    CATransform3D to = CATransform3DRotate(_flipBookLayer.sublayerTransform, M_PI, 0, 1, 0);
    CATransform3D min = CATransform3DRotate(_flipBookLayer.sublayerTransform, M_PI / 2.0, 0, 1, 0);
    
    CAKeyframeAnimation* animation = [self _createKeyAnimationWithKeyPath:@"sublayerTransform"
                                                                fromTrans:_flipBookLayer.sublayerTransform
                                                                 midTrans:min
                                                                  toTrans:to];
    [_flipBookLayer addAnimation:animation forKey:nil];
    _flipBookLayer.sublayerTransform = to;
    
    CGSize halfSize = [self _halfSize];
    CATransform3D trans = CATransform3DTranslate(CATransform3DIdentity, halfSize.width * 0.5, 0, 0);
    CABasicAnimation* animation2 = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                           fromTrans:trans
                                                             toTrans:CATransform3DIdentity];
    [self.layer addAnimation:animation2 forKey:nil];
}


- (void) _animationPageToFront
{
    [self _initPageAndFrontLayer];
    
    CATransform3D trans = CATransform3DRotate(_flipBookLayer.sublayerTransform, -M_PI, 0, 1, 0);
    CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                          fromTrans:trans 
                                                            toTrans:_flipBookLayer.sublayerTransform];
    [_flipBookLayer addAnimation:animation forKey:nil];
    
    CGSize halfSize = [self _halfSize];
    trans = CATransform3DTranslate(CATransform3DIdentity, -halfSize.width * 0.5, 0, 0);
    CABasicAnimation* animation2 = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                           fromTrans:self.layer.sublayerTransform
                                                             toTrans:trans];
    self.layer.sublayerTransform = trans;
    [self.layer addAnimation:animation2 forKey:nil];
}



- (void) _animationPageToBack
{
    [self _initPageAndBackLayer];
    
    CATransform3D from = CATransform3DRotate(_flipBookLayer.sublayerTransform, M_PI, 0, 1, 0);
    CATransform3D min = CATransform3DRotate(_flipBookLayer.sublayerTransform, M_PI / 2.0, 0, 1, 0);
    
    CAKeyframeAnimation* animation = [self _createKeyAnimationWithKeyPath:@"sublayerTransform"
                                                                fromTrans:from
                                                                 midTrans:min
                                                                  toTrans:_flipBookLayer.sublayerTransform];
    [_flipBookLayer addAnimation:animation forKey:nil];
    
    CGSize halfSize = [self _halfSize];
    CATransform3D trans = CATransform3DTranslate(CATransform3DIdentity, halfSize.width * 0.5, 0, 0);
    CABasicAnimation* animation2 = [self _createAnimationWithKeyPath:@"sublayerTransform"
                                                           fromTrans:self.layer.sublayerTransform
                                                             toTrans:trans];
    self.layer.sublayerTransform = trans;
    [self.layer addAnimation:animation2 forKey:nil];
    
    if (_enableTransform)
    {
        CATransform3D trans = _transform3D;
        CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"transform"
                                                              fromTrans:CATransform3DIdentity
                                                                toTrans:trans];
        self.layer.transform = trans;
        [self.layer addAnimation:animation forKey:nil];
    }
}



- (void) _animationFrontToBack
{
    [self _initFrontAndBackLayer];
    
    CATransform3D to = CATransform3DRotate(self.layer.sublayerTransform, M_PI, 0, 1, 0);
    CATransform3D min = CATransform3DRotate(self.layer.sublayerTransform, M_PI / 2.0, 0, 1, 0);
    
    CAKeyframeAnimation* animation = [self _createKeyAnimationWithKeyPath:@"sublayerTransform"
                                                                fromTrans:self.layer.sublayerTransform
                                                                 midTrans:min
                                                                  toTrans:to];
    
    [self.layer addAnimation:animation forKey:nil];
    self.layer.sublayerTransform = to;
}



- (void) _animationBackToFront
{
    [self _initFrontAndBackLayer];
    
    CATransform3D from = CATransform3DRotate(self.layer.sublayerTransform, M_PI, 0, 1, 0);
    CATransform3D min = CATransform3DRotate(self.layer.sublayerTransform, M_PI / 2.0, 0, 1, 0);
    
    CAKeyframeAnimation* animation = [self _createKeyAnimationWithKeyPath:@"sublayerTransform"
                                                                fromTrans:from
                                                                 midTrans:min
                                                                  toTrans:self.layer.sublayerTransform];
    
    [self.layer addAnimation:animation forKey:nil];
    
    CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    basicAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    basicAnimation.duration = _animationDuration;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [_coverShadowLayer addAnimation:basicAnimation forKey:nil];
    
    if (_enableTransform)
    {
        CATransform3D trans = _transform3D;
        CABasicAnimation* animation = [self _createAnimationWithKeyPath:@"transform"
                                                              fromTrans:CATransform3DIdentity
                                                                toTrans:trans];
        self.layer.transform = trans;
        [self.layer addAnimation:animation forKey:nil];
    }
}



- (BOOL) startAnimation
{
    [self _resetLayers];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^(void){
        if ([_delegate respondsToSelector:@selector(bookAnimationViewDidFinishAnimation:)])
        {
            [_delegate bookAnimationViewDidFinishAnimation:self];
        }
    }];
    
    switch (_animationType) 
    {
        case BookAnimationType_FrontToPage:
            [self _animationFrontToPage];
            break;
            
        case BookAnimationType_PageToFront:
            [self _animationPageToFront];
            break;
            
        case BookAnimationType_BackToFont:
            [self _animationBackToFront];
            break;
            
        case BookAnimationType_PageToBack:
            [self _animationPageToBack];
            break;
            
        case BookAnimationType_BackToPage:
            [self _animationBackToPage];
            break;
            
        case BookAnimationType_FrontToBack:
            [self  _animationFrontToBack];
            break;
            
        default:
            break;
    }
    
    [CATransaction commit];
    return YES;
}



static void _configureLayer(CALayer* __strong* player, UIImage* image, CGSize size)
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


- (void) setPageImage:(UIImage *)pageImage
{
    CGSize halfSize = [self _halfSize];
    CGSize pageSize = halfSize;
    pageSize.width *= 2.0f;
    
    if (!CGSizeEqualToSize(pageImage.size, self.bounds.size))
    {
        UIGraphicsBeginImageContext(pageSize);
        
        [pageImage drawInRect:CGRectMake(0, 0, pageSize.width, pageSize.height)];
        
        pageImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    // 左半页
    _configureLayer(&_leftPageLayer, pageImage, halfSize);
    _leftPageLayer.contentsGravity = kCAGravityLeft;
    _leftPageLayer.masksToBounds = YES;
    
    // 右半页
    _configureLayer(&_rightPageLayer, pageImage, halfSize);
    _rightPageLayer.contentsGravity = kCAGravityRight;
    _rightPageLayer.masksToBounds = YES;
}



- (void) setFrontCoverImage:(UIImage *)frontCoverImage
{
    _configureLayer(&_frontCoverLayer, frontCoverImage, [self _halfSize]);
}


- (void) setBackCoverImage:(UIImage *)backCoverImage
{
    _configureLayer(&_backCoverLayer, backCoverImage, [self _halfSize]);
}


- (void) setSideImage:(UIImage *)coverSideImage
{
    CGSize size = [self _halfSize];
    size.width = coverSideImage.size.width;
    _configureLayer(&_sideLayer, coverSideImage, size);
}


- (void) setCoverShaodwImage:(UIImage *)coverShaodwImage
{
    _configureLayer(&_coverShadowLayer, coverShaodwImage, [self _halfSize]);
}


- (void) enableTransform:(CGAffineTransform)info;
{
    _transform3D = CATransform3DMakeAffineTransform(info);
    _enableTransform = YES;
}


- (void) disableTransform
{
    _enableTransform = NO;
}


@end
