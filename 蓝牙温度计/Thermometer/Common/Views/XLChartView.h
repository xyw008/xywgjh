//
//  XLChartView.h
//  Thermometer
//
//  Created by leo on 15/12/6.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLECacheDataEntity.h"

@interface XLChartView : UIView

@property (nonatomic, strong) UIFont    *indexLBFont;//水平index
@property (nonatomic) UIColor           *indexLBTextColor;
@property (nonatomic) UIColor           *indexLBBgColor;
@property (nonatomic, strong) NSArray   *indexStrArray;//时间数组

@property (nonatomic, strong) NSDate    *startDate;//开始时间
@property (nonatomic, strong) NSDate    *endDate;//结束时间


@property (nonatomic, strong) UIFont    *valueLBFont;
@property (nonatomic) UIColor           *valueLBTextColor;
@property (nonatomic) UIColor           *valueLBBgColor;
@property (nonatomic, strong) NSArray   *valueLBStrArray;//垂直方向LB文字数组(从下往上写)


@property (nonatomic) BOOL              isFillLeft;//填充左边没有的温度数据(默认不填充)


@property (nonatomic, strong) UIColor   *linecolor;//图标线的颜色
@property (nonatomic) CGFloat           lineWidth;//图标线的宽度
@property (nonatomic, strong) UIColor   *fillColor;//填充颜色

@property (nonatomic,assign) CGFloat    margin;
@property (nonatomic,assign) CGFloat    topMargin;//顶部边缘

@property (nonatomic, strong) UIColor   *axisColor;//
@property (nonatomic) CGFloat           axisLineWidth;


@property (nonatomic) BOOL              displayDataPoint;
@property (nonatomic, strong) UIColor   *dataPointColor;
@property (nonatomic, strong) UIColor   *dataPointBackgroundColor;
@property (nonatomic) CGFloat           dataPointRadius;

@property (nonatomic) BOOL              drawInnerGrid;//是否画内部格子
@property (nonatomic, strong) UIColor   *innerGridColor;//格子线的颜色
@property (nonatomic) CGFloat           innerGridLineWidth;//格子线的宽度
@property (nonatomic) BOOL              needVerticalLine;//是否需要垂直的线


@property (nonatomic) BOOL              bezierSmoothing;//值的线条是否添加贝塞尔曲线
@property (nonatomic) CGFloat           bezierSmoothingTension;


- (void)loadDataArray:(NSArray<BLECacheDataEntity *> *)tempArray startDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
