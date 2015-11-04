//
//  FontManager.m
//  kkpoem
//
//  Created by 龚俊慧 on 15/8/6.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import "FontManager.h"
#import <CoreText/CoreText.h>
#import "UserInfoModel.h"

#define FontTypeArchiveKey       @"FontTypeArchiveKey"
#define FontSizeTypeArchiveKey   @"FontSizeTypeArchiveKey"

#define Font_Folder_Path         [GetDocumentPath() stringByAppendingPathComponent:@"Font"]

@interface FontManager ()

@property (nonatomic, strong) NSMutableDictionary *customFonts;

@end

@implementation FontManager

DEF_SINGLETON(FontManager);

- (id)init
{
    self = [super init];
    if (self)
    {
        self.customFonts = [NSMutableDictionary dictionary];
        [self registerAllFontsInFontFolder];
        
        // 取出预设值
        if ([UserInfoModel objectForKey:FontSizeTypeArchiveKey])
        {
            _fontSizeType = [[UserInfoModel objectForKey:FontSizeTypeArchiveKey] integerValue];
        }
        else
        {
            // 默认为中号字体
            _fontSizeType = FontSizeType_Mid;
            [UserInfoModel setObject:[NSNumber numberWithInteger:_fontSizeType] forKey:FontSizeTypeArchiveKey];
        }
        
        if ([UserInfoModel objectForKey:FontTypeArchiveKey])
        {
            _fontType = [[UserInfoModel objectForKey:FontTypeArchiveKey] integerValue];
        }
        else
        {
            // 默认为系统字体
            _fontType = FontType_System;
            [UserInfoModel setObject:@(_fontType) forKey:FontTypeArchiveKey];
        }
    }
    
    return self;
}

- (void)setFontType:(FontType)fontType
{
    if (_fontType != fontType)
    {
        _fontType = fontType;
        [UserInfoModel setObject:@(_fontType) forKey:FontTypeArchiveKey];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kFontTypeDidChangedNotificationKey object:nil];
    }
}

- (void)setFontSizeType:(FontSizeType)fontSizeType
{
    if (_fontSizeType != fontSizeType)
    {
        _fontSizeType = fontSizeType;
        [UserInfoModel setObject:[NSNumber numberWithInteger:_fontSizeType] forKey:FontSizeTypeArchiveKey];
        
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kFontSizeTypeDidChangedNotificationKey object:nil];
    }
}

// 注册fonts目录下面的所有字体文件
- (void)registerAllFontsInFontFolder
{
    NSArray *fontsFileNamesArray = SimpleSearchFiles(Font_Folder_Path);

    for (NSString *fileName in fontsFileNamesArray)
    {
        NSString *fontFilePaht = [Font_Folder_Path stringByAppendingPathComponent:fileName];
        
        if([fontFilePaht hasSuffix:@".ttf"])
        {
            [self registerCustomFontWitPath:fontFilePaht];
        }
    }
}

- (NSArray *)fontNames
{
    NSMutableArray *fontNames = [NSMutableArray array];
    
    // 系统字体名
    [fontNames addObjectsFromArray:[self systemFontNames]];
    // 第三方字体名
    [fontNames addObjectsFromArray:[self customFontNames]];
    
    return fontNames;
}

- (NSArray *)systemFontNames
{
    NSMutableArray *fontNames = [NSMutableArray array];
    
    NSArray *familyNames = [UIFont familyNames];
    for (NSString *family in familyNames)
    {
        [fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:family]];
    }
    
    return fontNames;
}

- (NSArray *)customFontNames
{
    NSMutableArray* fontNames = [NSMutableArray array];
    
    // 添加第三方字体
    [fontNames addObjectsFromArray:[_customFonts allKeys]];
    
    return fontNames;
}

- (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)curCustomFont
{
    return [self customFontByFontType:_fontType size:_fontSizeType];
}

- (UIFont *)customFontBySize:(CGFloat)fontSize
{
    return [self customFontByFontType:_fontType size:fontSize];
}

