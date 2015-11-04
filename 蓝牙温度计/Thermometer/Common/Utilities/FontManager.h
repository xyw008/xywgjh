//
//  FontManager.h
//  kkpoem
//
//  Created by 龚俊慧 on 15/8/6.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomFont_Size(size) [[FontManager sharedInstance] customFontBySize:size]
#define kSystemFont_Size(size) [[FontManager sharedInstance] systemFontOfSize:size]

#define kSystemFont10 kSystemFont_Size(kGetScaleValueBaseIP6(10))
#define kSystemFont11 kSystemFont_Size(kGetScaleValueBaseIP6(11))
#define kSystemFont12 kSystemFont_Size(kGetScaleValueBaseIP6(12))
#define kSystemFont13 kSystemFont_Size(kGetScaleValueBaseIP6(13))
#define kSystemFont14 kSystemFont_Size(kGetScaleValueBaseIP6(14))
#define kSystemFont15 kSystemFont_Size(kGetScaleValueBaseIP6(15))
#define kSystemFont16 kSystemFont_Size(kGetScaleValueBaseIP6(16))
#define kSystemFont17 kSystemFont_Size(kGetScaleValueBaseIP6(17))
#define kSystemFont18 kSystemFont_Size(kGetScaleValueBaseIP6(18))
#define kSystemFont19 kSystemFont_Size(kGetScaleValueBaseIP6(19))
#define kSystemFont20 kSystemFont_Size(kGetScaleValueBaseIP6(20))

#define kCustomFont10 kCustomFont_Size(kGetScaleValueBaseIP6(10))
#define kCustomFont11 kCustomFont_Size(kGetScaleValueBaseIP6(11))
#define kCustomFont12 kCustomFont_Size(kGetScaleValueBaseIP6(12))
#define kCustomFont13 kCustomFont_Size(kGetScaleValueBaseIP6(13))
#define kCustomFont14 kCustomFont_Size(kGetScaleValueBaseIP6(14))
#define kCustomFont15 kCustomFont_Size(kGetScaleValueBaseIP6(15))
#define kCustomFont16 kCustomFont_Size(kGetScaleValueBaseIP6(16))
#define kCustomFont17 kCustomFont_Size(kGetScaleValueBaseIP6(17))
#define kCustomFont18 kCustomFont_Size(kGetScaleValueBaseIP6(18))
#define kCustomFont19 kCustomFont_Size(kGetScaleValueBaseIP6(19))
#define kCustomFont20 kCustomFont_Size(kGetScaleValueBaseIP6(20))

#define CUSTOM_FONT_NAME @[@"SentyZHAO", @"CloudSongFangGBK", @"CloudKaiTiGBK", @"CloudLiBianGBK", @"CloudYaoTiGBK"]

typedef NS_ENUM(NSInteger, FontSizeType)
{
    FontSizeType_VeryBig   = 20,
    FontSizeType_Big       = 18,
    FontSizeType_Mid       = 15,
    FontSizeType_Small     = 12,
    FontSizeType_VerySmall = 10,
};

typedef NS_ENUM(NSInteger, FontType)
{
    /// 系统字体
    FontType_System              = -1,
    /// 全新硬笔楷书
    FontType_QuanXinYingBiKaiShu = 0,
    
    /// ...
};

static NSString * const kFontSizeTypeDidChangedNotificationKey = @"kFontSizeTypeDidChangedNotificationKey";
static NSString * const kFontTypeDidChangedNotificationKey     = @"kFontTypeDidChangedNotificationKey";

@interface FontManager : NSObject

AS_SINGLETON(FontManager);

@property (nonatomic, assign) FontSizeType fontSizeType; // 默认为中号字体
@property (nonatomic, assign) FontType     fontType;     // 默认为系统字体

/// 获取所有字体名字列表
- (NSArray *)fontNames;

/// 获取系统字体名列表
- (NSArray *)systemFontNames;

/// 获取第三方字体名列表
- (NSArray *)customFontNames;


/// 下载字体
/// 待实现...
- (void)dowloadFontWithUrlStr:(NSString *)urlStr;


/// 系统字体
- (UIFont *)systemFontOfSize:(CGFloat)fontSize;

/// 当前自定义字体：包括字体型号、字体大小
- (UIFont *)curCustomFont;

/// 根据Size获取自定义字体
- (UIFont *)customFontBySize:(CGFloat)fontSize;

/// 根据字体类型获取字体
- (UIFont *)customFontByFontType:(FontType)type size:(CGFloat)fontSize;

/// 根据名字获取字体
- (UIFont *)customFontByName:(NSString *)fontName size:(CGFloat)fontSize;

/// 从字体文件获取字体
- (UIFont *)customFontByPath:(NSString *)fontPath size:(CGFloat)fontSize;

/// 第三方字体是否已注册
- (BOOL)isRegisterCustomFont:(NSString *)fontName;

/// 注册第三方字体,成功返回字体名字,失败返回nil.
- (NSString*)registerCustomFontWitPath:(NSString *)fontPath;

/// 注销第三方字体
- (void)unregisterCustomFont:(NSString *)fontName;

@end
