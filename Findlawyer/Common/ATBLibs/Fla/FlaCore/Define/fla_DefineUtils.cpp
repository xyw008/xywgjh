//
//  fla_DefineUtils.cpp
//  SceneEditor
//
//  Created by HJC on 12-11-20.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_DefineUtils.h"
#include "fla_DefineShape.h"
#include "fla_DefineImage.h"
#include "fla_DefineRole.h"
#include "fla_DefineScene.h"
#include "fla_DefineSprite.h"
#include "fla_DefineFont.h"
#include "fla_DefineText.h"
#include "fla_RenderShape.h"
#include "fla_RenderDefine.h"
#include "cocoa_CG.h"


namespace fla
{
    class BoundsOfDefine : public DefineVisitor
    {
    public:
        void visitImage(const DefineImage&);
        void visitShape(const DefineShape&);
        void visitSprite(const DefineSprite&);
        void visitScene(const DefineScene&);
        void visitRole(const DefineRole&);
        void visitFont(const DefineFont&);
        void visitText(const DefineText&);
        void visitMorphShape(const DefineMorphShape&);
        
        const Rect& bounds() const    {   return _bounds; }
        
    private:
        Rect  _bounds;
    };
    
    
    void BoundsOfDefine::visitImage(const DefineImage& image)
    {
        _bounds.x = 0;
        _bounds.y = 0;
        _bounds.width = CGImageGetWidth(image.image());
        _bounds.height = CGImageGetHeight(image.image());
    }
    
    
    void BoundsOfDefine::visitShape(const DefineShape& shape)
    {
        _bounds = shape.shapeBounds();
    }
    
    
    void BoundsOfDefine::visitMorphShape(const DefineMorphShape& shape)
    {
        _bounds = shape.bounds().start;
        _bounds.unionRect(shape.bounds().end);
    }
    
    
    void BoundsOfDefine::visitRole(const DefineRole& role)
    {
        role.defaultState()->accept(*this);
    }
    
    
    void BoundsOfDefine::visitFont(const DefineFont& font)
    {
        auto item = font.defaultItem();
        if (!item)
        {
            _bounds = Rect();
        }
        else
        {
            if (font.hasLayout())
            {
                _bounds = item->bounds;
            }
            else
            {
                _bounds = item->glyph.computeEdgeBounds();
            }
        }
    }
    
    
    void BoundsOfDefine::visitScene(const DefineScene& scene)
    {
        _bounds = Rect();
        _bounds.width = scene.size().width;
        _bounds.height = scene.size().height;
    }
    
    
    void BoundsOfDefine::visitText(const DefineText& text)
    {
        _bounds = text.textBounds();
    }
    
    
    void BoundsOfDefine::visitSprite(const DefineSprite& sprite)
    {
        SpriteFrame frame = sprite.gotoFrame(0);
        Rect bounds;
        bool first = true;
        
        for (auto& obj : frame)
        {
            _bounds = Rect();
            if (obj.hasCharacterID)
            {
                auto define = sprite.findDefine(obj.characterID);
                if (define)
                {
                    define->accept(*this);
                }
            }
            
            if (obj.hasTrans)
            {
                _bounds.applyAffineTransform(obj.trans);
            }
            
            if (first)
            {
                bounds = _bounds;
            }
            else
            {
                bounds.unionRect(_bounds);
            }
            first = false;
        }
        _bounds = bounds;
    }
    

    ////////////////////////////////////////////////////////////////////////////////
    Rect define_computeBounds(const Define& define)
    {
        BoundsOfDefine bounds;
        define.accept(bounds);
        return bounds.bounds();
    }
}



