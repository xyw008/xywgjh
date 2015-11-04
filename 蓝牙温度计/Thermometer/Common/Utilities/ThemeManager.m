//
//  ThemeManager.m
//  kkpoem
//
//  Created by 龚俊慧 on 15/8/26.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import "ThemeManager.h"
#import "UserInfoModel.h"

#define ThemeTypeArchiveKey @"ThemeTypeArchiveKey"

@implementation ThemeManager

DEF_SINGLETON(ThemeManager);

- (id)init
{
    self = [super init];
    if (self)
    {
        // 取出预设值
        if ([UserInfoModel objectForKey:ThemeTypeArchiveKey])
        {
            _themeType = [[UserInfoModel objectForKey:ThemeTypeArchiveKey] integerValue];
        }
        else
        {
            // 默认为系统主题
            /*
            // 判断之前的老版本有没有切换到“魔兽世界”的主题(1：魔兽世界 0：默认主题)
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger theme = [[userDefaults objectForKey:kThemeKey] integerValue];
            if (theme)
            {
                _themeType = ThemeType_One;
            }
            else
            {
                _themeType = ThemeType_Default;
            }
             */
            _themeType = ThemeType_One;
            
            [UserInfoModel setObject:@(_themeType) forKey:ThemeTypeArchiveKey];
        }
    }
    
    return self;
}

- (void)setThemeType:(ThemeType)themeType
{
    if (_themeType != themeType)
    {
        _themeType = themeType;
        [UserInfoModel setObject:@(_themeType) forKey:ThemeTypeArchiveKey];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeTypeDidChangedNotificationKey object:nil];
    }
}

- (NSString *)curThemeTypeName
{
    return [self getThemeTypeNameWithType:_themeType];
}

- (NSString *)getThemeTypeNameWithType:(ThemeType)type
{
    return [LanguagesManager getCurLanguagesTypeStrWithStr:CUSTOM_THEME_TYPE_NAME[type]];
}

- (NSString *)curThemeTypeImage
{
    return [self getThemeImageWithType:_themeType];
}

- (NSString *)getThemeImageWithType:(ThemeType)type
{
    NSArray *imagesArray = CUSTOM_THEME_FILE_IMAGE[type];
    
    if (iPhone4)
    {
        return imagesArray[0];
    }
    else if (iPhone5)
    {
        return imagesArray[1];
    }
    else if (iPhone6)
    {
        return imagesArray[2];
    }
    else if (iPhone6Plus)
    {
        return imagesArray[3];
    }
    return nil;
}

@end
