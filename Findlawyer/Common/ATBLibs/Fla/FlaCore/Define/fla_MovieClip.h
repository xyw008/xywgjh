//
//  fla_MovieClipBase.h
//  SDKiOSLayerTest
//
//  Created by HJC on 13-1-3.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_MOVIECLIPBASE__
#define __FLA_MOVIECLIPBASE__



#include <assert.h>
#include <vector>
#include <algorithm>
#include "fla_ColorTransform.h"
#include "fla_DefineRole.h"
#include "fla_DefineSprite.h"
#include "fla_Rect.h"
#include "fla_DefineUtils.h"
#include "fla_DefineMorphShape.h"


namespace fla
{
    class MovieClip
    {
    public:
        MovieClip();
        
        void setDefine(const DefinePtr& define);
        bool changeState(const std::string& name);
        
        void gotoFristFrame();
        
        void stepFrame();
        
        
        DefinePtr define() const    {   return _define; }
        DefinePtr state() const     {   return _state;  }
        

        void setDepth(int depth)                        {   _depth = depth;         }
        int  depth() const                              {   return _depth;          }
        
        void setTrans(const Matrix& trans)              {   _trans = trans;         }
        const Matrix& trans() const                     {   return _trans;          }
        
        int curFrame() const                            {   return _curFrame;       }
        
        Rect bounds() const;
        
        
        template <typename Graphics>
        void render(Graphics& graphics);
        
        
        template <typename Graphics>
        void renderDefine(const Define& define, Graphics& graphics, const ColorTransform& colorTrans)
        {
            if (define.type() == DefineType_MorphShape)
            {
                auto& shape = static_cast<const DefineMorphShape&>(define);
                shape.render(graphics, colorTrans, _ratio);
            }
            else
            {
                define_drawInContext(define, graphics, colorTrans);
            }
        }
        
        
    private:
        void gotoFrame(int frameIndex);
        typename std::vector<MovieClip>::iterator findSubMovieClip(int depth);
        typename std::vector<MovieClip>::iterator newSubMovieClip(std::vector<MovieClip>::iterator iter, const SpriteObject& obj);
    
    protected:
        struct MovieClipDrawInfo
        {
            Rect                sceenRect;
            Matrix              trans;
            ColorTransform      colorTrans;
        };
        
        template <typename Graphics>
        void render(Graphics& render, const MovieClipDrawInfo& drawInfo);
    
    private:
        std::vector<MovieClip>  _subMovieClips; // 子影片剪辑
        float                   _ratio;
        int                     _depth;         // 所在的层
        int                     _curFrame;      // 当前帧
        DefinePtr               _define;        // 定义
        DefinePtr               _state;         // 状态
        Matrix                  _trans;         // 位置
        ColorTransform          _colorTrans;    // 颜色转换
    };
    
    
    
    inline MovieClip::MovieClip()
    {
        _depth = 0;
        _curFrame = 0;
        _ratio = 0;
    }
    
    
     
    
    template <typename Graphics>
    void MovieClip::render(Graphics& graphics)
    {
        MovieClipDrawInfo drawInfo;
        drawInfo.sceenRect = bounds();
        render(graphics, drawInfo);
    }
    
    
    template <typename Graphics>
    void MovieClip::render(Graphics& graphics, const MovieClipDrawInfo& drawInfo)
    {
        if (!_state)
        {
            return;
        }
        
        MovieClipDrawInfo info;
        info.colorTrans = drawInfo.colorTrans * _colorTrans;
        info.sceenRect = drawInfo.sceenRect;
        info.trans = _trans * drawInfo.trans;
        
        auto type = _state->type();
        if (type == DefineType_Scene || type == DefineType_Sprite)
        {
            for (auto& sub : _subMovieClips)
            {
                sub.render(graphics, info);
            }
        }
        else
        {
            auto rt = ((MovieClip*)this)->bounds();
            rt.applyAffineTransform(info.trans);
            if (!rt.isSeparated(info.sceenRect))
            {
                graphics.saveGState();
                graphics.concatCTM(info.trans);
                ((MovieClip*)this)->renderDefine(*_state, graphics, info.colorTrans);
                graphics.restoreGState();
            }
        }
    }

}



#endif
