//
//  fla_ShapeRenderInfo.h
//  SDKiOSLayerTest
//
//  Created by HJC on 13-1-7.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_SHAPERENDERINFO__
#define __FLA_SHAPERENDERINFO__


#include "fla_ColorTransform.h"
#include "fla_Color4.h"


namespace fla
{
    struct GetShapeBitmap
    {
        virtual CGImageRef getBitmap(int bitmapId) const
        {
            return nullptr;
        }
    };
    
    
    class ColorTransform;
    class ShapeRenderInfo
    {
    public:
        ShapeRenderInfo(const GetShapeBitmap& getBitmap_, const ColorTransform& colorTrans_);
        ShapeRenderInfo(const ColorTransform& colorTrans_);
        ShapeRenderInfo();
        
        Color4 transColor(const Color4& color) const
        {
            return colorTrans * color;
        }
        
        const GetShapeBitmap&   getBitmap;
        const ColorTransform&   colorTrans;
        
    private:
        static GetShapeBitmap& defaultGetShapeBitmap()
        {
            static GetShapeBitmap getBitmap;
            return getBitmap;
        }
        
        static ColorTransform& defaultColorTransform()
        {
            static ColorTransform transform;
            return transform;
        }
    };
    
    
    inline ShapeRenderInfo::ShapeRenderInfo(const GetShapeBitmap& getBitmap_,
                                            const ColorTransform& colorTrans_)
    : getBitmap(getBitmap_), colorTrans(colorTrans_)
    {}
    
    
    inline ShapeRenderInfo::ShapeRenderInfo(const ColorTransform& colorTrans_)
    : getBitmap(defaultGetShapeBitmap()), colorTrans(colorTrans_)
    {
    }
    
    inline ShapeRenderInfo::ShapeRenderInfo()
    : getBitmap(defaultGetShapeBitmap()), colorTrans(defaultColorTransform())
    {
    }
}



#endif
