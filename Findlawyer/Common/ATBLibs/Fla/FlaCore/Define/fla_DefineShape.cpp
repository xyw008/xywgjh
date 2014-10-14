//
//  fla_DefineShape.cpp
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_DefineShape.h"


namespace fla
{
    bool DefineShape::addBitmapDefine(const DefineImagePtr& bitmap)
    {
        for (auto& ptr : _bitmapDefines)
        {
            if (ptr->Id() == bitmap->Id())
            {
                return false;
            }
        }
        
        _bitmapDefines.push_back(bitmap);
        return false;
    }
    
    
    
    CGImageRef DefineShape::GetBitmap::getBitmap(int bitmapId) const
    {
        for (auto& img : _shape.bitmapDefines())
        {
            if (img->Id() == bitmapId)
            {
                return img->image();
            }
        }
        return nullptr;
    }
}


