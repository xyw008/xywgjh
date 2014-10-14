//
//  cocoa_platform.cpp
//  SDKiOSLayerTest
//
//  Created by HJC on 13-1-5.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "cocoa_platform.h"


namespace cocoa
{
    CGFloat mainScreenScale()
    {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
        return [UIScreen mainScreen].scale;
#else
        return 1.0;
#endif
    }
}
