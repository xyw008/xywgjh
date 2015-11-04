//
//  ColorManager.m
//  websiteEmplate
//
//  Created by admin on 13-4-2.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "ColorManager.h"

#define DEFAULT_VIOD_COLOR [UIColor clearColor]

@implementation ColorManager

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return DEFAULT_VIOD_COLOR;
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VIOD_COLOR;
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //red
    NSString *rString = [cString substringWithRange:range];
    //green
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //blue
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
