//
//  fla_DefineShape.h
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINESHAPE__
#define __FLA_DEFINESHAPE__


#include "fla_Shape.h"
#include "fla_DefineImage.h"
#include <vector>
#include "fla_RenderShape.h"
#include "fla_Rect.h"


namespace fla
{
    class ColorTransform;
    class DefineShape : public Define
    {
    public:

        void setShapeBounds(const Rect& bounds)     {   _shapeBounds = bounds;  }
        const Rect shapeBounds() const              {   return _shapeBounds;    }
        
        bool addBitmapDefine(const DefineImagePtr& bitmap);
        
        std::vector<DefineImagePtr>& bitmapDefines()                 {   return _bitmapDefines;  }
        const std::vector<DefineImagePtr>& bitmapDefines() const     {   return _bitmapDefines;  }
        
        template <typename Graphics>
        void render(Graphics& graphics, const ColorTransform& colorTrans) const;
        
        virtual   DefineType type() const                     {   return DefineType_Shape;       }
        virtual   void accept(DefineVisitor& visitor) const   {   visitor.visitShape(*this);     }
        
        const Shape& shape() const  {   return _shape;   }
        Shape& shape()              {   return _shape;   }
        
    private:
        struct GetBitmap : public GetShapeBitmap
        {
            GetBitmap(const DefineShape& shape) : _shape(shape)  {}
            CGImageRef getBitmap(int bitmapId) const;
        private:
            const DefineShape& _shape;
        };
        
    private:
        std::vector<DefineImagePtr>     _bitmapDefines;
        Rect                            _shapeBounds;
        Shape                           _shape;
    };
    
    typedef util::rc_pointer<DefineShape>   DefineShapePtr;

    
    
    template <typename Graphics>
    void DefineShape::render(Graphics& render, const ColorTransform& colorTrans) const
    {
        DefineShape::GetBitmap bitmp(*this);
        ShapeRenderInfo drawInfo(bitmp, colorTrans);
        renderShape(render, shape(), drawInfo);
    }
}



#endif
