//
//  fla_DefineUtils.h
//  SceneEditor
//
//  Created by HJC on 12-11-20.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINEUTILS__
#define __FLA_DEFINEUTILS__


#include "fla_Define.h"
#include "fla_ColorTransform.h"
#include "fla_RenderDefine.h"
#include <vector>
#include <map>


namespace fla
{
    Rect    define_computeBounds(const Define& define);
    
    template <typename RenderT>
    void  define_drawInContext(const Define& define, RenderT& render)
    {
        define_drawInContext(define, render, ColorTransform());
    }
    
    
    template <typename RenderT>
    void define_drawInContext(const Define& define, RenderT& render, const ColorTransform& colorTrans)
    {
        RenderOfDefine<RenderT> renderVisitor(render, colorTrans);
        define.accept(renderVisitor);
    }
    
    
    inline DefinePtr mapFindDefine(const std::map<int, DefinePtr>& defines, int Id)
    {
        auto iter = defines.find(Id);
        if (iter != defines.end() && iter->first == Id)
        {
            return iter->second;
        }
        return DefinePtr();
    }
}


#endif
