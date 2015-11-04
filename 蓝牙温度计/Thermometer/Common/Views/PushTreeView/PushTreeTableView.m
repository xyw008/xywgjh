//
//  PushTreeTableView.m
//  InfiniteTreeView
//
//  Created by 龚 俊慧 on 14-7-24.
//  Copyright (c) 2014年 Sword. All rights reserved.
//

#import "PushTreeTableView.h"

@interface PushTreeTableView ()
{
    
}

@end

@implementation PushTreeTableView

@synthesize arrowView = _arrowView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _arrowCenterX = self.boundsWidth;
        
        [self setupArrowView];
    }
    return self;
}

- (void)setupArrowView
{
    self.arrowView = [[PushTreeArrowView alloc] initWithFrame:CGRectMake(self.boundsWidth, 0 - 1000, ArrowSizeWidth, [self maxHeight] + 2000)];
    [_arrowView keepAutoresizingInFull];
    
    [self addSubview:_arrowView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _arrowView.arrowCenterY = _arrowCenterY + 1000;
    
    _arrowView.frameOriginX = _arrowCenterX + 1;
    _arrowView.frameHeight = [self maxHeight] + 2000;
    
    [_arrowView setNeedsDisplay];
}

- (CGFloat)maxHeight
{
    return MAX(self.boundsHeight, self.contentSize.height);
}

- (void)setLevel:(NSInteger)level
{
    _level = level;
    
//    [self setNeedsDisplay];
//    [self setNeedsLayout];
}

- (void)setArrowCenterY:(CGFloat)arrowCenterY
{
    _arrowCenterY = arrowCenterY;
    
//    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)setArrowCenterX:(CGFloat)arrowCenterX
{
    _arrowCenterX = arrowCenterX;
    
//    [self setNeedsDisplay];
    [self setNeedsLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /*
    CGFloat maxEndY = MAX(self.boundsHeight, self.contentSize.height);
    
    UIColor *_lineColor = [UIColor grayColor];
    CGFloat colorRGBAComponents[4];
    [_lineColor getRGBAComponents:colorRGBAComponents];
    
    float _lineWidth = 1;
    CGPoint lineStartPoint = CGPointMake(_arrowCenterX + ArrowSizeWidth, 0.0 - 500);
    CGPoint lineEndPoint = CGPointMake(_arrowCenterX + ArrowSizeWidth, maxEndY + 500);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextTranslateCTM(context, 0, 0);
    
    CGContextSetRGBStrokeColor(context, colorRGBAComponents[0], colorRGBAComponents[1], colorRGBAComponents[2], colorRGBAComponents[3]);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0), 3, [UIColor grayColor].CGColor);

    // Draw a single line from left to right
    CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);
    
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x - ArrowSizeWidth, _arrowCenterY);
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY + (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
    
    CGContextStrokePath(context);
    
    // 画三角形
    CGContextSetShadowWithColor(context, CGSizeZero, 3, [UIColor clearColor].CGColor);
    
    [[UIColor whiteColor] setFill];                 // 设置填充色
    [[UIColor clearColor] setStroke];               // 设置边框颜色
//            CGContextSetRGBFillColor(context, 1, 0, 0, 1);

    // 利用path进行绘制三角形
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x - ArrowSizeWidth,_arrowCenterY);
    CGContextAddLineToPoint(context, lineEndPoint.x, _arrowCenterY + (ArrowSizeHeight / 2));
    CGContextMoveToPoint(context, lineEndPoint.x, _arrowCenterY - (ArrowSizeHeight / 2));
    CGContextClosePath(context);                    // 路径结束标志，不写默认封闭
    
//            CGContextDrawPath(context, kCGPathFillStroke);  // 绘制路径path
     */
}

@end
