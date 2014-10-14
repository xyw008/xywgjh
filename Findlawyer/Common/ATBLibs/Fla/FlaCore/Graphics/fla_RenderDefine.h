//
//  fla_RenderDefine.h
//  SceneEditor
//
//  Created by HJC on 12-12-25.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_RENDERDEFINE__
#define __FLA_RENDERDEFINE__


#include "fla_DefineShape.h"
#include "fla_DefineImage.h"
#include "fla_DefineRole.h"
#include "fla_DefineScene.h"
#include "fla_DefineSprite.h"
#include "fla_DefineFont.h"
#include "fla_DefineText.h"
#include "fla_RenderShape.h"
#include "fla_DefineMorphShape.h"



namespace fla
{
    template <typename RenderT>
    class RenderOfDefine : public DefineVisitor
    {
    public:
        RenderOfDefine(RenderT& render, const ColorTransform& colorTrans)
        : _render(render), _colorTrans(colorTrans)
        {}
        
        virtual void visitShape(const DefineShape& shape);
        virtual void visitImage(const DefineImage& image);
        virtual void visitRole(const DefineRole& role);
        virtual void visitScene(const DefineScene& scene);
        virtual void visitSprite(const DefineSprite& sprite);
        virtual void visitFont(const DefineFont& font);
        virtual void visitText(const DefineText&);
        virtual void visitMorphShape(const DefineMorphShape&);
        
    protected:
        RenderT&        _render;
        ColorTransform  _colorTrans;
    };
    
    
    
    template <typename RenderT> 
    void RenderOfDefine<RenderT>::visitText(const DefineText& text)
    {
        text.drawInContext(_render);
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitShape(const DefineShape& shape)
    {
        shape.render(_render, _colorTrans);
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitMorphShape(const DefineMorphShape& shape)
    {
        shape.render(_render, _colorTrans, 0);
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitFont(const DefineFont& font)
    {
        auto item = font.defaultItem();
        if (item)
        {
            auto& shape = item->glyph;
            _render.setFillColor(0.0, 0, 0, 1);
            renderShape(_render, shape, ShapeRenderInfo());
        }
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitImage(const DefineImage& image)
    {
        CGImageRef imgRef = image.image();
        if (imgRef)
        {
            CGRect bounds;
            bounds.origin.x = 0;
            bounds.origin.y = 0;
            bounds.size.width = CGImageGetWidth(imgRef);
            bounds.size.height = CGImageGetHeight(imgRef);
            
            _render.translateCTM(0, bounds.size.height);
            _render.scaleCTM(1, -1);
            _render.drawImage(bounds, imgRef);
        }
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitRole(const DefineRole& role)
    {
        role.defaultState()->accept(*this);
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitScene(const DefineScene& scene)
    {
        visitSprite(scene);
    }
    
    
    template <typename RenderT>
    void RenderOfDefine<RenderT>::visitSprite(const DefineSprite& sprite)
    {
        SpriteFrame frame = sprite.gotoFrame(0);
        for (auto& obj : frame)
        {
            _render.saveGState();
            auto saveColor = _colorTrans;
            
            if (obj.hasTrans)
            {
                _render.concatCTM(obj.trans);
            }
            
            if (obj.hasColorTrans)
            {
                _colorTrans = _colorTrans * obj.colorTrans;
            }
            
            if (obj.hasCharacterID)
            {
                auto define = sprite.findDefine(obj.characterID);
                if (define)
                {
                    define->accept(*this);
                }
            }
            
            _colorTrans = saveColor;
            _render.restoreGState();
        }
    }
}


#endif
