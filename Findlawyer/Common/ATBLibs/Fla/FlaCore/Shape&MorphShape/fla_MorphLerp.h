//
//  fla_MorphLerp.h
//  SceneEditor
//
//  Created by HJC on 13-1-21.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_MORPHLERP__
#define __FLA_MORPHLERP__


#include "fla_Point.h"
#include "fla_Color4.h"
#include "fla_Matrix.h"
#include "fla_PathEdge.h"


namespace fla {
namespace morph {

    
    inline scalar lerp(scalar lhs, scalar rhs, scalar ratio)
    {
        return lhs * (1.0 - ratio) + rhs * ratio;
    }
    
    
    //! 插值, ratio(0 - 1)之间
    inline Point lerp(const Point& lhs, const Point& rhs, scalar ratio)
    {
        return Point(lerp(lhs.x, rhs.x, ratio), lerp(lhs.y, rhs.y, ratio));
    }
    
    
    inline Color4 lerp(const Color4& lhs, const Color4& rhs, scalar ratio)
    {
        auto r = lerp(lhs.red, rhs.red, ratio);
        auto g = lerp(lhs.green, rhs.green, ratio);
        auto b = lerp(lhs.blue, rhs.blue, ratio);
        auto a = lerp(lhs.alpha, rhs.alpha, ratio);
        return Color4(r, g, b, a);
    }
    
    
    inline CGAffineTransform lerp(const CGAffineTransform& lhs, const CGAffineTransform& rhs, scalar ratio)
    {
        CGAffineTransform trans;
        trans.a = lerp(lhs.a, rhs.a, ratio);
        trans.b = lerp(lhs.b, rhs.b, ratio);
        trans.c = lerp(lhs.c, rhs.c, ratio);
        trans.d = lerp(lhs.d, rhs.d, ratio);
        trans.tx = lerp(lhs.tx, rhs.tx, ratio);
        trans.ty = lerp(lhs.ty, rhs.ty, ratio);
        return trans;
    }
    
}
}


#endif
