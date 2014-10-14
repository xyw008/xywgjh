//
//  cocoa_ImageHelper.cpp
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "cocoa_ImageHelper.h"
#include <string>


namespace cocoa
{
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    
#include <ImageIO/ImageIO.h>
    extern "C" const CFStringRef kUTTypePNG;
    void ImageHelper::writePNGToFile(CGImageRef image, const std::string& filePath)
    {
        CFStringRef path = CFStringCreateWithCString(NULL, filePath.c_str(), kCFStringEncodingUTF8);
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, false);
        
        CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
        CGImageDestinationAddImage(destination, image, nil);
        
        if (!CGImageDestinationFinalize(destination))
        {
        }
        
        CFRelease(destination);
        CFRelease(url);
        CFRelease(path);
    }
    
    
    void ImageHelper::writePNGToData(CGImageRef image, std::vector<uint8_t>& data)
    {
        CFMutableDataRef pngData = CFDataCreateMutable(NULL, 0);
        CGImageDestinationRef destination = CGImageDestinationCreateWithData(pngData, kUTTypePNG, 1, NULL);
        CGImageDestinationAddImage(destination, image, nil);
        
        if (!CGImageDestinationFinalize(destination))
        {
        }
        
        CFRelease(destination);
        
        
        auto len = CFDataGetLength(pngData);
        const uint8_t* bytes = CFDataGetBytePtr(pngData);
        
        data.clear();
        data.insert(data.end(), bytes, bytes + len);
        
        CFRelease(pngData);
    }
#endif
    
    
    
    cocoa::CFObjHolder<CGImageRef> ImageHelper::loadPNGFromFile(const std::string& filePath)
    {
        CFStringRef path = CFStringCreateWithCString(NULL, filePath.c_str(), kCFStringEncodingUTF8);
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, false);
        
        CGDataProviderRef data = CGDataProviderCreateWithURL(url);
        CGImageRef image = nullptr;
        
        if (data)
        {
            image = CGImageCreateWithPNGDataProvider(data, NULL, false, kCGRenderingIntentDefault);
        }
        
        CGDataProviderRelease(data);
        CFRelease(url);
        CFRelease(path);
        
        return cocoa::CFObjHolder<CGImageRef>(image);
    }
    
    
    
    cocoa::CFObjHolder<CGImageRef> ImageHelper::loadPNGFromData(const uint8_t* data, size_t len)
    {
        CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, (void*)data, len, NULL);
        CGImageRef image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, false, kCGRenderingIntentDefault);
        CGDataProviderRelease(dataProvider);
        return cocoa::CFObjHolder<CGImageRef>(image);
    }
}


