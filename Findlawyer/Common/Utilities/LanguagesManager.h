//
//  LanguagesManager.h
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedStr(key) [LanguagesManager getStr:key]

static NSString * const LanguageTypeDidChangedNotificationKey = @"LanguageTypeDidChangedNotificationKey";

@interface LanguagesManager : NSObject

+ (void)initialize;
+ (NSArray *)getAppLanguagesTypeArray;
+ (void)setLanguage:(NSString *)languageType;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate;

@end

// 所有模块
static NSString * const All_DataSourceNotFoundKey              = @"All_DataSourceNotFound";
static NSString * const All_Confirm                            = @"All_Confirm";
static NSString * const All_Cancel                             = @"All_Cancel";
static NSString * const All_PickFromCamera                     = @"All_PickFromCamera";
static NSString * const All_PickFromAlbum                      = @"All_PickFromAlbum";
static NSString * const All_SaveToAlbum                        = @"All_SaveToAlbum";
static NSString * const All_SaveSuccess                        = @"All_SaveSuccess";
static NSString * const All_OperationFailure                   = @"All_OperationFailure";

// 登陆&注册
static NSString * const Login_NoUserShowInfoKey                = @"Login_NoUserShowInfo";
static NSString * const Login_NoPasswordShowInfoKey            = @"Login_NoPasswordShowInfo";
static NSString * const Login_NoPasswordConfirmShowInfoKey     = @"Login_NoPasswordConfirmShowInfo";
static NSString * const Login_PasswordNotEqualShowInfoKey      = @"Login_PasswordNotEqualShowInfo";
static NSString * const Login_NoAgreeProtocolShowInfoKey       = @"Login_NoAgreeProtocolShowInfo";
static NSString * const Login_LoadingShowInfoKey               = @"Login_LoadingShowInfo";
static NSString * const Login_LoginFailShowInfoKey             = @"Login_LoginFailShowInfo";

//修改密码
static NSString * const Password_PasswordErrorKey              = @"Password_PasswordError";
static NSString * const Password_PasswordLessThanSixKey        = @"Password_PasswordLessThanSix";
static NSString * const Password_PasswordDifferentKey          = @"Password_PasswordDifferent";
static NSString * const Password_PasswordModifyFailKey         = @"Password_PasswordModifyFail";
static NSString * const Password_PasswordModifySuccessKey      = @"Password_PasswordModifySuccess";

//版本检测
static NSString * const Version_NowNewVersionKey               = @"Version_NowNewVersion";
static NSString * const Version_LoadingShowKey                 = @"Version_LoadingShowKey";

// 产品
static NSString * const Product_AddCartSucceedShowInfoKey      = @"Product_AddCartSucceedShowInfo";
static NSString * const Product_AddCartFailShowInfoKey         = @"Product_AddCartFailShowInfo";
static NSString * const Product_AddFavoriteSucceedShowInfoKey  = @"Product_AddFavoriteSucceedShowInfo";
static NSString * const Product_AddFavoriteFailShowInfoKey     = @"Product_AddFavoriteFailShowInfo";
static NSString * const Product_NoSearchHistoryShowInfoKey     = @"Product_NoSearchHistoryShowInfo";
static NSString * const Product_ClearSearchHistoryShowInfoKey  = @"Product_ClearSearchHistoryShowInfo";

// 购物车
static NSString * const ShoppingCart_DeleteProductItemKey      = @"ShoppingCart_DeleteProductItem";
static NSString * const ShoppingCart_NoSelectedProductItemKey  = @"ShoppingCart_NoSelectedProductItem";

// 个人
static NSString * const Mine_OrderQueryKey                     = @"Mine_OrderQuery";
static NSString * const Mine_MyCollectKey                      = @"Mine_MyCollect";
static NSString * const Mine_MyKitchenKey                      = @"Mine_MyKitchen";
static NSString * const Mine_AccountManagerKey                 = @"Mine_AccountManager";
static NSString * const Mine_FAQKey                            = @"Mine_FAQ";
static NSString * const Mine_DeleteThisAddressKey              = @"Mine_DeleteThisAddress";
static NSString * const Mine_PhoneNumberErrorKey               = @"Mine_PhoneNumberError";
static NSString * const Mine_EmailErrorKey                     = @"Mine_EmailError";

// 各控制器导航栏标题
static NSString * const NavTitle_ShoppingCarKey                = @"NavTitle_ShoppingCar";
static NSString * const NavTitle_MineKey                       = @"NavTitle_Mine";
static NSString * const NavTitle_AddressManagerKey             = @"NavTitle_AddressManager";
static NSString * const NavTitle_AddAddressKey                 = @"NavTitle_AddAddress";
static NSString * const NavTitle_PreferentialKey               = @"NavTitle_Preferential";
static NSString * const NavTitle_FAQKey                        = @"NavTitle_FAQ";

