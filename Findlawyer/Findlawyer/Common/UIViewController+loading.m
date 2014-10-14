//
//  UIViewController+loading.m
//  ECLite
//
//  Created by qinwenzhou on 14-8-22.
//  Copyright (c) 2014年 qinwenzhou. All rights reserved.
//

#import "UIViewController+loading.h"

#define ProgressHUDTag  -999
#define ActivityTag       -1000

@implementation UIViewController (loading)



-(MBProgressHUD *)showHUDWithTitle:(NSString *)title image:(UIImage *)image autoHideAfterDelay:(NSTimeInterval)delay
{
    [self removeProgressHUD];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.tag = ProgressHUDTag;
    HUD.customView = [[UIImageView alloc] initWithImage:image] ;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    [self.view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    return HUD;
}

- (MBProgressHUD *)showHUDWithTitle:(NSString *)title
{
    [self removeProgressHUD];
 
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.tag = ProgressHUDTag;
    //hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = title;
    hud.labelFont = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:hud];
    [hud show:YES];
    
    return hud;
}

- (void)hideHUDWithTitle:(NSString *)title image:(UIImage *)image delay:(NSTimeInterval)delay
{
    UIView *subview = [self.view viewWithTag:ProgressHUDTag];
    if (nil != subview)
    {
        if ([subview isKindOfClass:[MBProgressHUD class]])
        {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            
            if (title == nil)
            {
                [hud hide:YES];
            }
            else
            {
                hud.labelText = title;
                hud.mode = MBProgressHUDModeCustomView;
                hud.customView = [[UIImageView alloc] initWithImage:image];
                [hud hide:YES afterDelay:delay];
            }
        }
    }
}


- (BOOL)removeProgressHUD {
    
    UIView *subview = [self.view viewWithTag:ProgressHUDTag];
    if ( nil != subview )
    {
        [subview removeFromSuperview];
    }
    return YES;
}



- (UIActivityIndicatorView *)showCenterActivityIndicator
{
    [self removeCenterActivityIndicator];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = self.view.center;
    activity.tag = ActivityTag;
    [self.view addSubview:activity];
    [activity startAnimating];
    return activity;
}

- (UIActivityIndicatorView *)showCenterActivityIndicatorAndHideAfterDelay:(NSTimeInterval)delay;
{
    [self removeCenterActivityIndicator];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = self.view.center;
    activity.tag = ActivityTag;
    [self.view addSubview:activity];
    [activity startAnimating];
    [self performSelector:@selector(removeCenterActivityIndicator) withObject:nil afterDelay:delay];
    return activity;
}

- (BOOL)removeCenterActivityIndicator;
{
    UIActivityIndicatorView * activityview = (UIActivityIndicatorView * )[self.view viewWithTag:ActivityTag];
    if ( nil != activityview )
    {   [activityview stopAnimating];
        [activityview removeFromSuperview];
    }
    return YES;
}

- (void)showRightItemActivityIndicator
{
    [self removeRightActivityIndicator];
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
}

- (void)showRightItemActivityIndicatorAndHideAfterDelay:(NSTimeInterval)delay
{
    [self removeRightActivityIndicator];
    UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activity];
    [self performSelector:@selector(removeRightActivityIndicator) withObject:nil afterDelay:delay];
}


- (BOOL)removeRightActivityIndicator
{
    self.navigationItem.rightBarButtonItem = nil;
    return YES;
}


@end
