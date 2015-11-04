//
//  InterfaceHUDManager.h
//  o2o
//
//  Created by swift on 14-8-25.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GJHAlertView.h"

typedef void (^GJHAlertBlock) (GJHAlertView *alertView, NSInteger index);
// idsArray: 存放顺序为 国家ID、省ID、市ID、区ID
typedef void (^PickerOperationBlock) (NSString *pickedContent, NSArray *idsArray);

typedef NS_ENUM(NSInteger, AlertShowType)
{
    /// 提示性
    AlertShowType_Informative   = 0,
    /// 警示性
    AlertShowType_warning,
};

typedef NS_ENUM(NSInteger, PickerShowType)
{
    /// 日期
    PickerShowType_Date             = 0,
    /// 省 市 区
    PickerShowType_ProvinceAndCity
};

@interface InterfaceHUDManager : NSObject

AS_SINGLETON(InterfaceHUDManager);

#pragma mark - Alert

- (void)showAutoHideAlertWithMessage:(NSString *)message;

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle;

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
             alertShowType:(AlertShowType)type
               cancelTitle:(NSString *)cancelTitle
               cancelBlock:(GJHAlertBlock)cancelBlock
                otherTitle:(NSString *)otherTitle
                otherBlock:(GJHAlertBlock)otherBlock;

#pragma mark - ActionSheet

// ...

#pragma mark - Picker

- (void)showPickerWithTitle:(NSString *)title
             PickerShowType:(PickerShowType)type
          pickerCancelBlock:(PickerOperationBlock)pickerCancelBlock
         pickerConfirmBlock:(PickerOperationBlock)pickerConfirmBlock;

- (void)showPickerWithTitle:(NSString *)title
             PickerShowType:(PickerShowType)type
         defaultSelectedStr:(NSString *)selectedStr
          pickerCancelBlock:(PickerOperationBlock)pickerCancelBlock
         pickerConfirmBlock:(PickerOperationBlock)pickerConfirmBlock;

/**
 @ 方法描述    获取所传地址中的 国家 省 市 区 的在世界地址中ID数组(存放顺序为 国家ID、省ID、市ID、区ID)
 @ 输入参数    addressStr: 想获取ID的地址
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-12-23
 */
- (NSArray *)getCurIdsArrayInAddressStr:(NSString *)addressStr;

@end
