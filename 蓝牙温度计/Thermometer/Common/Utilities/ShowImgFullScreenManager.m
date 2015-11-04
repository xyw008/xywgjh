//
//  ShowImgFullScreenManager.m
//  zmt
//
//  Created by gongjunhui on 13-7-15.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "ShowImgFullScreenManager.h"
#import "MyScaleScrollView.h"
#import "AppDelegate.h"

static UIScrollView *largeScrollBackView; //图片放大后的黑色背景

@implementation ShowImgFullScreenManager

+ (UIScrollView *)showImgFullScreenWithImgIds:(NSArray *)ImgIdsArray
{
    if (!ImgIdsArray || 0 == ImgIdsArray.count)
        return nil;
    else
    {
        largeScrollBackView = InsertScrollViewCanScrollSubViews(SharedAppDelegate.window, CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT), 1000, nil, ImgIdsArray.count, [UIImage imageNamed:@"Unify_Image_w1.png"], ImgIdsArray, YES);
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

+ (UIScrollView *)showImgFullScreenWithImgUrls:(NSArray *)ImgUrlsArray
{
    if (!ImgUrlsArray || 0 == ImgUrlsArray.count)
        return nil;
    else
    {
        largeScrollBackView = InsertScrollViewCanWebImagesByUrls(SharedAppDelegate.window, CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT), 1000, nil, [UIImage imageNamed:@"Unify_Image_w1.png"], ImgUrlsArray, YES);
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
