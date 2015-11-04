//
//  LanguagesManager.h
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBCConvertor.h"

#define LocalizedStr(key) [LanguagesManager getStr:key]

static NSString * const SimpleChinese       = @"zh-Hans";
static NSString * const TradictionalChinese = @"zh-Hant";
static NSString * const English             = @"en";

static NSString * const LanguageTypeDidChangedNotificationKey = @"LanguageTypeDidChangedNotificationKey";

@interface LanguagesManager : NSObject

+ (void)initialize;
+ (NSArray *)getAppLanguagesTypeArray;
+ (void)setLanguage:(NSString *)languageType;
+ (NSString *)curLanguagesType;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate;

////////////////////////////////////////////////////////////////////////////////

/// 把str转换为当前语言类型的字符串(只支持简体<->繁体)
+ (NSString *)getCurLanguagesTypeStrWithStr:(NSString *)str;

@end

// 所有模块
static NSString * const All_DataSourceNotFoundKey  = @"All_DataSourceNotFound";
static NSString * const All_Delete                 = @"All_Delete";
static NSString * const All_Check                  = @"All_Check";
static NSString * const All_Confirm                = @"All_Confirm";
static NSString * const All_Cancel                 = @"All_Cancel";
static NSString * const All_PickFromCamera         = @"All_PickFromCamera";
static NSString * const All_PickFromAlbum          = @"All_PickFromAlbum";
static NSString * const All_SaveToAlbum            = @"All_SaveToAlbum";
static NSString * const All_SaveSuccess            = @"All_SaveSuccess";
static NSString * const All_OperationFailure       = @"All_OperationFailure";
static NSString * const All_Notification           = @"All_Notification";

// 字体
static NSString * const Font_Size                  = @"Font_Size";
static NSString * const Font_Select                = @"Font_Select";
static NSString * const Font_More                  = @"Font_More";

// 设置
static NSString * const Setting_My_Collect         = @"Setting_My_Collect";
static NSString * const Setting_Package_Download   = @"Setting_Package_Download";
static NSString * const Setting_Invite_Friend      = @"Setting_Invite_Friend";
static NSString * const Setting_Set                = @"Setting_Set";

// 其他

// 搜索页

// 版本检测
static NSString * const Version_NowNewVersion      = @"Version_NowNewVersion";
static NSString * const Version_LoadingShow        = @"Version_LoadingShow";

// 各控制器导航栏标题
static NSString * const NavTitle_HomePage          = @"NavTitle_HomePage";
static NSString * const NavTitle_MyCollection      = @"NavTitle_MyCollection";
static NSString * const NavTitle_RandomRecommended = @"NavTitle_RandomRecommended";
static NSString * const NavTitle_ReadingHistory    = @"NavTitle_ReadingHistory";
static NSString * const NavTitle_Setting           = @"NavTitle_Setting";
static NSString * const NavTitle_FontSelect        = @"NavTitle_FontSelect";
static NSString * const NavTitle_PackageDownload   = @"NavTitle_PackageDownload";
static NSString * const NavTitle_Feedback          = @"NavTitle_Feedback";
static NSString * const NavTitle_About             = @"NavTitle_About";



