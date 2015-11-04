//
//  PushTreeArrowView.m
//  o2o
//
//  Created by swift on 14-7-31.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PushTreeArrowView.h"

@implementation PushTreeArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *_lineColor = [UIColor lightGrayColor];
    CGFloat colorRGBAComponents[4];
    [_lineColor getRGBAComponents:colorRGBAComponents];
    
    float _lineWidth = 1;
    CGPoint lineStartPoint = CGPointMake(ArrowSizeWidth, 0.0);
    CGPoint lineEndPoint = CGPointMake(ArrowSizeWidth, self.boundsHeight);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0, 0);
    
    CGContextSetRGBStrokeColor(context, colorRGBAComponents[0], colorRGBAComponents[1], colorRGBAComponents[2], colorRGBAComponents[3]);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0), 2.5, [UIColor blackColor].CGColor);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);
    
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x - ArrowSizeWidth + 1.5, _arrowCenterY);
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY + (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
    
    CGContextStrokePath(context);
    
    // 画三角形
    CGContextSetShadowWithColor(context, CGSizeZero, 3, [UIColor clearColor].CGColor);
    
    [[UIColor whiteColor] setFill];                 // 设置填充色
    [[UIColor clearColor] setStroke];               // 设置边框颜色
    
    // 利用path进行绘制三角形
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x - ArrowSizeWidth + 1.5, _arrowCenterY);
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY + (ArrowSizeHeight / 2));
    CGContextMoveToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextClosePath(context);                    // 路径结束标志，不写默认封闭
    
    CGContextDrawPath(context, kCGPathFillStroke);  // 绘制路径path
}

@end
