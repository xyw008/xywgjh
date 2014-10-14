//
//  CardFlipView.m
//  AppleTreePageInterface
//
//  Created by David on 11-6-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum
{
    ATFlipAnimationType_LeftToRight,
    ATFlipAnimationType_RightToLeft,
} ATFlipAnimationType;



//////////////////////////////////////////////////////////////////////////////
@class ATFlipAnimationView;
@protocol ATFlipAnimationViewDelegate<NSObject>
@optional
- (void) flipAnimationViewDidFinishAnimation:(ATFlipAnimationView*)aView;
@end


////////////////////////////////////////////////////////////////////////////////////////////////
@interface ATFlipAnimationView : UIView 
{
@private    
    CALayer*                        _leftFromLayer;
    CALayer*                        _rightFromLayer;
    CALayer*                        _leftToLayer;
    CALayer*                        _rightToLayer;
    CALayer*                        _fromBlackLayer;
    CALayer*                        _toBlackLayer;
    CALayer*                        _flipLayer;
    
	CGFloat                         _animationDuration;
    ATFlipAnimationType             _animationType;
    id<ATFlipAnimationViewDelegate> _delegate;
}

@property (nonatomic, assign)   ATFlipAnimationType animationType;
@property (nonatomic, assign)   CGFloat             duration;
@property (nonatomic, assign)   id                  delegate;

- (id)      initWithSize:(CGSize)imageSize;
- (void)    startAnimation;

- (void) setFromImage:(UIImage *)fromImage;
- (void) setToImage:(UIImage *)toImage;


@end

