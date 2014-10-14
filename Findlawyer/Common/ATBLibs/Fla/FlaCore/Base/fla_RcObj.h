//
//  fla_RcObj.h
//  SceneEditor
//
//  Created by HJC on 13-1-18.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#ifndef __FLA_RCOBJ_H__
#define __FLA_RCOBJ_H__


#include "util_RefCount.h"

namespace fla
{
    struct RcObj : public util::rc_object<RcObj>
    {
        virtual ~RcObj()  {}
    };
    typedef util::rc_pointer<RcObj>  RcObjPtr;
    
    
    
    template <typename T>
    struct RcWrapObj : public RcObj
    {
    public:
        static util::rc_pointer<RcWrapObj> create()
        {
            return util::rc_pointer<RcWrapObj>(new RcWrapObj());
        }
        
        RcWrapObj(const T& val_) : val(val_) {}
        RcWrapObj()                          {}
        T   val;
    };
}



#endif
