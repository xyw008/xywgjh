//
//  HUDManager.m
//  SunnyFace
//
//  Created by 龚 俊慧 on 13-1-21.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "HUDManager.h"
#import "AppDelegate.h"

static MBProgressHUD *HUD;

@implementation HUDManager

+ (void)showAutoHideHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:YES afterDelay:HUDAutoHideTypeShowTime userInteractionEnabled:YES];
}

+ (void)showAutoHideHUDOfCustomViewWithToShowStr:(NSString *)showStr showType:(HUDShowType)showType
{
    [self showHUDWithToShowStr:showStr HUDMode:MBProgressHUDModeCustomView autoHide:YES afterDelay:HUDAutoHideTypeShowTime userInteractionEnabled:YES showType:showType];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo
{
    [self showHUDWithToShowStr:showStr HUDMode:mode autoHide:autoHide afterDelay:afterDelay userInteractionEnabled:yesOrNo showType:HUDOthers];
}

+ (void)showHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode autoHide:(BOOL)autoHide afterDelay:(NSTimeInterval)afterDelay userInteractionEnabled:(BOOL)yesOrNo showType:(HUDShowType)showType
{
    // 隐藏上一次显示的hud
    [self hideHUD];
    
    // 创建hud
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    HUD = [[MBProgressHUD alloc] initWithWindow:delegate.window];
    [delegate.window addSubview:HUD];
    
    HUD.userInteractionEnabled = !yesOrNo; // 加上这个属性才能在HUD还没隐藏的时候点击到别的view
    HUD.removeFromSuperViewOnHide = YES;
    HUD.mode = mode;
    
    if (mode == MBProgressHUDModeCustomView)
    {
        UIImageView *customImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        if (showType == HUDOperationSuccess)
        {
            customImgView.image = [UIImage imageNamed:@"Login_btn_Right.png"];
        }
        else if (showType == HUDOperationFailed)
        {
            customImgView.image = [UIImage imageNamed:@"Unify_Image_w7.png"];
        }
        
        HUD.customView = customImgView;
    }
   
    HUD.labelText = showStr;
//    HUD.color = [UIColor blackColor];
    
//    HUD.taskInProgress = YES;
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    
    [HUD show:YES];
    
    /*
     [HUD showAnimated:YES whileExecutingBlock:^{
     sleep(5); // 这个是5秒后隐藏
     HUD.progress = 0.5;
     } completionBlock:^{
     [HUD removeFromSuperview];
     HUD = nil;
     }];
     */
    
    if (autoHide)
    {
        [HUD hide:YES afterDelay:afterDelay];
    }
}

+ (void)hideHUD
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
    HUD = nil;
}


@end
