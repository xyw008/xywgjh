//
//  fla_PathEdge.h
//  SceneEditor
//
//  Created by HJC on 13-1-5.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef _FLA_PATHEDGE_H
#define _FLA_PATHEDGE_H


#include "fla_Point.h"


namespace fla
{
    //! 边的类型
    typedef enum
    {
        Edge_None,      //! 非法
        Edge_LineTo,    //! 直线
        Edge_CurveTo,   //! 弧线
    } EdgeType;
    
    
    class Edge
    {
    public:
        Edge() : _type(Edge_None)  {}
        EdgeType type() const  {   return (EdgeType)_type;   }
    protected:
        int32_t _type;
    };
    
    
    //! 直线边
    struct LineTo : public Edge
    {
        LineTo()                            {   _type = Edge_LineTo;     }
        LineTo(const Point& pt_) : pt(pt_)  {   _type = Edge_LineTo;     }
        Point pt;
    };
    
    
    //! 弧线边
    struct CurveTo : public LineTo
    {
        CurveTo()   {   _type = Edge_CurveTo;   }
        Point control;
    };
    
    
    //! 根据类型，计算出边的大小
    inline size_t sizeofEdge(const Edge* edge)
    {
        if (edge->type() == Edge_LineTo)   return sizeof(LineTo);
        if (edge->type() == Edge_CurveTo)  return sizeof(CurveTo);
        return 0;
    }
}


#endif


