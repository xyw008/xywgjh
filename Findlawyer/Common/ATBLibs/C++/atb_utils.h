//
//  CppUtils.h
//
//  Created by HJC on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.

#ifndef _CPPUTILS_H_
#define _CPPUTILS_H_


#include <memory.h>
#include <stdio.h>


namespace atb 
{
    // 线性插值
    inline static float lerp(float t, float val0, float val1)
    {
        return val0 * (1.0f - t) + val1 * t;
    }
    
    
    template <typename T>
    inline static void memzero(T& val)
    {
        memset(&val, 0, sizeof(val));
    }
    
    
    template <typename T>
    inline bool fread(FILE* file, T* type)
    {
        return (::fread(type, sizeof(T), 1, file) != 0);
    }
    
    
    inline bool fread(FILE* file, void* bytes, size_t len)
    {
        return (::fread(bytes, len, 1, file) != 0);
    }
    
    
    template <typename T>
    inline bool fwrite(FILE* file, T* type)
    {
        return (::fwrite(type, sizeof(T), 1, file) != 0);
    }
    
    inline bool fwrite(FILE* file, const void* bytes, size_t len)
    {
        return (::fwrite(bytes, len, 1, file) != 0);
    }
};



#endif
