//
//  ColorManager.h
//  websiteEmplate
//
//  Created by admin on 13-4-2.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorManager : NSObject

/**
 * 方法描述: 16进制颜色(html颜色值)字符串转为UIColor
 * 输入参数: 16进制颜色字符串
 * 返回值: UIColor
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

@end
