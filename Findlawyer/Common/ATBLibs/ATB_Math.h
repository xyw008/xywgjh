//
//  ATB_Math.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// 弧度和角度相互转换
inline static CGFloat RadianFromDegree(CGFloat degree)
{
    return (M_PI * (degree / 180.0f));
}


inline static CGFloat DegreeFromRadian(CGFloat radian)
{
    return (180.0f * (radian / M_PI));
}


// 比较两个浮点数是否相等
inline static BOOL CGFloatEqualToFloat(CGFloat val0, CGFloat val1)
{
	CGFloat dist = val0 - val1;
	return fabsf(dist) < FLT_EPSILON;
}


// 判断浮点数是否为0
inline static BOOL CGFloatIsZero(CGFloat val)
{
	return CGFloatEqualToFloat(val, 0.0f);
}


// 生成 [min, max] 之间的随机数, 注意不包括max
inline static NSInteger ATRandInt(NSInteger min, NSInteger max)
{
    NSInteger len = max - min;
    return (rand() % len) + min;
}


// 生成 [min, max) 之间的随机数，另外保证每个随机数字都不相同
extern BOOL ATDiffRandInts(NSInteger* result, NSInteger count, NSInteger min, NSInteger max);

