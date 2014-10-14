//
//  fla_transToImage.cpp
//  FlashConvertor
//
//  Created by HJC on 13-2-22.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "fla_transToImage.h"
#include "fla_DefineUtils.h"
#include "fla_ColorTransform.h"
#include "fla_QuartzGraphics.h"
#include "cocoa_CG.h"


namespace fla
{
    class NoImageRender : public RenderOfDefine<QuartzGraphics>
    {
    public:
        NoImageRender(QuartzGraphics& render, const ColorTransform& colorTrans)
        : RenderOfDefine(render, colorTrans)   {}
        
        virtual void visitImage(const DefineImage& image)   {}
        virtual void visitShape(const DefineShape& shape)
        {
            ShapeRenderInfo drawInfo(_colorTrans);
            renderShape(_render, shape.shape(), drawInfo);
        }
    };
    
    
    
    cocoa::CFObjHolder<CGImageRef> define_transToImage(const Define& define, const TransToImageInfo& info)
    {
        Rect rt = define_computeBounds(define);
        rt.x = floorf(rt.x - 2);
        rt.y = floorf(rt.y - 2);
        rt.width = ceilf(rt.width + 4);
        rt.height = ceilf(rt.height + 4);
        
        // 调成偶数
        if ((int)rt.width % 2 == 1)
        {
            rt.width += 1;
        }
        
        if ((int)rt.height % 2 == 1)
        {
            rt.height += 1;
        }
        
        rt.width *= info.scale;
        rt.height *= info.scale;
        
        auto contextHolder = cocoa::CG::newBitmapContext(rt.asRect().size);
        QuartzGraphics render(contextHolder.get());
        
        if (info.hasBackground && define.type() == DefineType_Scene)
        {
            auto& scene = static_cast<const DefineScene&>(define);
            auto& color = scene.color();
            if (color.alpha != 0)
            {
                CGContextSetRGBFillColor(render.context(), color.red, color.green, color.blue, color.alpha);
                CGContextFillRect(render.context(), rt.asRect());
            }
        }
        
        CGContextTranslateCTM(render.context(), 0, rt.height);
        CGContextScaleCTM(render.context(), info.scale, -info.scale);
        CGContextTranslateCTM(render.context(), -rt.x, -rt.y);
        
        if (info.hasImage)
        {
            RenderOfDefine<QuartzGraphics> renderVisitor(render, ColorTransform());
            define.accept(renderVisitor);
        }
        else
        {
            NoImageRender renderVisitor(render, ColorTransform());
            define.accept(renderVisitor);
        }
        
        CGImageRef imgRef = CGBitmapContextCreateImage(render.context());
        
        return cocoa::CFObjHolder<CGImageRef>(imgRef);
    }
    
    
    
    cocoa::CFObjHolder<CGImageRef> define_transToImage(const Define& define, float scale)
    {
        TransToImageInfo info;
        info.scale = scale;
        return define_transToImage(define, info);
    }
}



