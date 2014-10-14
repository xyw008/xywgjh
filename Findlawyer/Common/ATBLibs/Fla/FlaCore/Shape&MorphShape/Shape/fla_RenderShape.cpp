//
//  fla_RenderShape.cpp
//  SceneEditor
//
//  Created by HJC on 12-12-25.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_RenderShape.h"
#include "fla_ShapeGraphicsUtils.h"



namespace fla
{
    bool isSolidFill(const Shape& shape, const Path& path)
    {
        if (path.fillStyle() >= 0)
        {
            if (shape.fillStyles[path.fillStyle()].isSolidStyle())
            {
                return true;
            }
        }
        return false;
    }
    
}

