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
typedef void (^PickerOperationBlock) (NSString *pickedContent);

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

@end
