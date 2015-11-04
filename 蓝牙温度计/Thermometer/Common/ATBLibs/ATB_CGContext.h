//
//  ATB_CGContext.h
//  ATBLibs
//
//  Created by HJC on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// 包含CGcontext， 绘图相关的函数


// 在绘制图片的时候，经常会碰到图片上下颠倒的情况，这时需要将context颠倒
inline static void ATContextVFlip(CGContextRef context, CGFloat height)
{
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1, -1);
}


// 绘画一条线
inline static void ATContextDrawLine(CGContextRef context, CGPoint p0, CGPoint p1)
{
    CGContextMoveToPoint(context, p0.x, p0.y);
    CGContextAddLineToPoint(context, p1.x, p1.y);
    CGContextStrokePath(context);
}


// 绘画一条水平线
inline static void ATContextDrawHLine(CGContextRef context, CGPoint pt, CGFloat length)
{
    CGContextMoveToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x + length, pt.y);
    CGContextStrokePath(context);
}


// 绘画一条垂直线
inline static void ATContextDrawVLine(CGContextRef context, CGPoint pt, CGFloat length)
{
    CGContextMoveToPoint(context, pt.x, pt.y);
    CGContextAddLineToPoint(context, pt.x, pt.y + length);
    CGContextStrokePath(context);
}




inline static CGContextRef ATCreateBitmapRGBA8Context(void* bytes, size_t width, size_t height)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate((void*)bytes,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    return context;
}

