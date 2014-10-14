//
//  ATBLibs+UIColor.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+UIColor.h"


static struct
{
    const char*   color;
    const char*   hex;
} _HtmlColorHexTable[] = {
    { "black",      "000000"    },
    { "darkgray",   "A9A9A9"    },
    { "lightgray",  "D3D3D3"    },
    { "white",      "FFFFFF"    },
    { "gray",       "808080"    },
    { "red",        "FF0000"    },
    { "green",      "00FF00"    },
    { "blue",       "0000FF"    },
    { "yellow",     "FFFF00"    },
    { "magenta",    "FF00FF"    },
    { "purple",     "800080"    },
    { "brown",      "A52A2A"    },
};

static const char* _findColorTable(const char* color)
{
    NSInteger size = sizeof(_HtmlColorHexTable) / sizeof(_HtmlColorHexTable[0]);
    for (NSInteger idx = 0; idx < size; idx++)
    {
        if (!strcmp(color, _HtmlColorHexTable[idx].color))
        {
            return _HtmlColorHexTable[idx].hex;
        }
    }
    return NULL;
}



inline static NSInteger _fromHex1(unichar c)
{
    // 数字
	if (c >= '0' && c <= '9')   
	{
        return (c - '0');
	}
    
    // 小写字母
	if (c >= 'a' && c <= 'f')
	{
		return (c - 'a' + 10);
	}
    
    // 大写字母
	if (c >= 'A' && c <= 'F')
	{
		return  (c - 'A' + 10);
	}
    
    return 0;
}



inline static NSInteger _fromHex2(unichar c0, unichar c1)
{
	NSInteger val0 = _fromHex1(c0);
	NSInteger val1 = _fromHex1(c1);
	return val0 * 16 + val1;
}


inline static BOOL _isAllHex(NSString* string)
{
    NSInteger len = [string length];
    for (NSInteger idx = 0; idx < len; idx++)
    {
        unichar c = [string characterAtIndex:idx];
        if (!(c >= '0' && c <= '9') && 
            !(c >= 'a' && c <= 'f') && 
            !(c >= 'A' && c <= 'F'))
        {
            return FALSE;
        }
    }
    return YES;
}



static UIColor* _colorFromHex(NSString* string)
{
    NSInteger red = 1.0;
    NSInteger green = 1.0;
    NSInteger blue = 1.0;
    
    switch ([string length]) 
    {
        case 3: // RGB
            red = _fromHex2([string characterAtIndex:0], [string characterAtIndex:0]);
            green = _fromHex2([string characterAtIndex:1], [string characterAtIndex:1]);
            blue = _fromHex2([string characterAtIndex:2], [string characterAtIndex:2]);
            break;
            
        case 6: // RRGGBB
            red = _fromHex2([string characterAtIndex:0], [string characterAtIndex:1]);
            green = _fromHex2([string characterAtIndex:2], [string characterAtIndex:3]);
            blue = _fromHex2([string characterAtIndex:4], [string characterAtIndex:5]);
            break;
            
        default:
            break;
    }
    return [UIColor colorWithRed:red / 255.0f
                           green:green / 255.0f
                            blue:blue / 255.0f
                           alpha:1.0];
}


static UIColor* _colorFromColorString(NSString* string)
{
    const char* hex = _findColorTable([string UTF8String]);
    if (hex == NULL)
    {
        if ([string isEqualToString:@"clear"])
        {
            return [UIColor clearColor];
        }
        return [UIColor whiteColor];
    }
    return _colorFromHex([NSString stringWithUTF8String:hex]);
}


static NSArray* _getArgList(NSString* rgb)
{
    rgb = [rgb stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange begin = [rgb rangeOfString:@"("];
    NSRange end = [rgb rangeOfString:@")" options:NSBackwardsSearch];
    
    if (begin.location != NSNotFound && end.location != NSNotFound)
    {
        NSRange range = { 
            begin.location + begin.length, 
            end.location - (begin.location + begin.length)
        };
        
        rgb = [rgb substringWithRange:range];
        NSArray* array = [rgb componentsSeparatedByString:@","];
        return array;
    }
    return nil;
}


static UIColor* _colorFromRGB(NSString* rgb)
{
    NSArray* array = _getArgList(rgb);
    if ([array count] == 3)
    {
        NSInteger red = [[array objectAtIndex:0] intValue];
        NSInteger green = [[array objectAtIndex:1] intValue];
        NSInteger blue = [[array objectAtIndex:2] intValue];
        return [UIColor colorWithRed:red / 255.0f
                               green:green / 255.0f
                                blue:blue / 255.0f
                               alpha:1.0];
    }
    return [UIColor whiteColor];
}


static UIColor* _colorFromRGBA(NSString* rgba)
{
    NSArray* array = _getArgList(rgba);
    if ([array count] == 4)
    {
        NSInteger red = [[array objectAtIndex:0] intValue];
        NSInteger green = [[array objectAtIndex:1] intValue];
        NSInteger blue = [[array objectAtIndex:2] intValue];
        CGFloat alpha = [[array objectAtIndex:3] floatValue];
        return [UIColor colorWithRed:red / 255.0f
                               green:green / 255.0f
                                blue:blue / 255.0f
                               alpha:alpha];
    }
    return [UIColor whiteColor];
}



typedef enum
{
    _HtmlColorType_None,
    _HtmlColorType_RGB,
    _HtmlColorType_RGBA,
    _HtmlColorType_Hex,
    _HtmlColorType_Color,
} _HtmlColorType;


@implementation UIColor(ATBLibsAddtions)


+ (UIColor*) colorFromString:(NSString*)string
{
    // 去掉前后空格并转成小写
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string lowercaseString];
    
    _HtmlColorType colorType = _HtmlColorType_None;
    if ([string hasPrefix:@"#"] || [string hasPrefix:@"0x"])
    {
        if ([string hasPrefix:@"#"])
            string = [string substringFromIndex:1];
        else
            string = [string substringFromIndex:2];
        
        if (_isAllHex(string))
        {
            colorType = _HtmlColorType_Hex;
        }
    }
    else
    {
        if (_isAllHex(string))
        {
            colorType = _HtmlColorType_Hex;
        }
        else if ([string hasPrefix:@"rgba"])
        {
            colorType = _HtmlColorType_RGBA;
        }
        else if ([string hasPrefix:@"rgb"])
        {
            colorType = _HtmlColorType_RGB;
        }
        else
        {
            colorType = _HtmlColorType_Color;
        }
    }
    

    switch (colorType) 
    {
        case _HtmlColorType_Hex:
            return _colorFromHex(string);
            
        case _HtmlColorType_Color:
            return _colorFromColorString(string);
            
        case _HtmlColorType_RGB:
            return _colorFromRGB(string);
            
        case _HtmlColorType_RGBA:
            return _colorFromRGBA(string);
            
        default:
            break;
    }
    
    return [UIColor whiteColor];
}

- (void)getRGBAComponents:(CGFloat [4])components
{
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4] = {0};
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    CGFloat a = resultingPixel[3] / 255.0;
    CGFloat unpremultiply = (a != 0.0) ? 1.0 / a / 255.0 : 0.0;
    for (int component = 0; component < 3; component++)
    {
        components[component] = resultingPixel[component] * unpremultiply;
    }
    components[3] = a;
}

@end
