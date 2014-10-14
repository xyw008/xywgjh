//
//  ATB_SmallTools.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 包含一些不可归类，又很有的小玩意

// 数组大小
#define ArraySizeOf(array)  (sizeof(array) / sizeof(array[0]))
#define ATCast(Type, obj)   ((Type*)(obj))


static inline id _ATTestClass(Class cls, id obj)
{
    if ([obj isKindOfClass:cls])
    {
        return obj;
    }
    return nil;
}

#define ATSafelyCast(Type, obj) ((Type*)(_ATTestClass([Type class], (obj))))


/*
 释放并赋值为nil
 _ppp = [[NSString alloc] init];
 SafelyRelease(&_ppp);
 */

#if defined(__cplusplus)
#define SMALLTOOL_EXTERN extern "C"
#else
#define SMALLTOOL_EXTERN extern
#endif

SMALLTOOL_EXTERN void SafelyRelease(NSObject* p);
SMALLTOOL_EXTERN void SafelyRetain(NSObject** p, NSObject* rhs);
SMALLTOOL_EXTERN void SafelyCopy(NSObject** p, NSObject* rhs);


// 交换
inline static void SwapNSObject(NSObject** a, NSObject** b)
{
    NSObject* tmp = *a;
    *a = *b;
    *b = tmp;
}


inline static void SwapCGFloat(CGFloat* a, CGFloat* b)
{
    CGFloat tmp = *a;
    *a = *b;
    *b = tmp;
}


inline static void SwapNSInteger(NSInteger* a, NSInteger* b)
{
    NSInteger tmp = *a;
    *a = *b;
    *b = tmp;
}





