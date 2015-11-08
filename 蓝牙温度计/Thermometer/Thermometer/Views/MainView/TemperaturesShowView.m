//
//  TemperaturesShowView.m
//  Thermometer
//
//  Created by leo on 15/11/8.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "TemperaturesShowView.h"

@interface TemperaturesShowView ()
{
    UIView          *_temperaturesColorView;//显示温度计颜色的视图
    UIImageView     *_temperaturesIV;//温度计图片
    
}

@end



@implementation TemperaturesShowView

/*
 温度取值        <25℃	25℃~35.9℃	36℃~37.4℃	37.5℃~.37.9℃   38℃~45℃     >45℃
 “温度数值”	温度过低	当前温度值	当前温度值	当前温度值     当前温度值	    异常
 “温度状态”	  低温     低温         正常         低烧          高烧        异常
 “温度计”       蓝色	  蓝色	       绿色	       橙色	        红色	        红色
 */


+ (UIColor*)getTemperaturesColor:(CGFloat)temperature
{
    if (temperature == 0) {
        return Common_GrayColor;
    }
    else if (temperature <= 35.9)//蓝色
    {
        return HEXCOLOR(0X6F70BA);
    }
    else if(temperature <= 37.4)//绿色
    {
        return HEXCOLOR(0X12B98E);
    }
    else if(temperature <= 37.9)//橙色
    {
        return HEXCOLOR(0XFF4330);
    }
    else//红色
    {
        return HEXCOLOR(0XFF4330);
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    //温度计颜色视图
    _temperaturesColorView = [[UIView alloc] initWithFrame:CGRectMake(DpToPx(32)/2, DpToPx(42)/2, DynamicWidthValue640(200), DynamicWidthValue640(587))];
    _temperaturesColorView.backgroundColor = [TemperaturesShowView getTemperaturesColor:20];
    [self addSubview:_temperaturesColorView];
    
    //温度计图片
    _temperaturesIV = [[UIImageView alloc] initWithFrame:_temperaturesColorView.frame];
    _temperaturesIV.image = [UIImage imageNamed:@"home_temperature_bg_t"];
    [self addSubview:_temperaturesIV];
    
    //温度计高亮效果图片
    UIImageView *lightIV = [[UIImageView alloc] initWithFrame:_temperaturesColorView.frame];
    lightIV.image = [UIImage imageNamed:@"home_temperature_light"];
    [self addSubview:lightIV];
}

- (void)setTemperature:(CGFloat)temperature
{
    
}




@end
