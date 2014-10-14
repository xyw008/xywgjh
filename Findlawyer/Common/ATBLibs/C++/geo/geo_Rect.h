//
//  geo_point.h
//  KidsPainting
//
//  Created by HJC on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef _GEO_RECT_H_
#define _GEO_RECT_H_


#include <algorithm>
#include "geo_Point.h"
#include "geo_Size.h"


namespace geo  
{
    class Rect
    {
    public:
        Rect(const Rect& rect) : x(rect.x), y(rect.y), width(rect.width), height(rect.height)
        {
        }
        
        Rect(float x_, float y_, float width_, float height_) : x(x_), y(y_), width(width_), height(height_)
        {
        }
        
        Rect(const Point& pt, const Size& size) : x(pt.x), y(pt.y), width(size.width), height(size.height)
        {
        }
        
        Rect() : x(0.0f), y(0.0f), width(0.0f), height(0.0f)
        {
        }
        
        Rect(const Point& p0, const Point& p1)
        {
            resetRect(p0);
            unionPoint(p1);
        }
        
        void set(float x_, float y_, float width_, float height_)
        {
            x = x_;
            y = y_;
            width = width_;
            height = height_;
        }
        
        bool containsPoint(float x_, float y_) const
        {
            return (x <= x_ && x_ <= x + width) && (y <= y_ && y_ <= y + height);
        }
        
        void inset(float iX, float iY)
        {
            x += iX;
            y += iY;
            width -= 2 * iX;
            height -= 2 * iY;
        }
        
        float getMaxX() const
        {
            return x + width;
        }
        
        float getMaxY() const
        {
            return y + height;
        }
        
        bool isSeparated(const Rect& rect) const;        
        void standard();
        
        // 矩形并集
        void unionRect(const Rect& rect)
        {
            float minX = std::min(x, rect.x);
            float minY = std::min(y, rect.y);
            float maxX = std::max(x + width, rect.x + rect.width);
            float maxY = std::max(y + width, rect.y + rect.height);
            x = minX;
            y = minY;
            width = maxX - minX;
            height = maxY - minY;
        }
        
        
        
        Rect intersection(const Rect& rhs) const
        {
            if (isSeparated(rhs))
            {
                return Rect(0.0f, 0.0f, 0.0f, 0.0f);
            }
            
            Rect tmp;
            tmp.x = std::max(x, rhs.x);
            tmp.y = std::max(y, rhs.y);

            tmp.width = std::min(getMaxX(), rhs.getMaxX()) - tmp.x;
            tmp.height = std::min(getMaxY(), rhs.getMaxY()) - tmp.y;
            
            return tmp;
        }
        
        
        void resetRect(float x_, float y_)
        {
            x = x_;
            y = y_;
            width = 0.0f;
            height = 0.0f;
        }
        
        
        void resetRect(const Point& p)
        {
            resetRect(p.x, p.y);
        }
        
        
        void unionPoint(float x_, float y_)
        {
            float minX = std::min(x, x_);
            float minY = std::min(y, y_);
            float maxX = std::max(x + width, x_);
            float maxY = std::max(y + height, y_);
            x = minX;
            y = minY;
            width = maxX - minX;
            height = maxY - minY;
        }
        
        
        void unionPoint(const Point& p)
        {
            unionPoint(p.x, p.y);
        }
        
        
        float   x;
        float   y;
        float   width;
        float   height;
    };
    
    
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
    
    
    inline void Rect::standard()
    {
        if (width < 0)
        {
            x = x + width;
            width = -width;
        }
        
        if (height < 0)
        {
            y = y + height;
            height = -height;
        }
    }


};


#endif
