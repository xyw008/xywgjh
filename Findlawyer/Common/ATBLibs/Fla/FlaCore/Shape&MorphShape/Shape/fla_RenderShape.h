//
//  fla_RenderShape.h
//  SceneEditor
//
//  Created by HJC on 12-12-25.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_RENDERSHAPE__
#define __FLA_RENDERSHAPE__


#include "fla_Shape.h"
#include "ScopeGuard.h"
#include <assert.h>
#include "fla_ShapeRenderInfo.h"
#include "fla_ShapeGraphicsUtils.h"



namespace fla
{
    bool isSolidFill(const Shape& shape, const Path& path);

    
    template <typename RenderT>
    static void DrawPath(RenderT& render, const Path& path)
    {
        if (path.fillStyle() >= 0 && path.lineStyle() >= 0)
        {
            render.drawPath(RenderT::PathEOFillStroke);
        }
        else if (path.fillStyle() >= 0)
        {
            render.drawPath(RenderT::PathEOFill);
        }
        else if (path.lineStyle() >= 0)
        {
            render.drawPath(RenderT::PathStroke);
        }
        else
        {
            render.drawPath(RenderT::PathEOFillStroke);
        }
    }
    
    

    template <typename RenderT>
    static void FillSolidStrokePath(const Shape& shape, const Path& path, RenderT& context, const ShapeRenderInfo& drawInfo)
    {
        if (path.fillStyle() >= 0)
        {
            auto& style = shape.fillStyles[path.fillStyle()];
            assert(style.isSolidStyle());
            
            auto color = drawInfo.transColor(style.solidColor());
            context.setFillColor(color.red, color.green, color.blue, color.alpha);
        }
        
        
        if (path.lineStyle() >= 0)
        {
            auto& style = shape.lineStyles[path.lineStyle()];
            
            auto color = drawInfo.transColor(style.color);
            context.setLineWidth(std::max<CGFloat>(style.width, 1.0));
            context.setStrokeColor(color.red, color.green, color.blue, color.alpha);
        }
        
        shape::GenPath(context, path, true);
        DrawPath(context, path);
    }
    
    
    template <typename RenderT>
    void FillGradientPath(const Shape& shape, const Path& path, RenderT& render, const ShapeRenderInfo& drawInfo)
    {
        assert(path.fillStyle() >= 0);
        auto& style = shape.fillStyles[path.fillStyle()];
        assert(style.isGradientStyle());
        
        shape::GenPath(render, path, true);        
        auto& ptr = style.gradient();
        
        auto recSize = ptr.records().size();
        std::vector<Color4> colors(recSize);
        std::vector<CGFloat> locations(recSize);
        
        for (auto i = 0; i < recSize; i++)
        {
            colors[i] = drawInfo.colorTrans * ptr.records()[i].color;
            locations[i] = ptr.records()[i].location;
        }
        
        render.drawGradient(colors,
                            locations,
                            style.fillType() == FillType::LinearGradient,
                            ptr.radius(),
                            ptr.matrix().val
                            );
    }
    

    template <typename RenderT>
    static void FillBitmapPath(const Shape& shape, const Path& path, RenderT& render, const ShapeRenderInfo& drawInfo)
    {
        assert(path.fillStyle() >= 0);
        auto& style = shape.fillStyles[path.fillStyle()];
        assert(style.isBitmapStyle());
        
        CGImageRef img = drawInfo.getBitmap.getBitmap(style.bitmapId());
        if (img)
        {
            Rect rt = path.edges<0>().computeEdgeBounds();
            
            render.saveGState();
            render.translateCTM(rt.x, rt.y + rt.height);
            render.scaleCTM(1, -1);
            
            rt.x = 0;
            rt.y = 0;
            render.drawImage(rt.asRect(), img);
            
            render.restoreGState();
        }
    }
    
    
    
    template <typename RenderT>
    static void FillSolidPath(const Shape& shape, const Path& path, RenderT& render, const ShapeRenderInfo& drawInfo)
    {
        assert(path.fillStyle() >= 0);
        auto& style = shape.fillStyles[path.fillStyle()];
        assert(style.isSolidStyle());
        
        shape::GenPath(render, path, true);
        Color4 color = drawInfo.transColor(style.solidColor());
        render.setFillColor(color.red, color.green, color.blue, color.alpha);
        render.drawPath(RenderT::PathEOFill);
    }
    
    
    
    template <typename RenderT>
    static void FillPath(const Shape& shape, const Path& path, RenderT& render, const ShapeRenderInfo& drawInfo)
    {
        if (path.fillStyle() < 0)
        {
            return;
        }
        
        auto& style = shape.fillStyles[path.fillStyle()];
        if (style.isSolidStyle())
        {
            FillSolidPath(shape, path, render, drawInfo);
        }
        else if (style.isGradientStyle())
        {
            FillGradientPath(shape, path, render, drawInfo);
        }
        else if (style.isBitmapStyle())
        {
            FillBitmapPath(shape, path, render, drawInfo);
        }
    }
    
    
    
    template <typename RenderT>
    void StrokePath(const Shape& shape, const Path& path, RenderT& render)
    {
        if (path.lineStyle() >= 0)
        {
            auto& style = shape.lineStyles[path.lineStyle()];
            Color4 color = style.color;
            
            render.setLineWidth(std::max<CGFloat>(style.width, 1.0));
            render.setStrokeColor(color.red, color.green, color.blue, color.alpha);
            
            if (!style.onlyWidthAndColor)
            {
                render.setLineCap(shape::_lineCap<RenderT>(style.startCapStyle));
                render.setMiterLimit(style.miterLimitFactor);
                render.setLineJoin(shape::_lineJoint<RenderT>(style.jointStyle));
            }
            else
            {
                render.setLineCap(RenderT::LineCapRound);
                render.setLineJoin(RenderT::LineJoinBevel);
            }
            
            shape::GenPath(render, path, false);
            render.drawPath(RenderT::PathStroke);
        }
        
        for (auto& holePath : path.subPaths())
        {
            StrokePath(shape, holePath, render);
        }
    }
    

    template <typename Render>
    void renderShape(Render& render, const Shape& shape, const ShapeRenderInfo& drawInfo)
    {
        if (shape.fillStyles.empty() && shape.lineStyles.empty())
        {
            for (auto& iter : shape.paths)
            {
                shape::GenPath(render, iter, true);
                DrawPath(render, iter);
            }
        }
        else
        {
            for (auto& iter : shape.paths)
            {
                if (iter.isSameLineStyle() && isSolidFill(shape, iter))
                {
                    FillSolidStrokePath(shape, iter, render, drawInfo);
                }
                else
                {
                    FillPath(shape, iter, render, drawInfo);
                    StrokePath(shape, iter, render);
                }
            }
        }
    }
}



#endif