//
//  FlaStyle.h
//  FlashExporter
//
//  Created by HJC on 12-9-26.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLASTYLE__
#define __FLASTYLE__


#include <stdint.h>
#include "fla_Color4.h"
#include "fla_Holder.h"


namespace fla
{
    typedef enum
    {
        LineCapStyle_Round      = 0,
        LineCapStyle_NoCap      = 1,
        LineCapStyle_Square     = 2,
    } LineCapStyle;
     
    
    typedef enum
    {
        LineJoinStyle_Round     = 0,
        LineJoinStyle_Bevel     = 1,
        LineJoinStyle_Miter     = 2,
    } LineJoinStyle;
    
    
    
    template <int N>
    struct LineStyleBase
    {
        LineStyleBase()
        {
            memset(this, 0, sizeof(LineStyleBase));
            onlyWidthAndColor = true;
        }

        uint8_t         startCapStyle;
        uint8_t         endCapStyle;
        uint8_t         jointStyle;
        
        uint8_t         hasFillFlag :1;
        uint8_t         noHScaleFlag :1;
        uint8_t         noVScaleFlag :1;
        uint8_t         pixelHintingFlag :1;
        uint8_t         noClose :1;
        uint8_t         onlyWidthAndColor :1;
        CGFloat         miterLimitFactor;
        
        Holder<CGFloat, N>  width;
        Holder<Color4, N>   color;
        
        bool operator == (const LineStyleBase& rhs) const
        {
            return memcmp(this, &rhs, sizeof(LineStyleBase)) == 0;
        }
        
        inline bool operator != (const LineStyleBase& rhs) const
        {
            return !(*this == rhs);
        }
    };
        
    typedef LineStyleBase<1> LineStyle;
    typedef LineStyleBase<2> MorphLineStyle;
}


#endif




