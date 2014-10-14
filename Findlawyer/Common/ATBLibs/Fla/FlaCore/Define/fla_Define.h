//
//  fla_Define.h
//  SceneEditor
//
//  Created by HJC on 12-11-1.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINE__
#define __FLA_DEFINE__


#include "util_RefCount.h"
#include <string>


namespace fla
{
    typedef enum
    {
        DefineType_Null         = 0,    // 空定义
        DefineType_Image        = 1,    // 图片
        DefineType_Shape        = 2,    // 形状
        DefineType_MorphShape   = 3,    // 形变
        DefineType_Sprite       = 4,    // 动画
        DefineType_Scene        = 5,    // 场景
        DefineType_Role         = 6,    // 角色，可以有多种状态
        DefineType_Font         = 7,    // 字体
        DefineType_Text         = 8,    // 文字
    } DefineType;
    

    class DefineImage;
    class DefineShape;
    class DefineSprite;
    class DefineScene;
    class DefineRole;
    class DefineFont;
    class DefineText;
    class DefineMorphShape;
    
    
    class DefineVisitor
    {
    public:
        virtual void visitImage(const DefineImage&)     = 0;
        virtual void visitShape(const DefineShape&)     = 0;
        virtual void visitSprite(const DefineSprite&)   = 0;
        virtual void visitScene(const DefineScene&)     = 0;
        virtual void visitRole(const DefineRole&)       = 0;
        virtual void visitFont(const DefineFont&)       = 0;
        virtual void visitText(const DefineText&)       = 0;
        virtual void visitMorphShape(const DefineMorphShape&) = 0;
    };

    
    /* 
     每个定义，都会有一个Id, 这个Id是唯一的, 程序可以由Id找到定义
     有两个 Id，比较特殊
     
     Id = 0,    表示是个场景。场景会有名字，当有多个场景的时候，需要用名字来查找
     Id = -1,   表示这个定义为某个角色的状态。一定要通过角色来访问。
     */
    class Define : public util::rc_object<Define>
    {
    public:
        static const int roleStateId = -1;  // 当为-1时候，是某个角色当中的状态值
        static const int sceneId = 0;       // 场景的Id, 一定为0
        
        virtual ~Define()       {}
        Define() : _Id(0)  {}
    
        void    setId(int Id)                           {     _Id = Id;     }
        int     Id() const                              {   return _Id;     }
        
        void    setName(const std::string& name)        {   _name = name;   }
        const   std::string& name() const               {   return _name;   }
        
        virtual DefineType type() const = 0;
        virtual void accept(DefineVisitor& visitor) const = 0;
        
    private:
        // 禁止复制
        Define(const Define& rhs);
        Define& operator = (const Define& rhs);
        
    private:
        int         _Id;
        std::string _name;
    };
    typedef util::rc_pointer<Define>   DefinePtr;
}



#endif