- (UIFont *)customFontByFontType:(FontType)type size:(CGFloat)fontSize
{
    if (type >= 0 && type < CUSTOM_FONT_NAME.count)
    {
        NSString *fontNameStr = CUSTOM_FONT_NAME[type];
        
        return [self customFontByName:fontNameStr size:fontSize];
    }
    else
    {
        return [self systemFontOfSize:fontSize];
    }
}

- (UIFont *)customFontByName:(NSString *)fontName size:(CGFloat)fontSize
{
    if(![self isRegisterCustomFont:fontName])
    {
        NSString *fontPath = [Font_Folder_Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ttf", fontName]];
        
        NSString *registerName = [self registerCustomFontWitPath:fontPath];
        if([registerName isAbsoluteValid])
        {
            return [UIFont fontWithName:registerName size:fontSize];
        }
        return [self systemFontOfSize:fontSize];
    }
    else
    {
        return [UIFont fontWithName:fontName size:fontSize];
    }
}

- (UIFont *)customFontByPath:(NSString *)fontPath size:(CGFloat)fontSize
{
    if (![fontPath isAbsoluteValid] || !IsFileExists(fontPath)) return nil;
    
    NSURL *url = [NSURL fileURLWithPath:fontPath];
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    
    CGDataProviderRelease(fontDataProvider);
    
    NSString *fontName = (NSString*)CFBridgingRelease(CGFontCopyPostScriptName(newFont));
    
    CFErrorRef error;
    if (!CTFontManagerRegisterGraphicsFont(newFont, &error))
    {
        // 注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        DLog(@"字体注册失败: %@", errorDescription);
        
        CFRelease(errorDescription);
        CFRelease(newFont);
        
        return nil;
    }
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    CTFontManagerUnregisterGraphicsFont(newFont, &error);
    CFRelease(newFont);
    
    return font;
}

- (BOOL)isRegisterCustomFont:(NSString *)fontName
{
    if (![fontName isAbsoluteValid]) return NO;
    
    UIFont *aFont = [UIFont fontWithName:fontName size:12.0];
    
    BOOL isRegister = (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame));
    return isRegister;
}

- (NSString *)registerCustomFontWitPath:(NSString *)fontPath
{
    if (![fontPath isAbsoluteValid] || !IsFileExists(fontPath))
    {
        DLog(@"字体注册失败,找不到路径 path = %@",fontPath);
        return nil;
    }
    
    NSURL *url = [NSURL fileURLWithPath:fontPath];
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    
    CGDataProviderRelease(fontDataProvider);
    
    NSString *fontName = (NSString *)CFBridgingRelease(CGFontCopyPostScriptName(newFont));
    if (![fontName isAbsoluteValid])
    {
        CFRelease(newFont);
        DLog(@"字体注册失败,路径 path = %@",fontPath);
        return nil;
        
    }
    else if ([self isRegisterCustomFont:fontName])
    {
        [_customFonts setObject:[NSValue valueWithPointer:newFont] forKey:fontName];
        
        CFRelease(newFont);
        return fontName;
    }
    
    CFErrorRef error;
    if(CTFontManagerRegisterGraphicsFont(newFont, &error))
    {
        /*
        // 先注销掉老的
        [self unregisterCustomFont:fontName];
         */
        [_customFonts setObject:[NSValue valueWithPointer:newFont] forKey:fontName];
        
        CFRelease(newFont);
        return fontName;
    }
    else
    {
        // 注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        DLog(@"字体注册失败: %@", errorDescription);
        
        CFRelease(errorDescription);
        CFRelease(newFont);
    }
    
    return nil;
}

- (void)unregisterCustomFont:(NSString *)fontName
{
    if (![fontName isAbsoluteValid]) return;
        
    NSValue *val = [_customFonts objectForKey:fontName];
    if (!val) {
        return ;
    }
    
    [_customFonts removeObjectForKey:fontName];
    CGFontRef newFont = [val pointerValue];
    
    CFErrorRef error;
    CTFontManagerUnregisterGraphicsFont(newFont, &error);
    CFRelease(newFont);
}

@end
