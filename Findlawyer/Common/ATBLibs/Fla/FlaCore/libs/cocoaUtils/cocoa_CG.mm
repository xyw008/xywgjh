//
//  cocoa_CG.cpp
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "cocoa_CG.h"

namespace cocoa
{
    namespace CG
    {
        cocoa::CFObjHolder<CGColorRef> createColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
        {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            UIColor* uiColor = [UIColor colorWithRed:r green:g blue:b alpha:a];
            return cocoa::CFObjHolder<CGColorRef>(CGColorRetain(uiColor.CGColor));
#else
            CGColorRef color = CGColorCreateGenericRGB(r, g, b, a);
            return cocoa::CFObjHolder<CGColorRef>(color);
#endif
        }
        
        
        
        cocoa::CFObjHolder<CGColorRef> createGrayColor(CGFloat gray, CGFloat alpha)
        {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
            UIColor* uiColor = [UIColor colorWithWhite:gray alpha:alpha];
            return cocoa::CFObjHolder<CGColorRef>(CGColorRetain(uiColor.CGColor));
#else
            CGColorRef color = CGColorCreateGenericGray(gray, alpha);
            return cocoa::CFObjHolder<CGColorRef>(color);
#endif
        }
        
        
        
        cocoa::CFObjHolder<CGContextRef> newBitmapContext(CGSize size)
        {
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            size_t imgWith = (size_t)(size.width + 0.5);
            size_t imgHeight = (size_t)(size.height + 0.5);
            size_t bytesPerRow = imgWith * 4;
            
            CGContextRef context = CGBitmapContextCreate(
                                                         NULL,
                                                         imgWith,
                                                         imgHeight,
                                                         8,
                                                         bytesPerRow,
                                                         colorSpaceRef,
                                                         (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
            CGColorSpaceRelease(colorSpaceRef);
            return cocoa::CFObjHolder<CGContextRef>(context);
        }
    }
}


