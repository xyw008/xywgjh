//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

#define SubviewTag 50000

@interface MyScaleScrollView : UIScrollView <UIScrollViewDelegate>

//@property (nonatomic, assign) UIImage *image;

/// 以center为中心点放大或缩小scroll
- (void)zoomToPointInRootView:(CGPoint)center;

@end
