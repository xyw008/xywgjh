//
//  fla_MovieClip.cpp
//  FlashIOSTest
//
//  Created by HJC on 13-2-6.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#include "fla_MovieClip.h"


namespace fla
{
    void MovieClip::setDefine(const DefinePtr& define)
    {
        _subMovieClips.clear();
        assert(define);
        _curFrame = 0;
        _define = define;
        _state = define;
        
        if (define->type() == DefineType_Role)
        {
            auto& role = static_cast<const DefineRole&>(*define);
            _state = role.defaultState();
        }
        gotoFrame(0);
    }
    
    
    bool MovieClip::changeState(const std::string& name)
    {
        if (_define->type() != DefineType_Role)
        {
            return false;
        }
        
        auto role = util::rc_static_cast<fla::DefineRole>(_define);
        auto state = role->findDefine(name);
        if (_state != state)
        {
            _subMovieClips.clear();
            _curFrame = 0;
            _state = state;
            gotoFrame(0);
        }
        return TRUE;
    }
    
    
    void MovieClip::gotoFristFrame()
    {
        _curFrame = 0;
        gotoFrame(_curFrame);
    }
    
    
    
    std::vector<MovieClip>::iterator MovieClip::findSubMovieClip(int depth)
    {
        return std::find_if(_subMovieClips.begin(), _subMovieClips.end(), [=](const MovieClip& clip)
                            {
                                return clip.depth() == depth;
                            });
    }
    
    
    void MovieClip::gotoFrame(int frameIndex)
    {
        auto type = _state->type();
        if (type != DefineType_Sprite &&
            type != DefineType_Scene)
        {
            return;
        }
        
        auto& sprite = static_cast<const DefineSprite&>(*_state);
        auto& frame = sprite.frames()[frameIndex];
        
        std::vector<int>  needDeleteDepths;
        if (frameIndex == 0)
        {
            _colorTrans = ColorTransform();
            _ratio = 0;
            for (auto& sub : _subMovieClips)
            {
                needDeleteDepths.push_back(sub.depth());
            }
        }
        
        for (auto& obj : frame)
        {
            auto iter = findSubMovieClip(obj.depth);
            if (obj.removeObject)
            {
                if (iter != _subMovieClips.end())
                {
                    _subMovieClips.erase(iter);
                }
                continue;
            }
            
            if (obj.hasCharacterID &&
                iter != _subMovieClips.end() &&
                obj.characterID != iter->_define->Id())
            {
                iter = newSubMovieClip(iter, obj);
            }
            
            if (iter == _subMovieClips.end())
            {
                iter = newSubMovieClip(iter, obj);
            }
            
            if (iter != _subMovieClips.end())
            {
                if (obj.hasTrans)
                {
                    iter->setTrans(obj.trans);
                }
                
                if (obj.hasColorTrans)
                {
                    iter->_colorTrans = obj.colorTrans;
                }
                
                if (obj.hasRatio)
                {
                    iter->_ratio = obj.ratio;
                }
                
                if (frameIndex == 0)
                {
                    auto findIter = std::find_if(needDeleteDepths.begin(), needDeleteDepths.end(), [&](int i)
                                                 {
                                                     return iter->depth() == i;
                                                 });
                    if (findIter != needDeleteDepths.end())
                    {
                        needDeleteDepths.erase(findIter);
                    }
                }
            }
        }
        
        for (auto depth : needDeleteDepths)
        {
            auto findIter = std::find_if(_subMovieClips.begin(), _subMovieClips.end(), [&](const MovieClip& sub)
                                         {
                                             return sub.depth() == depth;
                                         });
            if (findIter != _subMovieClips.end())
            {
                _subMovieClips.erase(findIter);
            }
        }
    }
    
    
    void MovieClip::stepFrame()
    {
        auto type = _state->type();
        if (type != DefineType_Sprite && type != DefineType_Scene)
        {
            return;
        }
        
        auto& sprite = static_cast<const fla::DefineSprite&>(*_state);
        if (sprite.frameCount() > 1)
        {
            _curFrame = (_curFrame + 1) % sprite.frameCount();
            gotoFrame(_curFrame);
        }
        
        for (auto& sub : _subMovieClips)
        {
            sub.stepFrame();
        }
    }
    
    
    Rect MovieClip::bounds() const
    {
        if (!_state)
        {
            return Rect();
        }
        
        if (_state->type() == DefineType_Sprite)
        {
            bool first = true;
            Rect bounds;
            
            for (auto& sub : _subMovieClips)
            {
                Rect objFrame = sub.bounds();
                objFrame.applyAffineTransform(sub.trans());
                if (first)
                {
                    bounds = objFrame;
                    first = false;
                }
                else
                {
                    bounds.unionRect(objFrame);
                }
            }
            return bounds;
        }
        
        return define_computeBounds(*_state);
    }
    
    
    
    std::vector<MovieClip>::iterator MovieClip::newSubMovieClip(std::vector<MovieClip>::iterator iter,
                                                                const SpriteObject& obj)
    {
        auto& sprite = static_cast<const DefineSprite&>(*_state);
        auto childDefine = sprite.findDefine(obj.characterID);
        if (!childDefine)
        {
            return _subMovieClips.end();
        }
        
        if (iter != _subMovieClips.end())
        {
            assert(iter->depth() == obj.depth);
            auto trans = iter->trans();
            auto colorTrans = iter->_colorTrans;
            
            *iter = MovieClip();
            iter->setTrans(trans);
            iter->_colorTrans = colorTrans;
        }
        else
        {
            // 插入的时候注意顺序，使得depth较小的在前
            auto i = 0;
            for (i = 0; i < _subMovieClips.size(); i++)
            {
                if (_subMovieClips[i].depth() > obj.depth)
                {
                    break;
                }
            }
            _subMovieClips.insert(_subMovieClips.begin() + i, MovieClip());
            iter = _subMovieClips.begin() + i;
        }
        iter->setDefine(childDefine);
        iter->setDepth(obj.depth);
        return iter;
    }

}