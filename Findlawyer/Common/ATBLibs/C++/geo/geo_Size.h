//
//  geo_point.h
//  KidsPainting
//
//  Created by HJC on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef _GEO_SIZE_H_
#define _GEO_SIZE_H_


namespace geo  
{
    struct Size
    {
        Size(float w, float h) : width(w), height(h)
        {
        }
        
        Size() : width(0.0f), height(0.0f)
        {
        }
        
        void set(float w, float h)
        {
            width = w;
            height = h;
        }
        
        float   width;
        float   height;
    };
};


#endif
