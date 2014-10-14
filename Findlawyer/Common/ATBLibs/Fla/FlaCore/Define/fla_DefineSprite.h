//
//  fla_DefineSprite.h
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINESPRITE__
#define __FLA_DEFINESPRITE__


#include <vector>
#include <map>
#include "fla_Define.h"
#include "fla_ColorTransform.h"
#include "fla_Matrix.h"


namespace fla
{
    class SpriteObject
    {
    public:
        SpriteObject()
        {
            depth = 0;
            characterID = 0;
            ratio = 0;
            clipDepth = 0;
            removeObject = false;
            hasTrans = false;
            hasCharacterID = false;
            hasColorTrans = false;
            hasRatio = false;
            hasClipDepth = false;
        }
        uint16_t            depth;
        uint16_t            characterID;
        uint16_t            clipDepth;
        Matrix              trans;
        ColorTransform      colorTrans;
        float               ratio;
        
        uint8_t             removeObject :1;
        uint8_t             hasTrans :1;
        uint8_t             hasColorTrans :1;
        uint8_t             hasCharacterID :1;
        uint8_t             hasRatio :1;
        uint8_t             hasClipDepth :1;
    };
    
    
    
    class SpriteFrame : public std::vector<SpriteObject>
    {
    public:
        const_iterator findObjWithDepth(int depth) const
        {
            return const_cast<SpriteFrame*>(this)->findObjWithDepth(depth);
        }
        
        iterator findObjWithDepth(int depth);
    };
    
    
    
    class DefineSprite;
    typedef util::rc_pointer<DefineSprite>  DefineSpritePtr;
    

    class DefineSprite : public Define
    {
    public:
        DefinePtr findDefine(int Id) const;
        
        void setDefine(int Id, const DefinePtr& define);
        
        int frameCount() const              {   return (int)_frames.size();     }
        
        virtual DefineType type() const                     {   return DefineType_Sprite;       }
        virtual void accept(DefineVisitor& visitor) const  {   visitor.visitSprite(*this);     }
        
        std::map<int, DefinePtr>& defines()             {   return _defines;    }
        const std::map<int, DefinePtr>& defines() const {   return _defines;    }
        
        std::vector<SpriteFrame>& frames()              {   return _frames;     }
        const std::vector<SpriteFrame>& frames() const  {   return _frames;     }
        
        // 将一个动画序列进行拆分，从第offset开始，总共有frameCount这样多帧
        DefineSpritePtr split(int offset, int frameCount) const;
        
        SpriteFrame gotoFrame(int index) const;
        void        gotoFrame(int index, SpriteFrame& frame) const;
        
    private:
        std::map<int, DefinePtr>    _defines;
        std::vector<SpriteFrame>    _frames;
    };
    
    

    inline DefinePtr DefineSprite::findDefine(int Id) const
    {
        auto iter = _defines.find(Id);
        if (iter != _defines.end() && iter->first == Id)
        {
            return iter->second;
        }
        return DefinePtr();
    }
    
    
    inline void DefineSprite::setDefine(int Id, const DefinePtr& define)
    {
        _defines[Id] = define;
    }
};



#endif
