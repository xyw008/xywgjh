//
//  HUDManager.h
//  SunnyFace
//
//  Created by 龚 俊慧 on 13-1-21.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef enum
{
    /// customView显示操作成功
    HUDOperationSuccess,
    /// customView显示操作失败
    HUDOperationFailed,
    /// customView: loading
    HUDOperationLoading,
    /// 不加载customView
    HUDOthers
    
}HUDShowType;

@interface HUDManager : NSObject<MBProgressHUDDelegate>

/**
 * 方法描述: 界面提示信息展示
 * 输入参数: 展示文字,HUD类型,是否自动隐藏,自动隐藏时间,提示期间能否进行界面交互,展示类型
 * 返回值: VOID
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (void)showAutoHideHUDWithToShowStr:(NSString *)showStr HUDMode:(MBProgressHUDMode)mode;

+ (void)showAutoHideHUDOfCustomViewWithToShowStr:(NSString *)showStr showType:(HUDShowType)showType;

+ (void)showHUDWithToShowStr:(NSString *)showStr
                     HUDMode:(MBProgressHUDMode)mode
                    autoHide:(BOOL)autoHide
      userInteractionEnabled:(BOOL)yesOrNo;

+ (void)showHUDWithToShowStr:(NSString *)showStr
                     HUDMode:(MBProgressHUDMode)mode
                    autoHide:(BOOL)autoHide
      userInteractionEnabled:(BOOL)yesOrNo
                    showType:(HUDShowType)showType;

+ (void)showHUDWithToShowStr:(NSString *)showStr
                     HUDMode:(MBProgressHUDMode)mode
                    autoHide:(BOOL)autoHide
      userInteractionEnabled:(BOOL)yesOrNo
                    showType:(HUDShowType)showType
                      inView:(UIView *)inView;

/**
 * 方法描述: 隐藏提示
 * 输入参数: 无
 * 返回值: VOID
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (void)hideHUD;

+ (void)hideHUDInView:(UIView *)inView;

@end
