//
//  fla_DefineFont.h
//  SceneEditor
//
//  Created by HJC on 12-12-3.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINEFONT__
#define __FLA_DEFINEFONT__


#include "fla_Define.h"
#include "fla_Shape.h"
#include <string>
#include <map>


namespace fla
{
    typedef enum
    {
        LanguageCode_Latin              = 1,
        LanguageCode_Japanese           = 2,
        LanguageCode_Korean             = 3,
        LanguageCode_SimplifiedChinese  = 4,
        LanguageCode_TraditionalChinese = 5,
    } LanguageCode;
    
    
    
    class KerningRecord
    {
    public:
        KerningRecord() : code1(0), code2(0), adjustment(0) {}
        uint16_t    code1;
        uint16_t    code2;
        float       adjustment;
    };
    
    
    
    class FontItem
    {
    public:
        FontItem()
        {
            code = 0;
            advance = 0;
        }
        uint16_t    code;
        Shape       glyph;
        
        // 字体有hasLayout才应该保存
        Rect        bounds;
        float       advance;
    };
    
    
    
    class DefineFont : public Define
    {
    public:
        float       ascent;
        float       descent;
        float       leading;
        uint8_t     fontFlags;
        uint8_t     languageCode;
        
        
        DefineFont()
        {
            _defaultCode = 0;
        }
        
        const FontItem* findItem(uint16_t code) const;
        FontItem* findItem(uint16_t code);
        
        void      addItem(const FontItem& item);
        
        virtual DefineType type() const     {   return DefineType_Font; }
        virtual void accept(DefineVisitor& visitor) const {   visitor.visitFont(*this);   }
        
        const std::map<uint16_t, FontItem>&  items() const
        {
            return _items;
        }
        
        const FontItem* defaultItem() const         {   return findItem(_defaultCode);  }
        
        uint16_t defaultCode() const                {   return _defaultCode;            }
        void     setDefaultCode(uint16_t code)      {   _defaultCode = code;            }
        

        bool hasLayout() const      {   return ((fontFlags & 0x80) != 0);  }
        bool shiftJIS() const       {   return ((fontFlags & 0x40) != 0);  }
        bool smallText() const      {   return ((fontFlags & 0x20) != 0);  }
        bool ansi() const           {   return ((fontFlags & 0x10) != 0);  }
        bool wideOffsets() const    {   return ((fontFlags & 0x08) != 0);  }
        bool wideCodes() const      {   return ((fontFlags & 0x04) != 0);  }
        bool italic() const         {   return ((fontFlags & 0x02) != 0);  }
        bool bold() const           {   return ((fontFlags & 0x01) != 0);  }
        
        const std::vector<KerningRecord>& kerningTables() const     {   return _kerningTables;  }
        void addKerningRecord(const KerningRecord& record)
        {
            _kerningTables.push_back(record);
        }
        
    private:
        uint16_t                        _defaultCode;
        std::map<uint16_t, FontItem>    _items;
        std::vector<KerningRecord>      _kerningTables;
    };
    
    typedef util::rc_pointer<DefineFont>    DefineFontPtr;
    
    
    inline void DefineFont::addItem(const FontItem& item)
    {
        if (_items.empty())
        {
            _defaultCode = item.code;
        }
        _items[item.code] = item;
    }
}



#endif
