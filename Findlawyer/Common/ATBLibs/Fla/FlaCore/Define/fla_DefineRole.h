//
//  fla_DefineRole.h
//  SceneEditor
//
//  Created by HJC on 12-11-12.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#ifndef __FLA_DEFINEROLE__
#define __FLA_DEFINEROLE__


#include "fla_Define.h"
#include <vector>
#include <assert.h>



namespace fla
{
    /*
     角色定义，一个角色有多个状态，另外有个默认的状态
     比如一个骑士，可能有 攻击，行走，跑步 等状态

     角色里面的状态，假如Id == Define::roleStateId, 表示这个状态从属于角色，
     */
    class DefineRole : public Define
    {
    public:
        DefineRole() : _defaultIndex(0) {}
        
        virtual DefineType type() const                     {   return DefineType_Role;     }
        virtual void accept(DefineVisitor& visitor) const   {   visitor.visitRole(*this);   }
        
        void addState(const std::string& name, const DefinePtr& define);
        void setDefualtState(const std::string& name);
        
        DefinePtr findDefine(const std::string& name) const;
        
        DefinePtr defaultState() const
        {
            assert(_defaultIndex < _states.size());
            return _states[_defaultIndex].define();
        }
        
        const std::string& defaultName() const
        {
            return _states[_defaultIndex].name();
        }
        
        std::string stateName(const DefinePtr& state) const;
        
        // State的名字和Define的名字可以不同
        struct State
        {
        public:
            State(const std::string& n, const DefinePtr& s) : _name(n), _define(s)  {}
            const std::string& name() const     {   return _name;   }
            const DefinePtr& define() const     {   return _define; }
            
        private:
            std::string         _name;
            DefinePtr           _define;
        };
        const std::vector<State>& states() const    {   return _states; }
        
    private:
        std::vector<State>  _states;
        int                 _defaultIndex;
    };
    typedef util::rc_pointer<DefineRole>    DefineRolePtr;
    
    
    inline void DefineRole::addState(const std::string& name, const DefinePtr& sprite)
    {
        _states.push_back(State(name, sprite));
    }
    
    
    inline DefinePtr DefineRole::findDefine(const std::string& name) const
    {
        for (auto& state : _states)
        {
            if (state.name() == name)
            {
                return state.define();
            }
        }
        return DefinePtr();
    }
    
    
    inline void DefineRole::setDefualtState(const std::string& name)
    {
        for (auto i = 0; i < _states.size(); i++)
        {
            if (_states[i].name() == name)
            {
                _defaultIndex = i;
                break;
            }
        }
    }
    
    
    inline std::string DefineRole::stateName(const DefinePtr& define) const
    {
        for (auto& state : _states)
        {
            if (state.define() == define)
            {
                return state.name();
            }
        }
        return "";
    }
}


#endif 
