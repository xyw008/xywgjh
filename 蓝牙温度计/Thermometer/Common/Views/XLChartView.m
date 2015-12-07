//
//  XLChartView.m
//  Thermometer
//
//  Created by leo on 15/12/6.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "XLChartView.h"

#define kLabelForIndexTag 9000
#define kLabelForValueTag 8900

#define kValueLBWidth 30//值的LB宽度
#define kIndexLBHeight 20//水平位置LB高度

#define kMaxTemp 42
#define kMinTemp 32


@interface XLChartView ()

@property (nonatomic) CGFloat           chartValueWidth;
@property (nonatomic) CGFloat           chartValueHeight;

@property (nonatomic,strong) NSMutableArray *chartLayers;//图标的图层数组

@end


@implementation XLChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultParameters];
    }
    return self;
}

- (void)setDefaultParameters
{
    _chartLayers = [NSMutableArray new];
    
    _linecolor = [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];
    _fillColor = [_linecolor colorWithAlphaComponent:0.25];
    self.margin = 10.0f;
    self.topMargin = 40;
    
    _innerGridColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _drawInnerGrid = YES;
    _needVerticalLine = YES;
    _bezierSmoothing = YES;
    _bezierSmoothingTension = 0.3;
    _lineWidth = 1;
    _innerGridLineWidth = 0.5;
    
    _axisLineWidth = 0;
    _axisColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    //_animationDuration = 0.5;
    _displayDataPoint = NO;
    _dataPointRadius = 1;
    _dataPointColor = _linecolor;
    _dataPointBackgroundColor = _linecolor;
    
    // Labels attributes
    _indexLBBgColor = [UIColor clearColor];
    _indexLBTextColor = [UIColor grayColor];
    _indexLBFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    
    _valueLBBgColor = [UIColor colorWithWhite:1 alpha:0.75];
    _valueLBTextColor = [UIColor grayColor];
    _valueLBFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    //_valueLabelPosition = ValueLabelRight;
}

#pragma mark - set
- (void)setMargin:(CGFloat)margin
{
    _margin = margin;
    _chartValueWidth = self.frame.size.width - _margin - kValueLBWidth;
}

- (void)setTopMargin:(CGFloat)topMargin
{
    _topMargin = topMargin;
    _chartValueHeight = self.frame.size.height - kIndexLBHeight - _topMargin;
}

- (void)setValueLBStrArray:(NSArray *)valueLBStrArray
{
    if ([valueLBStrArray isAbsoluteValid]) {
        _valueLBStrArray = valueLBStrArray;
        [self initLabelForValue];
    }
}

- (void)setIndexStrArray:(NSArray *)indexStrArray
{
    if ([indexStrArray isAbsoluteValid]) {
        _indexStrArray = indexStrArray;
        [self initLabelForIndex];
    }
}

#pragma mark 
- (CGFloat)getValueGrid:(NSInteger)num
{
    return _topMargin + _chartValueHeight / (_valueLBStrArray.count - 1) * num;
}

#pragma mark - Drawing

//画格子
- (void)drawRect:(CGRect)rect
{
    if ([_valueLBStrArray isAbsoluteValid])
    {
        [self drawGrid];
    }
}

