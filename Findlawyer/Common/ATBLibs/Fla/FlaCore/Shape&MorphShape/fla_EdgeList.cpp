//
//  fla_EdgeList.cpp
//  SceneEditor
//
//  Created by HJC on 13-1-17.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "fla_EdgeList.h"
#include <stack>


namespace fla
{
    bool EdgeList::joint(const EdgeList& other)
    {
        if (lastPoint() == other._firstPt)
        {
            _lastEdgePos = other._lastEdgePos + _edges.size();
            _edges.insert(_edges.end(), other._edges.begin(), other._edges.end());
            return true;
        }
        return false;
    }
    
    
    
    void EdgeList::flipPath()
    {
        if (isEdgeEmpty())
        {
            return;
        }
        
        CurveTo  edgeData;
        std::stack<CurveTo>   stack;
        auto edgeSize = sizeofEdge((Edge*)&_edges[0]);
        _lastEdgePos = _edges.size() - edgeSize;
        
        for (auto edge : *this)
        {
            memcpy(&edgeData, edge, sizeofEdge(edge));
            std::swap(edgeData.pt, _firstPt);
            stack.push(edgeData);
        }
        
        _edges.clear();
        while (!stack.empty())
        {
            auto& top = stack.top();
            pushEdge((uint8_t*)&top, sizeofEdge(&top));
            stack.pop();
        }
    }
    
    
    
    static void unionPoint(Point& minPt, Point& maxPt, const Point& pt)
    {
        minPt.x = std::min(minPt.x, pt.x);
        minPt.y = std::min(minPt.y, pt.y);
        maxPt.x = std::max(maxPt.x, pt.x);
        maxPt.y = std::max(maxPt.y, pt.y);
    }
    
    
    
    Rect EdgeList::computeEdgeBounds() const
    {
        Point minPt = _firstPt;
        Point maxPt = _firstPt;
        
        for (auto edge : *this)
        {
            if (edge->type() == Edge_LineTo)
            {
                auto line = static_cast<const LineTo*>(edge);
                unionPoint(minPt, maxPt, line->pt);
            }
            else if (edge->type() == Edge_CurveTo)
            {
                auto curve = static_cast<const CurveTo*>(edge);
                unionPoint(minPt, maxPt, curve->pt);
                unionPoint(minPt, maxPt, curve->control);
            }
        }
        
        auto width = maxPt.x - minPt.x;
        auto height = maxPt.y - minPt.y;
        return Rect(minPt.x, minPt.y, width, height);
    }
    
    
    
    bool EdgeList::isFlipEdgesEqualTo(const EdgeList& other) const
    {
        if (_edges.size() != other._edges.size())
        {
            return false;
        }
        EdgeList flipPath = other;
        flipPath.flipPath();
        return isEdgesEqualTo(flipPath);
    }
}


