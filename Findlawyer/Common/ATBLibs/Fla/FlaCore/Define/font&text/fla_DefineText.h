//
//  fla_DefineText.h
//  SceneEditor
//
//  Created by HJC on 12-12-3.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINETEXT__
#define __FLA_DEFINETEXT__


#include "fla_Define.h"
#include "fla_DefineFont.h"
#include "fla_Rect.h"
#include "fla_RenderShape.h"
#include <vector>


namespace fla
{
    class GlyphEntry
    {
    public:
        GlyphEntry() : code(0), advance(0) {}
        uint16_t    code;
        float       advance;
    };
    

    ///////////////////////////////////////////////////////////////////////////////
    
    class TextRecord
    {
    public:
        TextRecord() : offset(CGPointZero), textHeight(10)
        {
        }
        
        bool hasFont() const        {   return  ((styleFlags & 0x08) != 0); }
        bool hasColor() const       {   return  ((styleFlags & 0x04) != 0); }
        bool hasYOffset() const     {   return  ((styleFlags & 0x02) != 0); }
        bool hasXOffset() const     {   return  ((styleFlags & 0x01) != 0); }
        
        uint8_t                     styleFlags;
        CGFloat                     textHeight;
        fla::DefineFontPtr          font;
        CGPoint                     offset;
        Color4                      color;
        std::vector<GlyphEntry>     glyphEntries;
    };
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    class DefineText : public Define
    {
    public:
        DefineText()
        {
        }
        
        virtual DefineType type() const                     {   return  DefineType_Text;    }
        virtual void accept(DefineVisitor& visitor) const   {   visitor.visitText(*this);   }
        
        void setTextBounds(const Rect& rt)                {   _textBounds = rt;           }
        const Rect& textBounds() const                    {   return _textBounds;         }
        
        void setTextMatrix(const Matrix& matrix)    {   _textMatrix = matrix;       }
        const Matrix& textMatrix() const            {   return _textMatrix;         }
        
        std::vector<TextRecord>& records()                  {   return _records;            }
        const std::vector<TextRecord>& records() const      {   return _records;            }
        
        template <typename Graphics>
        void drawInContext(Graphics& context) const;
        
    private:
        Rect                    _textBounds;
        Matrix                  _textMatrix;
        std::vector<TextRecord> _records;
    };
    typedef util::rc_pointer<DefineText> DefineTextPtr;
    
    
    
    typedef struct
    {
        CGPoint         offset;
        CGFloat         scale;
        DefineFontPtr   font;
    } DrawTextInfo;
    
    
    
    template <typename Graphics>
    void drawRecord(Graphics& graphics, const TextRecord& r, DrawTextInfo& drawInfo)
    {
        if (r.hasColor())
        {
            graphics.setFillColor(r.color.red, r.color.green, r.color.blue, r.color.alpha);
        }
        
        if (r.hasFont())
        {
            CGFloat oldScale = drawInfo.scale;
            drawInfo.font = r.font;
            drawInfo.scale = 1024 / r.textHeight;
            graphics.scaleCTM(oldScale / drawInfo.scale, oldScale / drawInfo.scale);
        }
        
        
        if (r.hasXOffset() || r.hasYOffset())
        {
            CGPoint oldOffset = drawInfo.offset;
            if (r.hasXOffset())
            {
                drawInfo.offset.x = r.offset.x * drawInfo.scale;
            }
            if (r.hasYOffset())
            {
                drawInfo.offset.y = r.offset.y * drawInfo.scale;
            }
            graphics.translateCTM(drawInfo.offset.x - oldOffset.x, drawInfo.offset.y - oldOffset.y);
        }
        
        if (!drawInfo.font)
        {
            return;
        }
        
        for (auto& en : r.glyphEntries)
        {
            auto item = drawInfo.font->findItem(en.code);
            if (item)
            {
                renderShape(graphics, item->glyph, ShapeRenderInfo());
                graphics.translateCTM(en.advance * drawInfo.scale, 0);
                drawInfo.offset.x += en.advance * drawInfo.scale;
            }
        }
    }
    
    
    template <typename Graphics>
    void DefineText::drawInContext(Graphics& render) const
    {
        render.saveGState();
        render.concatCTM(_textMatrix);
        
        DrawTextInfo drawInfo;
        drawInfo.offset = CGPointZero;
        drawInfo.scale = 1.0;
        
        for (auto& r : _records)
        {
            drawRecord(render, r, drawInfo);
        }
        
        render.restoreGState();
    }
}



#endif
