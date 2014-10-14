//
//  fla_DefineScene.h
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINESCENE__
#define __FLA_DEFINESCENE__


#include "fla_DefineSprite.h"
#include "fla_Color4.h"
#include "fla_Rect.h"
#include <string>


namespace fla
{
    class DefineScene : public DefineSprite
    {
    public:
        DefineScene() : _size(CGSizeZero)
        {
        }
        
        Rect bounds() const
        {
            return Rect(0, 0, _size.width, _size.height);
        }
        
        void  setSize(const CGSize& size)           {   _size = size;   }
        const CGSize& size() const                  {   return _size;   }
        
        void  setColor(const Color4& color)         {   _color = color; }
        const Color4& color() const                 {   return _color;  }
        
        DefineType type() const                     {   return DefineType_Scene;        }
        void accept(DefineVisitor& visitor) const   {   visitor.visitScene(*this);      }
        
    private:
        DefineScene(const DefineScene& rhs);
        CGSize      _size;
        Color4      _color;
    };
    
    typedef util::rc_pointer<DefineScene>   DefineScenePtr;
}


#endif 


