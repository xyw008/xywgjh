//
//  cocoa_CG.h
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __COCOA_CG__
#define __COCOA_CG__


#include <CoreGraphics/CoreGraphics.h>
#include "cocoa_CFObjHolder.h"


namespace cocoa
{
    namespace CG
    {
        CFObjHolder<CGContextRef> newBitmapContext(CGSize size);
        CFObjHolder<CGColorRef>   createColor(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
        CFObjHolder<CGColorRef>   createGrayColor(CGFloat gray, CGFloat alpha);
    }
}

#endif
