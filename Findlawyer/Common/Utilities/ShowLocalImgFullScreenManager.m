//
//  ShowImgFullScreenManager.m
//  zmt
//
//  Created by gongjunhui on 13-7-15.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "ShowLocalImgFullScreenManager.h"
#import "MyScaleScrollView.h"
#import "AppDelegate.h"

static UIScrollView *largeScrollBackView; //图片放大后的黑色背景

@implementation ShowLocalImgFullScreenManager

+ (UIScrollView *)showLocalImgFullScreenWithImgSource:(NSArray *)localImgsSourceArray resize:(BOOL)resize canZoom:(BOOL)canZoom;
{
    if (!localImgsSourceArray || 0 == localImgsSourceArray.count)
        return nil;
    else
    {
        largeScrollBackView = InsertScrollViewByLocalImages(SharedAppDelegate.window, CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT), 1000, nil, localImgsSourceArray, resize, canZoom);
        largeScrollBackView.backgroundColor = [UIColor blackColor];
        largeScrollBackView.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            [UIApplication sharedApplication].statusBarHidden = YES;
            
            largeScrollBackView.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(responseTapGesture:)];
            [largeScrollBackView addGestureRecognizer:tapGesture];
            
        }];
        
        return largeScrollBackView;
    }
}

+ (void)responseTapGesture:(UITapGestureRecognizer *)gesture
{
    if (largeScrollBackView)
    {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            largeScrollBackView.alpha = 0.0;
            
            [UIApplication sharedApplication].statusBarHidden = NO;
            
        } completion:^(BOOL finished) {
            
            [largeScrollBackView removeFromSuperview];
        }];
    }
}

@end
