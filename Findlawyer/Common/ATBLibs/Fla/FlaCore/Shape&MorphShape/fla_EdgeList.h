//
//  fla_EdgeList.h
//  SceneEditor
//
//  Created by HJC on 13-1-17.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_EDGELIST__
#define __FLA_EDGELIST__


#include "fla_PathEdge.h"
#include "fla_Rect.h"
#include <vector>


namespace fla
{
    //! 边构成路径
    class EdgeList
    {
    public:
        EdgeList() : _lastEdgePos(0)
        {
        }
        
        void addEdge(const LineTo& edge)    {   pushEdge((uint8_t*)&edge, sizeof(LineTo));  }
        void addEdge(const CurveTo& edge)   {   pushEdge((uint8_t*)&edge, sizeof(CurveTo)); }
        
        bool joint(const EdgeList& path);
        void flipPath();
        
        // 计算各边合起来的包围框
        Rect computeEdgeBounds() const;
        
        
        class EdgeIter
        {
        public:
            EdgeIter(const uint8_t* cur) : _cur(cur)        {}
            
            const Edge* operator * () const            {   return ((Edge*)_cur);     }
            bool operator != (const EdgeIter& rhs) const    {   return (_cur != rhs._cur);      }
            EdgeIter& operator ++ ()
            {
                _cur += sizeofEdge((Edge*)_cur);
                return *this;
            }
            
        private:
            const uint8_t*  _cur;
        };
        
        
        EdgeIter begin() const  {   return EdgeIter(&_edges[0]);                }
        EdgeIter end() const    {   return EdgeIter(&_edges[_edges.size()]);    }
        
        void   setFirstPt(const Point& pt)    {   _firstPt = pt;  }
        const   Point& firstPt() const        {   return _firstPt;    }
        const   Point& lastPoint() const;
        
        
        bool isEdgeEmpty() const                                {   return _edges.empty();              }
        bool isClosed() const                                   {   return  _firstPt == lastPoint();    }
        bool isEdgesEqualTo(const EdgeList& other) const        {   return _firstPt == other._firstPt && _edges == other._edges;    }
        bool isFlipEdgesEqualTo(const EdgeList& other) const;
        bool isLastEdge(const Edge* edge) const;
        
    private:
        void pushEdge(uint8_t* bytes, size_t size);
        
    private:
        std::vector<uint8_t>    _edges;
        Point                   _firstPt;
        size_t                  _lastEdgePos;
    };
    
    
    inline const Point& EdgeList::lastPoint() const
    {
        if (isEdgeEmpty())
        {
            return _firstPt;
        }
        auto edge = reinterpret_cast<const LineTo*>(&_edges[_lastEdgePos]);
        return edge->pt;
    }
    

    inline bool EdgeList::isLastEdge(const Edge* edge) const
    {
        auto lastEdge = &_edges[_lastEdgePos];
        return (uint8_t*)edge >= lastEdge;
    }
    
    
    inline void EdgeList::pushEdge(uint8_t* bytes, size_t size)
    {
        _lastEdgePos = _edges.size();
        _edges.insert(_edges.end(), bytes, bytes + size);
    }
}




#endif
