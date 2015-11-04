//
//  geo_point.h
//  KidsPainting
//
//  Created by HJC on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef _GEO_POINT_H_
#define _GEO_POINT_H_


#include <cmath>

namespace geo  
{
    class Point
    {
    public:
        Point(float x_, float y_) : x(x_), y(y_)
        {
        }
        
        Point() : x(0.0f), y(0.0f)
        {
        }
        
        Point operator - (const Point& rhs) const
        {
            return Point(x - rhs.x, y - rhs.y);
        }
        
        Point operator + (const Point& rhs) const
        {
            return Point(x + rhs.x, y + rhs.y);
        }
        
        Point operator * (float factor) const
        {
            return Point(x * factor, y * factor);
        }
        
        
        float dot(const Point& rhs) const
        {
            return x * rhs.x + y * rhs.y;
        }
    
        Point middle(const Point& rhs)  const
        {
            return Point( (x + rhs.x) * 0.5, (y + rhs.y) * 0.5f );
        }
        
        
        float distanceTo(const Point& pt) const
        {
            float xoffset = pt.x - x;
            float yoffset = pt.y - y;
            return sqrtf(xoffset * xoffset + yoffset * yoffset);
        }
        
        void set(float x_, float y_)    
        {
            x = x_;
            y = y_;
        }
        
        float   x;
        float   y;
    };
};


#endif
