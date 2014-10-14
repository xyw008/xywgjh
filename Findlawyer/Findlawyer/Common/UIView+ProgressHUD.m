//
//  UIView+ProgressHUD.m
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.
//

#import "UIView+ProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UIView (ProgressHUD)

+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title image:(UIImage *)image onView:(UIView *)view tag:(NSInteger)tag autoHideAfterDelay:(NSTimeInterval)delay
{
    UIView *subview = [view viewWithTag:tag];
    if ( nil != subview )
    {
        [subview removeFromSuperview];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.tag = tag;
    HUD.customView = [[UIImageView alloc] initWithImage:image];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = title;
    [view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
    
    return HUD;
}

+ (MBProgressHUD *)showHUDWithTitle:(NSString *)title onView:(UIView *)view tag:(NSInteger)tag
{
    UIView *subview = [view viewWithTag:tag];
    if ( nil != subview )
    {
        [subview removeFromSuperview];
    }
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.tag = tag;
    //hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = title;
    hud.labelFont = [UIFont systemFontOfSize:13.0];
    [view addSubview:hud];
    [hud show:YES];
    
    return hud;
}

+ (void)hideHUDWithTitle:(NSString *)title image:(UIImage *)image onView:(UIView *)view tag:(NSInteger)tag delay:(NSTimeInterval)delay
{
    UIView *subview = [view viewWithTag:tag];
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

@end
