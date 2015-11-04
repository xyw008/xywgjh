//
//  ATExplosionAnimation.h
//  ATBLibs
//
//  Created by HJC on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


//////////////////////////////////////////////////////////////////

@class ATExplosionAnimation;
@protocol ATExplosionAnimationDelegate <NSObject>
@optional
- (void) ATExplosionAnimationDidStop:(ATExplosionAnimation*)animation;
@end


//////////////////////////////////////////////////////////////////
@interface ATExplosionAnimation : NSObject
{
@private
    UIImage*                        _image;
    __unsafe_unretained UIView*                         _attachedView;
    CGPoint                         _explosionPoint;
    NSMutableArray*                 _smallImageViews;
    __unsafe_unretained id<ATExplosionAnimationDelegate>_delegate;
}
@property (nonatomic, assign)   UIView*     attachedView;
@property (nonatomic, assign)   CGPoint     explosionPoint;
@property (nonatomic, assign)   NSInteger   imageCount;
@property (nonatomic, assign)   id          delegate;


- (id) initWithImage:(UIImage*)image;
- (void) startAnimation;

@end


///////////////////////////////////////////////////////////////////////////


