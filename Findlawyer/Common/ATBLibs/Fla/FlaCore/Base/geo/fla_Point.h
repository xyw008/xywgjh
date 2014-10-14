//
//  fla_Point.h
//  SceneEditor
//
//  Created by HJC on 13-1-8.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_POINT__
#define __FLA_POINT__


#include "fla_types.h"
#include <cmath>


namespace fla
{
    class Point : public CGPoint
    {
    public:
        typedef CGFloat scalar;
        Point(scalar x_, scalar y_)
        {
            x = x_;
            y = y_;
        }
        
        Point()
        {
            x = 0;
            y = 0;
        }
        

        bool operator == (const Point& rhs) const
        {
            scalar deviation = 0.001;
            return (std::fabs(x - rhs.x) < deviation) &&
                   (std::fabs(y - rhs.y) < deviation);
        }
        
        Point& operator += (const Point& rhs)
        {
            x += rhs.x;
            y += rhs.y;
            return *this;
        }
    
        Point operator + (const Point& rhs) const
        {
            return Point(x + rhs.x, y + rhs.y);
        }
        
        
        Point operator - (const Point& rhs) const
        {
            return Point(x - rhs.x, y - rhs.y);
        }
        
        
        Point operator * (scalar s) const
        {
            return Point(x * s, y * s);
        }
        
        CGFloat length() const
        {
            return std::sqrt(x * x + y + y);
        }
    };
}


#endif
