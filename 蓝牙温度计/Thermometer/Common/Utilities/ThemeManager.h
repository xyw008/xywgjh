//
//  ThemeManager.h
//  kkpoem
//
//  Created by 龚俊慧 on 15/8/26.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CUSTOM_THEME_TYPE_NAME  @[@"默认主题", @"杨柳依依", @"荷塘月色", @"一树寒梅", @"楼阁亭立", @"竹生空野"]
#define CUSTOM_THEME_FILE_IMAGE @[\
@[@"original_sytle@2x.png", @"original_sytle@2x.png", @"original_sytle@2x.png", @"original_sytle@2x.png"],\
@[@"theme_01_i4@2x.jpg", @"theme_01_i5@2x.jpg", @"theme_01_i6@2x.jpg", @"theme_01_i6Plus@3x.jpg"],\
@[@"theme_02_i4@2x.jpg", @"theme_02_i5@2x.jpg", @"theme_02_i6@2x.jpg", @"theme_02_i6Plus@3x.jpg"],\
@[@"theme_03_i4@2x.jpg", @"theme_03_i5@2x.jpg", @"theme_03_i6@2x.jpg", @"theme_03_i6Plus@3x.jpg"],\
@[@"theme_04_i4@2x.jpg", @"theme_04_i5@2x.jpg", @"theme_04_i6@2x.jpg", @"theme_04_i6Plus@3x.jpg"],\
@[@"theme_05_i4@2x.jpg", @"theme_05_i5@2x.jpg", @"theme_05_i6@2x.jpg", @"theme_05_i6Plus@3x.jpg"],\
@[@"theme_06_i4@2x.jpg", @"theme_06_i5@2x.jpg", @"theme_06_i6@2x.jpg", @"theme_06_i6Plus@3x.jpg"]]

typedef NS_ENUM(NSInteger, ThemeType)
{
    // 默认主题
    ThemeType_Default   = 0,
    // ...
    ThemeType_One,
    // ...
    ThemeType_Two,
    // ...
    ThemeType_Three,
    // ...
    ThemeType_Four,
    // ...
    ThemeType_Five,
    // ...
    ThemeType_Six
};

static NSString * const kThemeTypeDidChangedNotificationKey = @"kThemeTypeDidChangedNotificationKey";

@interface ThemeManager : NSObject

AS_SINGLETON(ThemeManager);

@property (nonatomic, assign)         ThemeType themeType;          // 默认为系统主题
@property (nonatomic, copy, readonly) NSString  *curThemeTypeName;  // 当前主题风格名称
@property (nonatomic, copy, readonly) NSString  *curThemeTypeImage; // 当前主题风格图片

- (NSString *)getThemeTypeNameWithType:(ThemeType)type;
- (NSString *)getThemeImageWithType:(ThemeType)type;

@end
