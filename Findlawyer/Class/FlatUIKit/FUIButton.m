//
//  FUIButton.m
//  FlatUI
//
//  Created by Jack Flintermann on 5/7/13.
//  Copyright (c) 2013 Jack Flintermann. All rights reserved.
//

#import "FUIButton.h"
#import "UIImage+FlatUI.h"

@interface FUIButton()
{
    NSMutableArray *startPointArray;
    NSMutableArray *endPointArray;
    NSMutableArray *colorArray;
    NSMutableArray *widthArray;
}

@property(nonatomic) UIEdgeInsets defaultEdgeInsets;
@property(nonatomic) UIEdgeInsets normalEdgeInsets;
@property(nonatomic) UIEdgeInsets highlightedEdgeInsets;
@end

@implementation FUIButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultEdgeInsets = self.titleEdgeInsets;
        
        startPointArray = [NSMutableArray array];
        endPointArray = [NSMutableArray array];
        colorArray = [NSMutableArray array];
        widthArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    [super setTitleEdgeInsets:titleEdgeInsets];
    self.defaultEdgeInsets = titleEdgeInsets;
    [self setShadowHeight:self.shadowHeight];
}

- (void) setHighlighted:(BOOL)highlighted {
    UIEdgeInsets insets = highlighted ? self.highlightedEdgeInsets : self.normalEdgeInsets;
    [super setTitleEdgeInsets:insets];
    [super setHighlighted:highlighted];
}

- (void) setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self configureFlatButton];
}

- (void) setButtonColor:(UIColor *)buttonColor {
    _buttonColor = buttonColor;
    [self configureFlatButton];
}

- (void) setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self configureFlatButton];
}

- (void) setHighlightedColor:(UIColor *)highlightedColor{
    _highlightedColor = highlightedColor;
    [self configureFlatButton];
}

- (void) setShadowHeight:(CGFloat)shadowHeight {
    _shadowHeight = shadowHeight;
    UIEdgeInsets insets = self.defaultEdgeInsets;
    insets.top += shadowHeight;
    self.highlightedEdgeInsets = insets;
    insets.top -= shadowHeight * 2.0f;
    self.normalEdgeInsets = insets;
    [super setTitleEdgeInsets:insets];
    [self configureFlatButton];
}

- (void) configureFlatButton {
    UIImage *normalBackgroundImage = [UIImage buttonImageWithColor:self.buttonColor
                                                      cornerRadius:self.cornerRadius
                                                       shadowColor:self.shadowColor
                                                      shadowInsets:UIEdgeInsetsMake(0, 0, self.shadowHeight, 0)];
    
    UIColor *color = self.highlightedColor == nil ? self.buttonColor : self.highlightedColor;
    UIImage *highlightedBackgroundImage = [UIImage buttonImageWithColor:color
                                                           cornerRadius:self.cornerRadius
                                                            shadowColor:[UIColor clearColor]
                                                           shadowInsets:UIEdgeInsetsMake(self.shadowHeight, 0, 0, 0)];
    
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

/////////////////////////////////////////////////////////////////////

/*
- (void)addLineWithPosition:(FUI_DrawLinePostionType)position lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth
{
    [colorArray addObject:lineColor];
    [widthArray addObject:[NSNumber numberWithFloat:lineWidth]];
    
    CGPoint lineStartPoint = CGPointZero;
    CGPoint lineEndPoint = CGPointZero;
    
    switch (position)
    {
        case FUI_DrawLinePostionType_Top:
        {
            lineStartPoint = CGPointMake(0, lineWidth / 2);
            lineEndPoint = CGPointMake(self.bounds.size.width, lineWidth / 2);
        }
            break;
        case FUI_DrawLinePostionType_Bottom:
        {
            lineStartPoint = CGPointMake(0, self.bounds.size.height - (lineWidth / 2));
            lineEndPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height - (lineWidth / 2));
        }
            break;
        case FUI_DrawLinePostionType_Left:
        {
            lineStartPoint = CGPointMake(lineWidth / 2, 0);
            lineEndPoint = CGPointMake(lineWidth / 2, self.bounds.size.height);
        }
            break;
        case FUI_DrawLinePostionType_Right:
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
    UIImage *normalBackgroundImage = [UIImage buttonImageWithColor:self.buttonColor
                                                      cornerRadius:self.cornerRadius
                                                       shadowColor:self.shadowColor
                                                      shadowInsets:UIEdgeInsetsMake(0, 0, self.shadowHeight, 0)];
    [normalBackgroundImage drawInRect:rect];
    
    for (int i = 0; i < startPointArray.count; i++)
    {
        UIColor *_lineColor = [colorArray objectAtIndex:i];
        float _lineWidth = [[widthArray objectAtIndex:i] floatValue];
        CGPoint lineStartPoint = [[startPointArray objectAtIndex:i] CGPointValue];
        CGPoint lineEndPoint = [[endPointArray objectAtIndex:i] CGPointValue];
        
        CGFloat colorRGBAComponents[4];
        [_lineColor getRGBAComponents:colorRGBAComponents];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        //            CGContextSaveGState(context);
        
        CGContextSetRGBStrokeColor(context, colorRGBAComponents[0], colorRGBAComponents[1], colorRGBAComponents[2], colorRGBAComponents[3]);
        CGContextSetLineWidth(context, _lineWidth);
        
        // Draw a single line from left to right
        CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);
        CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
        
        CGContextStrokePath(context);
        
        //            CGContextRestoreGState(context);
    }
}
 */

@end
