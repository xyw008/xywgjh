//
//  StrikeThroughLabel.m
//  StrikeThroughLabelExample
//
//  Created by Scott Hodgin on 12/14/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "ATB_StrikeThroughLabel.h"

@implementation ATB_StrikeThroughLabel

- (id)initWithFrame:(CGRect)frame strikeThroughEnabled:(BOOL)isStrikeThrough linePositionType:(LinePositionType)positionType lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor contentOffset:(CGSize)contentOffset
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _strikeThroughEnabled = isStrikeThrough;
        _positionType = positionType;
        _lineWidth = lineWidth;
        _lineColor = lineColor;
        _contentOffset = contentOffset;
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:CGRectMake(_contentOffset.width, _contentOffset.height, rect.size.width - _contentOffset.width * 2, rect.size.height - _contentOffset.height * 2)];
    
    if (_strikeThroughEnabled)
    {
//        CGSize textSize = [[self text] sizeWithFont:[self font]];
//        CGFloat strikeWidth = textSize.width;
        CGRect lineRect;
        
        switch (_positionType)
        {
            case TopLine:
            {
                lineRect = CGRectMake(0, 0, rect.size.width, _lineWidth);
            }
                break;
            case MiddleLine:
            {
                lineRect = CGRectMake(0, rect.size.height / 2, rect.size.width, _lineWidth);
            }
                break;
            case BottomLine:
            {
                lineRect = CGRectMake(0, rect.size.height - _lineWidth, rect.size.width, _lineWidth);
            }
                break;
                
            default:
                break;
        }
     
        
        CGFloat redValue;
        CGFloat greenValue;
        CGFloat blueValue;
        CGFloat alphaValue;
        
        if ([_lineColor getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue])
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            // Drawing lines with a white stroke color
            CGContextSetRGBStrokeColor(context, redValue, greenValue, blueValue, alphaValue);
            // Draw them with a 2.0 stroke width so they are a bit more visible.
            CGContextSetLineWidth(context, _lineWidth);
            
            /*
            // Draw a single line from left to right
            CGContextMoveToPoint(context, (rect.size.width - strikeWidth) / 2, rect.size.height - 0);
            CGContextAddLineToPoint(context, rect.size.width - (rect.size.width - strikeWidth) / 2, rect.size.height - 0);
            
            CGContextStrokePath(context);
            CGContextFillRect(context, lineRect);
             */
            CGContextStrokeRect(context, lineRect);
        }
    }
}

@end
