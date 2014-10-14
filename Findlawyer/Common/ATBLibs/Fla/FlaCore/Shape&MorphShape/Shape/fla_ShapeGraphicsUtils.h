//
//  fla_ShapeGraphicsUtils.h
//  SceneEditor
//
//  Created by HJC on 13-1-11.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_SHAPEGRAPHICSUTILS__
#define __FLA_SHAPEGRAPHICSUTILS__


#include "fla_Shape.h"
#include "fla_MorphLerp.h"


namespace fla {
namespace shape {
    
    
    template <typename Graphics>
    void GenPath(Graphics& graphics, const Path& path, bool includeHole)
    {
        graphics.moveTo(path.edges<0>().firstPt().x, path.edges<0>().firstPt().y);
        
        for (auto edge : path.edges<0>())
        {
            if (edge->type() == Edge_LineTo)
            {
                auto& line = static_cast<const LineTo&>(*edge);
                graphics.lineTo(line.pt.x, line.pt.y);
            }
            else if (edge->type() == Edge_CurveTo)
            {
                auto& curve = static_cast<const CurveTo&>(*edge);
                graphics.quadCurveTo(curve.control.x, curve.control.y, curve.pt.x, curve.pt.y);
            }
        }
        
        if (path.hasFillStyle())
        {
            graphics.closePath();
            if (includeHole)
            {
                for (auto& holePath : path.subPaths())
                {
                    GenPath(graphics, holePath, includeHole);
                }
            }
        }
    }
    
    
    template <typename Graphics>
    void GenEdge(Graphics& graphics, Point& startPt, Point& endPt, float ratio, const Edge& edge0, const Edge& edge1)
    {
        auto startType = edge0.type();
        auto endType = edge1.type();
        
        // line, line
        if (startType == Edge_LineTo && endType == Edge_LineTo)
        {
            auto& line0 = static_cast<const LineTo&>(edge0);
            auto& line1 = static_cast<const LineTo&>(edge1);
            startPt = line0.pt;
            endPt = line1.pt;
            auto pt = morph::lerp(line0.pt, line1.pt, ratio);
            graphics.lineTo(pt.x, pt.y);
        }
        // curve, curve
        else if (startType == Edge_CurveTo && endType == Edge_CurveTo)
        {
            auto& curve0 = static_cast<const CurveTo&>(edge0);
            auto& curve1 = static_cast<const CurveTo&>(edge1);
            startPt = curve0.pt;
            endPt = curve1.pt;
            auto ctl = morph::lerp(curve0.control, curve1.control, ratio);
            auto pt = morph::lerp(curve0.pt, curve1.pt, ratio);
            graphics.quadCurveTo(ctl.x, ctl.y, pt.x, pt.y);
        }
        // line, curve
        else if (startType == Edge_LineTo && endType == Edge_CurveTo)
        {
            auto& line0 = static_cast<const LineTo&>(edge0);
            auto& curve1 = static_cast<const CurveTo&>(edge1);
            
            auto ctl0 = (startPt + line0.pt) * 0.5;
            startPt = line0.pt;
            endPt = curve1.pt;
            
            auto ctl = morph::lerp(ctl0, curve1.control, ratio);
            auto pt = morph::lerp(line0.pt, curve1.pt, ratio);
            graphics.quadCurveTo(ctl.x, ctl.y, pt.x, pt.y);

        }
        // curve, line
        else if (startType == Edge_CurveTo && endType == Edge_LineTo)
        {
            auto& curve0 = static_cast<const CurveTo&>(edge0);
            auto& line1 = static_cast<const LineTo&>(edge1);
            
            auto crl1 = (endPt + line1.pt) * 0.5;
            startPt = curve0.pt;
            endPt = line1.pt;
            
            auto ctl = morph::lerp(curve0.control, crl1, ratio);
            auto pt = morph::lerp(curve0.pt, line1.pt, ratio);
            graphics.quadCurveTo(ctl.x, ctl.y, pt.x, pt.y);
        }
    }
    
    
    
    template <typename Graphics>
    void GenMorphPath(Graphics& graphics, const MorphPath& path, float ratio, bool includeHold)
    {
        auto& startEdge = path.edges<0>();
        auto& endEdge = path.edges<1>();
        
        auto start = startEdge.firstPt();
        auto end = endEdge.firstPt();
        auto pt = morph::lerp(start, end, ratio);
        graphics.moveTo(pt.x, pt.y);
        
        for (auto sIter = startEdge.begin(), eIter = endEdge.begin();
             sIter != startEdge.end() && eIter != endEdge.end(); ++sIter, ++eIter)
        {
            auto sEdge = *sIter;
            auto eEdge = *eIter;
            GenEdge(graphics, start, end, ratio, *sEdge, *eEdge);
        }
        
        if (path.hasFillStyle())
        {
            graphics.closePath();
            if (includeHold)
            {
                for (auto& subPath : path.subPaths())
                {
                    GenMorphPath(graphics, subPath, ratio, includeHold);
                }
            }
        }
    }
    
    
    template <typename Graphics>
    inline typename Graphics::LineCap _lineCap(uint8_t cap)
    {
        if (cap == LineCapStyle_Round)
        {
            return Graphics::LineCapRound;
        }
        else if (cap == LineCapStyle_Square)
        {
            return Graphics::LineCapSquare;
        }
        return Graphics::LineCapRound;
    }
    
    
    template <typename Graphics>
    inline typename Graphics::LineJoin _lineJoint(uint8_t joint)
    {
        if (joint == LineJoinStyle_Miter)
        {
            return Graphics::LineJoinMiter;
        }
        else if (joint == LineJoinStyle_Bevel)
        {
            return Graphics::LineJoinBevel;
        }
        return Graphics::LineJoinRound;
    }
}
};



#endif
