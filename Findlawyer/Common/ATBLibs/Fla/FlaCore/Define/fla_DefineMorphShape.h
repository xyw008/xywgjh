//
//  fla_DefineMorphShape.h
//  SceneEditor
//
//  Created by HJC on 13-1-18.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINEMORPHSHAPE__
#define __FLA_DEFINEMORPHSHAPE__


#include "fla_Define.h"
#include "fla_Rect.h"
#include "fla_Holder.h"
#include "fla_Shape.h"
#include "fla_ColorTransform.h"
#include "fla_ShapeGraphicsUtils.h"
#include "fla_RenderShape.h"



namespace fla
{
    class DefineMorphShape : public Define
    {
    public:
        virtual DefineType type() const                     {   return DefineType_MorphShape;   }
        virtual void accept(DefineVisitor& visitor) const   {   visitor.visitMorphShape(*this); }
        
        typedef Holder<Rect, 2>     RectT;
        
        const RectT& bounds() const         {   return _bounds;     }
        void setBounds(const RectT& bounds) {   _bounds = bounds;   }
        
        MorphShape& shape()             {   return _shape;  }
        const MorphShape& shape() const {   return _shape;  }
        
        template <typename Graphics>
        void render(Graphics& graphics,
                    const ColorTransform& colorTrans,
                    float ratio
                    ) const;
        
    private:
        template <typename Graphics>
        void fillPath(const MorphPath& path, Graphics& graphics, const ColorTransform& colorTrans, scalar ratio) const;
        
        template <typename Graphics>
        void strokePath(const MorphPath& path, Graphics& graphics, const ColorTransform& colorTrans, scalar ratio) const;
        
    private:
        RectT           _bounds;
        MorphShape      _shape;
    };
    
    typedef util::rc_pointer<DefineMorphShape>  DefineMorphShapePtr;
    
    
    
    template <typename Graphics>
    void DefineMorphShape::fillPath(const MorphPath& path, Graphics& graphics, const ColorTransform& colorTrans, scalar ratio) const
    {
        if (!path.hasFillStyle())
        {
            return;
        }
        
        auto& style = _shape.fillStyles[path.fillStyle()];
        if (style.isSolidStyle())
        {
            shape::GenMorphPath(graphics, path, ratio, true);
            auto color = morph::lerp(style.solidColor().start, style.solidColor().end, ratio);
            color = colorTrans * color;
            graphics.setFillColor(color.red, color.green, color.blue, color.alpha);
            graphics.drawPath(Graphics::PathEOFill);
        }
        
        else if (style.isGradientStyle())
        {
            shape::GenMorphPath(graphics, path, ratio, true);
            
            auto& ptr = style.gradient();
            auto matrix = morph::lerp(ptr.matrix().start, ptr.matrix().end, ratio);
            
            auto recSize = ptr.records().size();
            std::vector<Color4> colors(recSize);
            std::vector<CGFloat> locations(recSize);
            
            for (auto i = 0; i < recSize; i++)
            {
                colors[i] = morph::lerp(ptr.records()[i].color.start, ptr.records()[i].color.end, ratio);
                colors[i] = colors[i];
                locations[i] = morph::lerp(ptr.records()[i].location.start, ptr.records()[i].location.end, ratio);
            }
            
            graphics.drawGradient(colors,
                                  locations,
                                  style.fillType() == FillType::LinearGradient,
                                  ptr.radius(),
                                  Matrix(matrix));
        }
    }
    
    
    template <typename Graphics>
    void DefineMorphShape::strokePath(const MorphPath& path, Graphics& graphics, const ColorTransform& colorTrans, scalar ratio) const
    {
        if (path.hasLineStyle())
        {
            auto& style = _shape.lineStyles[path.lineStyle()];
            auto color = morph::lerp(style.color.start, style.color.end, ratio);
            color = colorTrans * color;
            
            auto lineWidth = morph::lerp(style.width.start, style.width.end, ratio);
            
            graphics.setLineWidth(std::max<CGFloat>(lineWidth, 1.0));
            graphics.setStrokeColor(color.red, color.green, color.blue, color.alpha);
            
            if (!style.onlyWidthAndColor)
            {
                graphics.setLineCap(shape::_lineCap<Graphics>(style.startCapStyle));
                graphics.setMiterLimit(style.miterLimitFactor);
                graphics.setLineJoin(shape::_lineJoint<Graphics>(style.jointStyle));
            }
            else
            {
                graphics.setLineCap(Graphics::LineCapRound);
                graphics.setLineJoin(Graphics::LineJoinBevel);
            }
            
            shape::GenMorphPath(graphics, path, ratio, false);
            graphics.drawPath(Graphics::PathStroke);
        }
        
        for (auto& holePath : path.subPaths())
        {
            strokePath(holePath, graphics, colorTrans, ratio);
        }
    }
    
    
    template <typename Graphics>
    void DefineMorphShape::render(Graphics& graphics, const ColorTransform& colorTrans, float ratio) const
    {
        for (auto& path : _shape.paths)
        {
            fillPath(path, graphics, colorTrans, ratio);
            strokePath(path, graphics, colorTrans, ratio);
        }
    }
}




#endif
