//
//  MyScrollView.m
//  PhotoBrowserEx
//
//  Created by on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyScaleScrollView.h"

@interface MyScaleScrollView ()
{
//	UIImageView *imageView;
    
    BOOL isScaled;
}

@end

@implementation MyScaleScrollView

//@synthesize image;

#pragma mark -
#pragma mark === Intilization ===
#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
        isScaled = NO;
        
        self.bounces = YES;
		self.delegate = self;
		self.minimumZoomScale = 1.0;
		self.maximumZoomScale = 2.0;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		
        /*
		UIImageView *tempImgView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		//imageView.contentMode = UIViewContentModeCenter;
		[self addSubview:tempImgView];
        imageView = tempImgView;
        [tempImgView release];
         */
    }
    return self;
}

/*
- (void)setImage:(UIImage *)img
{
	imageView.image = img;
}
 */

//为了跟安卓的效果保持一直,先把以下的代码屏蔽起来,不实现放大缩小
- (void)zoomToPointInRootView:(CGPoint)center atScale:(float)scale
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    [self zoomToRect:zoomRect animated:YES];
}

- (void)zoomToPointInRootView:(CGPoint)center
{
    if (isScaled == YES)
    {
        [self zoomToPointInRootView:center atScale:1];
    }
    else
    {
        [self zoomToPointInRootView:center atScale:2];
    }
    isScaled = !isScaled;
}


#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{	
//	return imageView;
    
    UIView *subView = [self viewWithTag:SubviewTag];
    
    if (subView)
    {
        return subView;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [self viewWithTag:SubviewTag];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    /*
    NSLog(@"%s", _cmd);
    
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, 1.0);
	zs = MIN(zs, 2.0);
    
    [scrollView setZoomScale:zs animated:YES];
     */
    
    if (scale > 1.0)
        isScaled = YES;
    else
        isScaled = NO;
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
    NSLog(@"%s", _cmd);
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) 
	{
		//NSLog(@"double click");
		
		CGFloat zs = self.zoomScale;
		zs = (zs == 1.0) ? 2.0 : 1.0;
		
      [scrollView setZoomScale:zs animated:YES];
	}
     */
    
    if ([[touches anyObject] tapCount] == 2)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        if (isScaled == YES)
        {
            [self zoomToPointInRootView:point atScale:1];
        }
        else
        {
            [self zoomToPointInRootView:point atScale:2];
        }
        isScaled = !isScaled;
    }
}
        
#pragma mark -
#pragma mark === dealloc ===
#pragma mark -

- (void)dealloc
{
//    [image release];
}

@end
