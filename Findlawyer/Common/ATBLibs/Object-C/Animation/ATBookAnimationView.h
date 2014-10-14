//
//  BookOpenAnimtationView.h
//  ChineseCharacters
//
//  Created by HJC on 11-6-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


// 动画类型
typedef enum
{
    BookAnimationType_FrontToPage,      // 从封面，打开书
    BookAnimationType_BackToPage,       // 从封低，打开书
    BookAnimationType_PageToFront,      // 收起书本，到封面
    BookAnimationType_PageToBack,       // 收起书本，到封底
    BookAnimationType_FrontToBack,      // 从封面转到封底
    BookAnimationType_BackToFont,       // 从封底转到封面
} BookAnimationType;


////////////////////////////////////////////////////////////

extern CGAffineTransform ATBookTransformMake(CGPoint transition, CGFloat scale, CGFloat rotation);

/////////////////////////////////////////


@class ATBookAnimationView;
@protocol ATBookAnimationViewDelegate<NSObject>

@optional
- (void) bookAnimationViewDidFinishAnimation:(ATBookAnimationView*)aView;

@end

                                                
/////////////////////////////////////////
@class CALayer;
@interface ATBookAnimationView : UIView 
{ 
@private    
    CALayer*            _flipBookLayer;
    CALayer*            _leftPageLayer;
    CALayer*            _rightPageLayer;
    CALayer*            _frontCoverLayer;
    CALayer*            _backCoverLayer;
    CALayer*            _sideLayer;
    CALayer*            _coverShadowLayer;
      
    BookAnimationType   _animationType;
    CGFloat             _animationDuration;
    CATransform3D       _transform3D;
    
    BOOL                _enableTransform;
    id<ATBookAnimationViewDelegate> _delegate;
}
@property (nonatomic, assign)   BookAnimationType   animationType;
@property (nonatomic, assign)   CGFloat             duration;
@property (nonatomic, assign)   id                  delegate;

- (id) initWithPageSize:(CGSize)size;

- (BOOL) startAnimation; 

// 页面
- (void) setPageImage:(UIImage *)pageImage;

// 封面
- (void) setFrontCoverImage:(UIImage *)frontCoverImage;

// 封底
- (void) setBackCoverImage:(UIImage *)backCoverImage;

// 侧边
- (void) setSideImage:(UIImage *)coverSideImage;

// 封面的阴影
- (void) setCoverShaodwImage:(UIImage *)coverShaodwImage;

// 添加一个转换，使得图书可以从小到大的打开
- (void) enableTransform:(CGAffineTransform)info;
- (void) disableTransform;

@end