- (void)drawGrid
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(ctx);
    
    CGContextSetLineWidth(ctx, .5);
    CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
    CGContextMoveToPoint(ctx, kValueLBWidth, _topMargin);
    CGContextAddLineToPoint(ctx, kValueLBWidth, _topMargin + _chartValueHeight);
    CGContextStrokePath(ctx);
    
    // draw grid
    if(_drawInnerGrid)
    {
//        if (_needVerticalLine)
//        {
//            for(int i=0;i<_indexStrArray.count;i++)
//            {
//                
//                CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
//                CGContextSetLineWidth(ctx, _innerGridLineWidth);
//                
//                CGPoint point = CGPointMake((1 + i) * _axisWidth / _horizontalGridStep * scale + _margin, _margin);
//                
//                CGContextMoveToPoint(ctx, point.x, point.y);
//                CGContextAddLineToPoint(ctx, point.x, _axisHeight + _margin);
//                CGContextStrokePath(ctx);
//                
//                CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
//                CGContextSetLineWidth(ctx, _axisLineWidth);
//                CGContextMoveToPoint(ctx, point.x - 0.5f, _axisHeight + _margin);
//                CGContextAddLineToPoint(ctx, point.x - 0.5f, _axisHeight + _margin + 3);
//                CGContextStrokePath(ctx);
//            }
//        }
        
        for(int i=0;i < _valueLBStrArray.count + 1;i++)
        {
            if(i == _valueLBStrArray.count - 1)
            {
                CGContextSetLineWidth(ctx, 0.5);
                CGContextSetStrokeColorWithColor(ctx, [_axisColor CGColor]);
            }
            else
            {
                CGContextSetStrokeColorWithColor(ctx, [_innerGridColor CGColor]);
                CGContextSetLineWidth(ctx, _innerGridLineWidth);
            }
            
            //CGPoint point = CGPointMake(kValueLBWidth,[self getValueGrid:i]);
            
            
            CGPoint point = CGPointMake(kValueLBWidth, _topMargin + _chartValueHeight/(_valueLBStrArray.count - 1) * i);
            
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, kValueLBWidth + _chartValueWidth, point.y);
            CGContextStrokePath(ctx);
        }
    }
    
}


#pragma mark - 创建 label

//时间label
- (void)initLabelForIndex
{
    if([_indexStrArray isAbsoluteValid]) {
        
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:[UILabel class]] && subView.tag >= kLabelForIndexTag) {
                [subView removeFromSuperview];
            }
        }
        
        for(int i=0;i <_indexStrArray.count;i++)
        {
            NSString *text = [_indexStrArray objectAtIndex:i];
            CGFloat width = [text boundingRectWithSize:CGSizeMake(1000, kIndexLBHeight)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName:_indexLBFont }
                                             context:nil].size.width;
            
            CGFloat x = kValueLBWidth + (_chartValueWidth / (_indexStrArray.count - 1)) * i;
            if (_indexStrArray.count - 1 == i)
                x -= width - 5;
            else
                x -= width/2;
           
            
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake(x , _chartValueHeight + _topMargin + 3, 50, kIndexLBHeight - 3);
            label.font = _indexLBFont;
            label.textColor = _indexLBTextColor;
            label.backgroundColor = _indexLBBgColor;
            label.tag = kLabelForIndexTag + i;
            label.text = text;
            [self addSubview:label];
        }
    }
}

//值的LB
- (void)initLabelForValue
{
    if([_valueLBStrArray isAbsoluteValid])
    {
        
        for (UIView *subView in self.subviews)
        {
            if ([subView isKindOfClass:[UILabel class]] && subView.tag >= kLabelForValueTag) {
                [subView removeFromSuperview];
            }
        }
        
        for(int i=0;i < _valueLBStrArray.count;i++)
        {
            CGFloat valueLBHeight = 14;
            
            NSString *text = [_valueLBStrArray objectAtIndex:_valueLBStrArray.count - 1 - i];
            
            CGFloat y = _topMargin + (_chartValueHeight / (_valueLBStrArray.count - 1)) * i - valueLBHeight/2;
            
            //CGFloat y = [self getValueGrid:_valueLBStrArray.count - i] - valueLBHeight / 2;
            //CGFloat y = [self getValueGrid:i] - valueLBHeight / 2;
//            if (i == _indexStrArray.count - 1)
//                y = 0;
            
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, y, kValueLBWidth, valueLBHeight);
            label.font = _indexLBFont;
            label.textColor = _indexLBTextColor;
            label.backgroundColor = _indexLBBgColor;
            
            label.tag = kLabelForValueTag + i;
            label.text = text;
            [self addSubview:label];
        }
    }
}


