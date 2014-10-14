//
//  fla_DefineFont.cpp
//  SceneEditor
//
//  Created by HJC on 12-12-3.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_DefineFont.h"


namespace fla
{
    const FontItem* DefineFont::findItem(uint16_t code) const
    {
        return const_cast<DefineFont*>(this)->findItem(code);
    }
    
    
    FontItem* DefineFont::findItem(uint16_t code)
    {
        auto iter = _items.find(code);
        if (iter != _items.end() && iter->first == code)
        {
            return &iter->second;
        }
        return nullptr;
    }
}
