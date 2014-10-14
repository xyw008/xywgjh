//
//  fla_Rect.h
//  SceneEditor
//
//  Created by HJC on 13-1-8.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_RECT__
#define __FLA_RECT__


#include "fla_types.h"
#include "fla_Matrix.h"
#include <algorithm>


namespace fla
{
    class Rect
    {
    public:
        Rect(scalar x_, scalar y_, scalar width_, scalar height_);
        Rect() : x(0.0), y(0.0), width(0.0), height(0.0)    {}
        
        bool isContains(const Rect& rhs) const
        {
            return CGRectContainsRect(asRect(), rhs.asRect());
        }

        scalar getMaxX() const  {   return x + width;   }
        scalar getMaxY() const  {   return y + height;  }
        
        scalar midX() const     {   return x + width * 0.5;     }
        scalar midY() const     {   return y + height * 0.5;    }

        void unionRect(const Rect& rect);
        bool isSeparated(const Rect& rect) const;
        
        void applyAffineTransform(const Matrix& t)
        {
            asRect() = CGRectApplyAffineTransform(asRect(), t);
        }
        
        Rect& operator *= (scalar scale);
        
        const CGRect& asRect() const    {   return *((CGRect*)this);    }
        CGRect& asRect()                {   return *((CGRect*)this);    }
        operator CGRect() const         {   return asRect();            }

        scalar  x;
        scalar  y;
        scalar  width;
        scalar  height;
    };
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    inline Rect::Rect(scalar x_, scalar y_, scalar width_, scalar height_) : x(x_), y(y_), width(width_), height(height_)
    {
    }
    
    
    inline void Rect::unionRect(const Rect& rect)
    {
        asRect() = CGRectUnion(asRect(), rect.asRect());
    }
    
    
    inline bool Rect::isSeparated(const Rect& rect) const
    {
        if (getMaxX() < rect.x)
        {
            return true;
        }
        
        if (getMaxY() < rect.y)
        {
            return true;
        }
        
        if (rect.getMaxX() < x)
        {
            return true;
        }
        
        if (rect.getMaxY() < y)
        {
            return true;
        }
        
        return false;
    }
    
    
    inline Rect& Rect::operator *= (scalar s)
    {
        x *= s;
        y *= s;
        width *= s;
        height *= s;
        return *this;
    }
}


#endif
