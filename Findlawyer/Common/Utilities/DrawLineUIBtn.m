//
//  ZSDrawLineUIView.m
//  SunnyFace
//
//  Created by 龚 俊慧 on 12-12-29.
//  Copyright (c) 2012年 龚 俊慧. All rights reserved.
//

#import "DrawLineUIBtn.h"

@interface DrawLineUIBtn ()
{
    NSMutableArray *startPointArray;
    NSMutableArray *endPointArray;
    NSMutableArray *colorArray;
    NSMutableArray *widthArray;
}

@end

@implementation DrawLineUIBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        startPointArray = [NSMutableArray array];
        endPointArray = [NSMutableArray array];
        colorArray = [NSMutableArray array];
        widthArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)addLineWithPosition:(DrawLinePostionType)position lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth
{
    [colorArray addObject:lineColor];
    [widthArray addObject:[NSNumber numberWithFloat:lineWidth]];
    
    CGPoint lineStartPoint = CGPointZero;
    CGPoint lineEndPoint = CGPointZero;
    
    switch (position)
    {
        case DrawLinePostionType_Top:
        {
            lineStartPoint = CGPointMake(0, lineWidth / 2);
            lineEndPoint = CGPointMake(self.bounds.size.width, lineWidth / 2);
        }
            break;
        case DrawLinePostionType_Bottom:
        {
            lineStartPoint = CGPointMake(0, self.bounds.size.height - (lineWidth / 2));
            lineEndPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height - (lineWidth / 2));
        }
            break;
        case DrawLinePostionType_Left:
        {
            lineStartPoint = CGPointMake(lineWidth / 2, 0);
            lineEndPoint = CGPointMake(lineWidth / 2, self.bounds.size.height);
        }
            break;
        case DrawLinePostionType_Right:
        {
            lineStartPoint = CGPointMake(self.bounds.size.width - (lineWidth / 2), 0);
            lineEndPoint = CGPointMake(self.bounds.size.width - (lineWidth / 2), self.bounds.size.height);
        }
            break;
            
        default:
            break;
    }
    
    [startPointArray addObject:[NSValue valueWithCGPoint:lineStartPoint]];
    [endPointArray addObject:[NSValue valueWithCGPoint:lineEndPoint]];
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < startPointArray.count; i++)
    {
        UIColor *_lineColor = [colorArray objectAtIndex:i];
        float _lineWidth = [[widthArray objectAtIndex:i] floatValue];
        CGPoint lineStartPoint = [[startPointArray objectAtIndex:i] CGPointValue];
        CGPoint lineEndPoint = [[endPointArray objectAtIndex:i] CGPointValue];
        
        CGFloat redValue;
        CGFloat greenValue;
        CGFloat blueValue;
        CGFloat alphaValue;
        
        if ([_lineColor getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue])
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextSaveGState(context);

            CGContextSetRGBStrokeColor(context, redValue, greenValue, blueValue, alphaValue);
            CGContextSetLineWidth(context, _lineWidth);
            
            // Draw a single line from left to right
            CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);
            CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
            
            CGContextStrokePath(context);
            
//            CGContextRestoreGState(context);
        }
    }
}

@end
