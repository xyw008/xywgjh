//
//  fla_transToImage.h
//  FlashConvertor
//
//  Created by HJC on 13-2-22.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_TRANSTOIMAGE__
#define __FLA_TRANSTOIMAGE__


#include "fla_Define.h"
#include "fla_RenderDefine.h"


namespace fla
{
    struct TransToImageInfo
    {
        TransToImageInfo()
        {
            scale = 1.0f;
            hasBackground = false;
            hasImage = true;
        }
        float   scale;
        bool    hasBackground;
        bool    hasImage;
    };
    
    cocoa::CFObjHolder<CGImageRef> define_transToImage(const Define& define, float scale);
    cocoa::CFObjHolder<CGImageRef> define_transToImage(const Define& define, const TransToImageInfo& info);
}

#endif
