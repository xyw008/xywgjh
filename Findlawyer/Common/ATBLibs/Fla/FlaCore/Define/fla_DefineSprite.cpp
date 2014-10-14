///
//  fla_DefineSprite.cpp
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#include "fla_DefineSprite.h"


namespace fla
{
    SpriteFrame::iterator SpriteFrame::findObjWithDepth(int depth)
    {
        for (auto iter = begin(); iter != end(); ++iter)
        {
            if (iter->depth == depth)
            {
                return iter;
            }
        }
        return end();
    }
    
    
    
    DefineSpritePtr DefineSprite::split(int offset, int frameCount) const
    {
        DefineSpritePtr sprite(new DefineSprite());
        for (auto i = 0; i < frameCount; i++)
        {
            if (i == 0)
            {
                sprite->frames().push_back(gotoFrame(offset));
            }
            else
            {
                sprite->frames().push_back(_frames[i + offset]);
            }
            
            auto& frame = sprite->frames()[i];
            for (auto& obj : frame)
            {
                if (obj.hasCharacterID)
                {
                    auto define = findDefine(obj.characterID);
                    if (define)
                    {
                        sprite->setDefine(obj.characterID, define);
                    }
                }
            }
        }
        return sprite;
    }
    
    
    
    
    void DefineSprite::gotoFrame(int index, SpriteFrame& frame) const
    {
        for (auto& obj : _frames[index])
        {
            auto iter = frame.findObjWithDepth(obj.depth);
            if (obj.removeObject)
            {
                frame.erase(iter);
            }
            else
            {
                if (obj.hasCharacterID &&
                    iter != frame.end() &&
                    obj.characterID != iter->characterID)
                {
                    iter->characterID = obj.characterID;
                    iter->hasTrans = true;
                }
                
                if (iter == frame.end())
                {
                    frame.push_back(obj);
                    iter = frame.begin() + (frame.size() - 1);
                }
                
                if (obj.hasTrans)
                {
                    iter->hasTrans = obj.hasTrans;
                    iter->trans = obj.trans;
                }
                
                if (obj.hasColorTrans)
                {
                    iter->hasColorTrans = obj.hasColorTrans;
                    iter->colorTrans = obj.colorTrans;
                }
            }
        }

    }
    
    
    SpriteFrame DefineSprite::gotoFrame(int index) const
    {
        SpriteFrame frame;
        for (int i = 0; i <= index; i++)
        {
            gotoFrame(i, frame);
        }
        return frame;
    }
}

