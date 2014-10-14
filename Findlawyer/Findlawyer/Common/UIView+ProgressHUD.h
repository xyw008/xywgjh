//
//  UIView+ProgressHUD.h
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.

// 这个类用来存放加载标志的动画

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface UIView (ProgressHUD)

+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title image:(UIImage *)image onView:(UIView *)view tag:(NSInteger)tag autoHideAfterDelay:(NSTimeInterval)delay;
+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title onView:(UIView *)view tag:(NSInteger)tag;
+ (void)hideHUDWithTitle:(NSString *)title image:(UIImage *)image onView:(UIView *)view tag:(NSInteger)tag delay:(NSTimeInterval)delay;

@end
