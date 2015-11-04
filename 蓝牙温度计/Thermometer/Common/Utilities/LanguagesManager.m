//
//  LanguagesManager.m
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "LanguagesManager.h"
#import "UserInfoModel.h"

#define CurrentLanguageTypeKey @"CurrentLanguageTypeKey"

@implementation LanguagesManager

static NSBundle *bundle = nil;
static NSString *currentLanguageType = nil;

+ (void)initialize
{
    /*
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *current = [languages objectAtIndex:0];
    */
    
    // 取出预设值
    if ([UserInfoModel objectForKey:CurrentLanguageTypeKey])
    {
        currentLanguageType = [UserInfoModel objectForKey:CurrentLanguageTypeKey];
    }
    else
    {
        // 默认为简体中文
        NSArray *languages = [self getAppLanguagesTypeArray];
        NSString *current = languages[0];
        currentLanguageType = current;
        
        [UserInfoModel setObject:currentLanguageType forKey:CurrentLanguageTypeKey];
    }
    
    [self configureBundleWithLanguage:currentLanguageType];
}

+ (NSArray *)getAppLanguagesTypeArray
{
    static dispatch_once_t onceToken;
    static NSArray *staticAppLanguagesArray = nil;
    
    dispatch_once(&onceToken, ^{
        
        staticAppLanguagesArray = @[SimpleChinese, TradictionalChinese];
    });
    return staticAppLanguagesArray;
}

+ (void)changeLanguageTypeAndPostNotificationWithType:(NSString *)languageType
{
    if (![currentLanguageType isEqualToString:languageType])
    {
        currentLanguageType = languageType;
        
        [UserInfoModel setObject:currentLanguageType forKey:CurrentLanguageTypeKey];
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LanguageTypeDidChangedNotificationKey object:nil];
    }
}

+ (void)configureBundleWithLanguage:(NSString *)languageType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:languageType ofType:@"lproj"];
    NSBundle *tempBundle = [NSBundle bundleWithPath:path];
    
    // 有本地化语言文件
    if (tempBundle)
    {
        bundle = tempBundle;
        
        [self changeLanguageTypeAndPostNotificationWithType:languageType];
    }
    // 如果是简繁之间的切换就算没有本地化文件也可以通过代码来做转换
    else if ([currentLanguageType isEqualToString:SimpleChinese] ||
             [currentLanguageType isEqualToString:TradictionalChinese])
    {
        [self changeLanguageTypeAndPostNotificationWithType:languageType];
    }
    
    if (!bundle)
    {
        NSString *defaultPath = [[NSBundle mainBundle] pathForResource:SimpleChinese ofType:@"lproj"];
        bundle = [NSBundle bundleWithPath:defaultPath];
        
        if (!bundle)
        {
            bundle = [NSBundle mainBundle];
        }
    }
}

+ (void)setLanguage:(NSString *)languageType
{
    /*
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defs objectForKey:@"AppleLanguages"];
     */
    NSArray *languages = [self getAppLanguagesTypeArray];
    
    if (![languages containsObject:languageType]) return;
    
    [self configureBundleWithLanguage:languageType];
}

+ (NSString *)curLanguagesType
{
    return currentLanguageType;
}

+ (NSString *)getStr:(NSString *)key
{
    return [self getStr:key alter:nil];
}

+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate
{
    NSString *str = [bundle localizedStringForKey:key value:alternate table:nil];
    
    return [self getCurLanguagesTypeStrWithStr:str];
}

+ (NSString *)getCurLanguagesTypeStrWithStr:(NSString *)str
{
    if (![str isAbsoluteValid]) return str;
    
    // 繁体->简体
    if ([currentLanguageType isEqualToString:SimpleChinese])
    {
        return [[OBCConvertor getInstance] t2s:str];
    }
    // 简体->繁体
    else if ([currentLanguageType isEqualToString:TradictionalChinese])
    {
        return [[OBCConvertor getInstance] s2t:str];
    }
    else
    {
        return str;
    }
}

@end