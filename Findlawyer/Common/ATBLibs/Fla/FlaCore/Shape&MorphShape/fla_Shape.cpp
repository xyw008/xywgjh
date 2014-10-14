//
//  FlaShapeWithStyle.cpp
//  FlashExporter
//
//  Created by HJC on 12-9-27.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_Shape.h"


namespace fla
{    
    Rect Shape::computeEdgeBounds() const
    {
        if (paths.empty())
        {
            return Rect();
        }
        
        auto bounds = paths[0].edges<0>().computeEdgeBounds();
        auto size = paths.size();
        
        for (auto i = 1; i < size; i++)
        {
            bounds.unionRect(paths[i].edges<0>().computeEdgeBounds());
        }
        
        return bounds;
    }
}





