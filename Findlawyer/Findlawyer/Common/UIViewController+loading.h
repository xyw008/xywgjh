//
//  UIViewController+loading.h
//  ECLite
//
//  Created by qinwenzhou on 14-8-22.
//  Copyright (c) 2014年 qinwenzhou. All rights reserved.

// 这个类的扩展用用处理一些等待加载的提示

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface UIViewController (loading)

// return the hud that is loading
- (MBProgressHUD *)showHUDWithTitle:(NSString *)title image:(UIImage *)image autoHideAfterDelay:(NSTimeInterval)delay;
- (MBProgressHUD *)showHUDWithTitle:(NSString *)title;
- (void)hideHUDWithTitle:(NSString *)title image:(UIImage *)image delay:(NSTimeInterval)delay;

// return yes if removed success
- (BOOL)removeProgressHUD;

// return the indicator that is loading
- (UIActivityIndicatorView *)showCenterActivityIndicator;
- (UIActivityIndicatorView *)showCenterActivityIndicatorAndHideAfterDelay:(NSTimeInterval)delay;

- (void)showRightItemActivityIndicator;
- (void)showRightItemActivityIndicatorAndHideAfterDelay:(NSTimeInterval)delay;

// return yes if removed success

- (BOOL)removeCenterActivityIndicator;
- (BOOL)removeRightActivityIndicator;
@end
