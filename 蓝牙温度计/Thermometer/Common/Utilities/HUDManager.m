//
//  HUDManager.m
//  SunnyFace
//
//  Created by 龚 俊慧 on 13-1-21.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "HUDManager.h"
#import "AppUIElement.h"

@implementation HUDManager

+ (void)showAutoHideHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:YES userInteractionEnabled:YES];
}

+ (void)showAutoHideHUDOfCustomViewWithToShowStr:(NSString *)showStr showType:(HUDShowType)showType
{
    [self showHUDWithToShowStr:showStr HUDMode:MBProgressHUDModeCustomView autoHide:YES userInteractionEnabled:YES showType:showType];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide userInteractionEnabled:(BOOL)yesOrNo
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:autoHide userInteractionEnabled:yesOrNo showType:HUDOthers];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide userInteractionEnabled:(BOOL)yesOrNo showType:(HUDShowType)showType
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:autoHide userInteractionEnabled:yesOrNo showType:showType inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide userInteractionEnabled:(BOOL)yesOrNo showType:(HUDShowType)showType inView:(UIView *)inView
{
    // 隐藏上一次显示的hud
    [self hideHUDInView:inView];
    
    // 创建hud
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    
    HUD.userInteractionEnabled = !yesOrNo; // 加上这个属性才能在HUD还没隐藏的时候点击到别的view
    HUD.mode = mode;
    HUD.detailsLabelText = showStr;
    HUD.detailsLabelFont = [UIFont systemFontOfSize:15];
    HUD.opacity = 0.8;
    HUD.dimBackground = NO;
    HUD.animationType = MBProgressHUDAnimationFade;
    HUD.cornerRadius = 0;
    
    // HUD.taskInProgress = YES;
    
    if (autoHide)
    {
        [HUD hide:YES afterDelay:HUDAutoHideTypeShowTime];
    }
    
    if (mode == MBProgressHUDModeCustomView)
    {
        UIView *customView = nil;
        
        if (showType == HUDOperationSuccess)
        {
            customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            ((UIImageView *)customView).image = [UIImage imageNamed:@"Login_btn_Right"];
        }
        else if (showType == HUDOperationFailed)
        {
            customView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            ((UIImageView *)customView).image = [UIImage imageNamed:@"Unify_Image_w7"];
        }
        else if (HUDOperationLoading == showType)
        {
            customView = [[ActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            [((ActivityIndicatorView *)customView) startAnimating];
        }
        
        HUD.customView = customView;
    }
}

+ (void)hideHUD
{
    [self hideHUDInView:[UIApplication sharedApplication].keyWindow];
}

+ (void)hideHUDInView:(UIView *)inView
{
    [MBProgressHUD hideAllHUDsForView:inView animated:YES];
}

@end