- (void)loadDataArray:(NSArray<BLECacheDataEntity *> *)tempArray startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    for (CALayer *layer in _chartLayers) {
        [layer removeFromSuperlayer];
    }
    [_chartLayers removeAllObjects];
    
    _startDate = startDate;
    _endDate = endDate;
    
    if ([tempArray isAbsoluteValid])
    {
        //UIBezierPath *noPath = [self getLinePath:0 withSmoothing:_bezierSmoothing close:NO];
        UIBezierPath *path =  [UIBezierPath bezierPath];
        
        //UIBezierPath *noFill = [self getLinePath:0 withSmoothing:_bezierSmoothing close:YES];
        UIBezierPath *fillPath = [UIBezierPath bezierPath];
    
        CGPoint startPoint, endPoint;
        
        for (NSInteger i=0 ; i< tempArray.count; i += 1)
        {
            
            BLECacheDataEntity *oneItem = [tempArray objectAtIndex:i];
//            if ([oneItem.date compare:_startDate] == NSOrderedDescending || [oneItem.date compare:_endDate]  == NSOrderedAscending)
//            {
//                continue;
//            }
            //            BLECacheDataEntity *twoItem = [tempArray objectAtIndex:i + 1];
            //            BLECacheDataEntity *threeItem = [tempArray objectAtIndex:i + 2];
            
            CGPoint onePoint = [self getOneTempPoint:oneItem];
            //            CGPoint twoPoint = [self getOneTempPoint:twoItem];
            //            CGPoint threePoint = [self getOneTempPoint:threeItem];
            if(i == 0)
            {
                startPoint = onePoint;
                [path moveToPoint:onePoint];
                [fillPath moveToPoint:onePoint];
            }
            else
            {
                [path addLineToPoint:onePoint];
                [fillPath addLineToPoint:onePoint];
            }
            
            if (i == tempArray.count -1) {
                endPoint = onePoint;
            }
            
            
            //[path addQuadCurveToPoint:onePoint controlPoint:twoPoint];
            //[path addCurveToPoint:onePoint controlPoint1:twoPoint controlPoint2:threePoint];
        }
        [fillPath addLineToPoint:endPoint];
        [fillPath addLineToPoint:CGPointMake(endPoint.x, _topMargin + _chartValueHeight)];
        [fillPath addLineToPoint:CGPointMake(startPoint.x, _topMargin + _chartValueHeight)];
        [fillPath addLineToPoint:startPoint];
        
        
        if(_fillColor)
        {
            CAShapeLayer* fillLayer = [CAShapeLayer layer];
            //fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + minBound * scale, self.bounds.size.width, self.bounds.size.height);
            fillLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
            fillLayer.bounds = self.bounds;
            fillLayer.path = fillPath.CGPath;
            fillLayer.strokeColor = nil;
            fillLayer.fillColor = _fillColor.CGColor;
            fillLayer.lineWidth = 0;
            fillLayer.lineJoin = kCALineJoinRound;
            //self.clipsToBounds = YES;
            [self.layer addSublayer:fillLayer];
            [self.chartLayers addObject:fillLayer];
            
//            CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
//            fillAnimation.duration = _animationDuration;
//            fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            fillAnimation.fillMode = kCAFillModeForwards;
//            fillAnimation.fromValue = (id)noFill.CGPath;
//            fillAnimation.toValue = (id)fill.CGPath;
//            [fillLayer addAnimation:fillAnimation forKey:@"path"];
        }
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        pathLayer.bounds = self.bounds;
        pathLayer.path = path.CGPath;
        pathLayer.strokeColor = [_linecolor CGColor];
        pathLayer.fillColor = nil;
        pathLayer.lineWidth = _lineWidth;
        pathLayer.lineJoin = kCALineJoinRound;
        self.clipsToBounds = YES;
        [self.layer addSublayer:pathLayer];
        [self.chartLayers addObject:pathLayer];
        
        
//        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation.duration = .3;
//        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//        [pathLayer addAnimation:pathAnimation forKey:@"path"];
    }
}


- (CGPoint)getOneTempPoint:(BLECacheDataEntity*)item
{
    NSTimeInterval totalBetweenTime = [_endDate timeIntervalSinceDate:_startDate];
    
    NSTimeInterval betweenTime = [item.date timeIntervalSinceDate:_startDate];
    
    CGFloat temp = item.temperature;
    if (temp < kMinTemp)
        temp = kMinTemp;
    else if (temp > kMaxTemp)
        temp = kMaxTemp;
    
    CGFloat x = kValueLBWidth + _chartValueWidth * betweenTime / totalBetweenTime;
    CGFloat y = _topMargin + _chartValueHeight - _chartValueHeight * (temp - kMinTemp) / (kMaxTemp - kMinTemp);
    
    return CGPointMake(x, y);
}




@end

