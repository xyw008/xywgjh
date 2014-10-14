//
//  ATB_Geometry.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 关于CGPoint, CGRect的一些小函数

// 得到两点之间的距离
inline static CGFloat CGPointDistanceTo(CGPoint p0, CGPoint p1)
{
    CGFloat offsetX = p0.x - p1.x;
    CGFloat offsetY = p0.y - p1.y;
    return sqrtf(offsetX * offsetX + offsetY * offsetY);
}


// 两点相减
inline static CGPoint CGPointMinusPoint(CGPoint pt0, CGPoint pt1)
{
    return CGPointMake(pt0.x - pt1.x, pt0.y - pt1.y);
}


// 两点相加
inline static CGPoint CGPointAddPoint(CGPoint pt0, CGPoint pt1)
{
    return CGPointMake(pt0.x + pt1.x, pt0.y + pt1.y);
}


inline static CGPoint CGPointOffset(CGPoint pt, CGFloat x, CGFloat y)
{
    return CGPointMake(pt.x + x, pt.y + y);
}


// 点乘
inline static CGFloat CGPointDot(CGPoint pt0, CGPoint pt1)
{
    return pt0.x * pt1.x + pt0.y * pt1.y;
}


inline static CGPoint CGPointAddPointWeight(CGPoint pt0, CGFloat w0, CGPoint pt1, CGFloat w1)
{
    return CGPointMake(pt0.x * w0 + pt1.x * w1, pt0.y * w0 + pt1.y * w1);
}


// 两点之间的插值
inline static CGPoint CGPointInterpolation(CGPoint pt0, CGPoint pt1, CGFloat factor)
{
    return CGPointMake(pt0.x * (1.0f - factor) + pt1.x * factor,
                       pt0.y * (1.0f - factor) + pt1.y * factor);
}


///////////////////////////////////////////////////////////////
// 得到矩形的中心点
inline static CGPoint CGRectGetMiddle(CGRect rect)
{
    CGFloat xpos = rect.origin.x + rect.size.width * 0.5f;
    CGFloat ypos = rect.origin.y + rect.size.height * 0.5f;
    return CGPointMake(xpos, ypos);
}


// 设置矩形的中心点
inline static void CGRectSetMiddle(CGRect* rect, CGPoint middle)
{
    CGFloat xpos = middle.x - rect->size.width * 0.5;
    CGFloat ypos = middle.y - rect->size.height * 0.5;
    rect->origin.x = xpos;
    rect->origin.y = ypos;
}



// 矩形左半边
inline static CGRect CGRectHalfLeftRect(CGRect rect)
{
    CGFloat halfWidth = CGRectGetWidth(rect) * 0.5;
    CGRect leftRect = rect;
    leftRect.size.width = halfWidth;
    return leftRect;
}


// 矩形右半边
inline static CGRect CGRectHalfRightRect(CGRect rect)
{
    CGFloat halfWidth = CGRectGetWidth(rect) * 0.5;
    CGRect rightRect = rect;
    rightRect.size.width = halfWidth;
    rightRect.origin.x += halfWidth;
    return rightRect;
}



inline static CGSize CGSizeAspectFit(CGSize originSize, CGSize size)
{
    CGFloat xScale = size.width / originSize.width;
    CGFloat yScale = size.height / originSize.height;
    if (xScale > yScale)
    {
        size.width = ceilf(originSize.width * yScale);
    }
    else
    {
        size.height = ceilf(originSize.height * xScale);
    }
    return size;
}




// 将点加到矩形中，并相应的扩大包围框
inline static void CGRectBoundsAddPoint(CGRect* rect, CGPoint pt, BOOL isFirst)
{
    if (isFirst)
    {
        rect->origin = pt;
        rect->size = CGSizeZero;
    }
    else
    {
        CGPoint maxPt = rect->origin;
        maxPt.x += rect->size.width;
        maxPt.y += rect->size.height;
        
        CGPoint minPt = rect->origin;
        minPt.x = MIN(minPt.x, pt.x);
        minPt.y = MIN(minPt.y, pt.y);
        
        maxPt.x = MAX(maxPt.x, pt.x);
        maxPt.y = MAX(maxPt.y, pt.y);
        
        rect->origin = minPt;
        rect->size.width = maxPt.x - minPt.x;
        rect->size.height = maxPt.y - minPt.y;
    }
}

// 矩形相应的减小宽度和高度
inline static CGRect CGRectDecreaseSize(CGRect rect, CGFloat width, CGFloat height)
{
    return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - width, rect.size.height - height);
}

