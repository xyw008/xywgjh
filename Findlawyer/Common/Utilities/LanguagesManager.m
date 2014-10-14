//
//  LanguagesManager.m
//  SunnyFace
//
//  Created by gongjunhui on 13-8-7.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "LanguagesManager.h"

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
    
    NSArray *languages = [self getAppLanguagesTypeArray];
    NSString *current = languages[0];
    
    currentLanguageType = current;
    
    [self setLanguage:current];
}

+ (NSArray *)getAppLanguagesTypeArray
{
    static dispatch_once_t onceToken;
    static NSArray *staticAppLanguagesArray = nil;
    
    dispatch_once(&onceToken, ^{
        
        staticAppLanguagesArray = @[@"zh-Hans", @"zh-Hant", @"en"];
    });
    return staticAppLanguagesArray;
}

/*
 example calls:
 [Language setLanguage:@"it"];
 [Language setLanguage:@"de"];
 */

+ (void)setLanguage:(NSString *)languageType
{
    NSString *path = [[NSBundle mainBundle] pathForResource:languageType ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    
    if (!bundle)
    {
        bundle = [NSBundle mainBundle];
    }
    
    if (![currentLanguageType isEqualToString:languageType])
    {
        currentLanguageType = languageType;
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LanguageTypeDidChangedNotificationKey object:nil];
    }
}

+ (NSString *)getStr:(NSString *)key
{
    return [self getStr:key alter:nil];
}

+ (NSString *)getStr:(NSString *)key alter:(NSString *)alternate
{
    return [bundle localizedStringForKey:key value:alternate table:nil];
}  
@end