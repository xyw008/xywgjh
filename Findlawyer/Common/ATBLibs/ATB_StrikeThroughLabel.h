//
//  StrikeThroughLabel.h
//  StrikeThroughLabelExample
//
//  Created by Scott Hodgin on 12/14/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    TopLine,
    MiddleLine,
    BottomLine
    
}LinePositionType;

@interface ATB_StrikeThroughLabel : UILabel
{
    BOOL _strikeThroughEnabled;
    LinePositionType _positionType;
    float _lineWidth;
    UIColor *_lineColor;
    CGSize _contentOffset;
}

- (id)initWithFrame:(CGRect)frame strikeThroughEnabled:(BOOL)isStrikeThrough linePositionType:(LinePositionType)positionType lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor contentOffset:(CGSize)contentOffset;

@end
