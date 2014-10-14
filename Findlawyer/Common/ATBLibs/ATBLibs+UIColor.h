//
//  ATBLibs+UIColor.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor(ATBLibsAddtions)

// 将html中的颜色字符串转成UIColor, 比如 #FF0000, 会是红色
// #RGB
// #RRGGBB
// 并支持 rgb, rgba方式
+ (UIColor*)  colorFromString:(NSString*)string;

// 获取UIColor中RGB和alpha的组成值
- (void)getRGBAComponents:(CGFloat[4])components;

@end



////////////////////////////////////////////////////
static inline UIColor* ATColorRGBMake(NSInteger r, NSInteger g, NSInteger b)
{
    return [UIColor colorWithRed:(r / 255.0)
                           green:(g / 255.0)
                            blue:(b / 255.0) 
                           alpha:1.0];
}


////////////////////////////////////////////////////////