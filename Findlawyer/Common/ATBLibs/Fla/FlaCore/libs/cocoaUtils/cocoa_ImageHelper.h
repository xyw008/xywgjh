//
//  cocoa_ImageHelper.h
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __COCOA_IMAGEHELPER__
#define __COCOA_IMAGEHELPER__


#include "cocoa_CFObjHolder.h"
#include <CoreGraphics/CoreGraphics.h>
#include <vector>


namespace cocoa
{
    struct ImageHelper
    {
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        static void writePNGToFile(CGImageRef imgRef, const std::string& filePath);
        static void writePNGToData(CGImageRef imgRef, std::vector<uint8_t>& data);
#endif
        static cocoa::CFObjHolder<CGImageRef> loadPNGFromFile(const std::string& filePath);
        static cocoa::CFObjHolder<CGImageRef> loadPNGFromData(const uint8_t* data, size_t len);
    };
}



#endif
