//
//  PushTreeLeftMenuView.m
//  o2o
//
//  Created by swift on 14-7-30.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PushTreeLeftMenuView.h"

#define ArrowSizeWidth      10
#define ArrowSizeHeight     18

@implementation PushTreeLeftMenuView

@synthesize popTopLevelBtn = _popTopLevelBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        [self initializationViews];
    }
    return self;
}

- (void)initializationViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnSize = 32.0;
    
    self.popTopLevelBtn = InsertImageButton(self, CGRectMake((self.boundsWidth - btnSize) / 2, 15, btnSize, btnSize), 1000, [UIImage imageNamed:@"leimu-icon-fanhuifenleidingceng"], nil, nil, NULL);
    [_popTopLevelBtn setRadius:_popTopLevelBtn.boundsWidth / 2];
    [_popTopLevelBtn keepAutoresizingInFull];
}

- (void)layoutSubviews
{
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor *_lineColor = [UIColor lightGrayColor];
    CGFloat colorRGBAComponents[4];
    [_lineColor getRGBAComponents:colorRGBAComponents];
    
    float _lineWidth = 0.8;
    CGPoint lineStartPoint = CGPointMake(self.boundsWidth - 0.5, 0.0 - 500);
    CGPoint lineEndPoint = CGPointMake(self.boundsWidth - 0.5, self.boundsHeight + 500);
    
    CGFloat arrowCenterY = self.boundsHeight / 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextTranslateCTM(context, 0, 0);
    
    CGContextSetRGBStrokeColor(context, colorRGBAComponents[0], colorRGBAComponents[1], colorRGBAComponents[2], colorRGBAComponents[3]);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGContextSetShadowWithColor(context, CGSizeMake(-0.5, 0), 2, [UIColor grayColor].CGColor);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, lineStartPoint.x, lineStartPoint.y);
    
    CGContextAddLineToPoint(context, lineEndPoint.x, arrowCenterY - (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x - ArrowSizeWidth, arrowCenterY);
    CGContextAddLineToPoint(context, lineEndPoint.x, arrowCenterY + (ArrowSizeHeight / 2));
    CGContextAddLineToPoint(context, lineEndPoint.x, lineEndPoint.y);
    
    CGContextStrokePath(context);
}

@end
