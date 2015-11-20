//
//  TemperaturesShowView.m
//  Thermometer
//
//  Created by leo on 15/11/8.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "TemperaturesShowView.h"
#import "BLEManager.h"

@interface TemperaturesShowView ()
{
    UILabel         *_searchLB;//搜索中LB

    
    UIView          *_temperaturesColorView;//显示温度计颜色的视图
    UIImageView     *_temperaturesIV;//温度计图片
    
    UILabel         *_temperaturesLB;//温度LB
    UILabel         *_unitLB;//单位LB
    UILabel         *_statusLB;//状态(正常等)
    
    UILabel         *_highestLB;//最高温度LB
    UILabel         *_highestValueLB;//最高温度值LB
    UILabel         *_testTimeLB;//测试时间LB
    UILabel         *_testTimeValueLB;//测试时间值LB
    UILabel         *_deviceLB;//设备
    UIImageView     *_deviceSignalIV;//设备信号IV
    UIImageView     *_deviceBatteryIV;//设备电池IV
    
    CGFloat         _highestTemperatures;
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

+ (NSString*)getTemperaturesStatus:(CGFloat)temperature
{
    if (temperature <= 35.9)
        return @"低温";
    else if(temperature <= 37.4)
        return @"正常";
    else if(temperature <= 37.9)
        return @"低烧";
    else if(temperature <= 45)
        return @"高烧";
    else
        return @"异常";
}

+ (NSString*)getBetteyImage:(CGFloat)bettey
{
    if (bettey == -1)
        return @"home_device_battery_00";
    else if (bettey <= 20)
        return @"home_device_battery_01";
    else if (bettey <= 40)
        return @"home_device_battery_02";
    else if (bettey <= 60)
        return @"home_device_battery_03";
    else if (bettey <= 80)
        return @"home_device_battery_04";
    else
        return @"home_device_battery_05";
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
    self.backgroundColor = HEXCOLOR(0XF7F7F7);
    _highestTemperatures = 0;
    [self initTemperaturesImageView];
    [self initTemperaturesTitleView];
}

//温度计图片
- (void)initTemperaturesImageView
{
    //温度计图片
    NSString *temperatureImgStr = _isFTypeTemperature ? @"home_temperature_bg_f" : @"home_temperature_bg_t";
    
    _temperaturesIV = [[UIImageView alloc] initWithFrame:CGRectMake(32, 55, DynamicWidthValue640(200), DynamicWidthValue640(587))];
    _temperaturesIV.image = [UIImage imageNamed:temperatureImgStr];
    
    //温度计颜色视图
    _temperaturesColorView = [[UIView alloc] initWithFrame:_temperaturesIV.frame];
    _temperaturesColorView.backgroundColor = [TemperaturesShowView getTemperaturesColor:0];
    
    [self addSubview:_temperaturesColorView];
    [self addSubview:_temperaturesIV];
    
    //温度计高亮效果图片
    UIImageView *lightIV = [[UIImageView alloc] initWithFrame:_temperaturesColorView.frame];
    lightIV.image = [UIImage imageNamed:@"home_temperature_light"];
    [self addSubview:lightIV];
}

//温度文字
- (void)initTemperaturesTitleView
{
    _searchLB = [[UILabel alloc] init];
    _searchLB.textColor = Common_GreenColor;
    _searchLB.font = [UIFont systemFontOfSize:43];
    _searchLB.text = @"搜索中";
    [self addSubview:_searchLB];
    
    [_searchLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_temperaturesIV.mas_top).offset(70);
        make.right.equalTo(self.mas_right).offset(-40);
        make.height.equalTo(50);
        make.width.equalTo([_searchLB.text sizeWithFont:_searchLB.font constrainedToWidth:400]);
    }];
    
    
    //UniDreamLED font name
    //_temperaturesLB = [[UILabel alloc] init];
    _temperaturesLB = [[UILabel alloc] initWithText:@"38" font:[UIFont fontWithName:@"UniDreamLED" size:90]];
    _temperaturesLB.textColor = _temperaturesColorView.backgroundColor;
    [self addSubview:_temperaturesLB];
    _temperaturesLB.hidden = YES;
    
    _unitLB = [[UILabel alloc] init];
    _unitLB.font = [UIFont systemFontOfSize:38];
    _unitLB.textColor = [TemperaturesShowView getTemperaturesColor:0];
    _unitLB.text = @"°C";
    [self addSubview:_unitLB];
    _unitLB.hidden = YES;
    
    CGFloat statusLBHeight = DynamicWidthValue640(32);
    _statusLB = [[UILabel alloc] initWithText:@"正常" font:SP12Font];
    _statusLB.backgroundColor = _unitLB.backgroundColor;
    _statusLB.textColor = [UIColor whiteColor];
    _statusLB.textAlignment = NSTextAlignmentCenter;
    ViewRadius(_statusLB, statusLBHeight/2);
    [self addSubview:_statusLB];
    _statusLB.hidden = YES;
 
    _highestLB = [self creatLBText:@"最高温度:"];
    _highestValueLB = [self creatLBText:@"0.0度"];
    _testTimeLB = [self creatLBText:@"已测:"];
    _testTimeValueLB = [self creatLBText:@"58分钟"];
    _deviceLB = [self creatLBText:@"设备:"];
    _deviceLB.hidden = NO;
    
    _deviceSignalIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_device_wifi_00"]];
    [self addSubview:_deviceSignalIV];
    
    _deviceBatteryIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_device_battery_00"]];
    [self addSubview:_deviceBatteryIV];
    
    [_temperaturesLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_statusLB.mas_left).offset(0);
        make.height.equalTo(90);
        make.top.equalTo(_temperaturesIV.mas_top).offset(53);
    }];
    
    [_unitLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_temperaturesLB.mas_top).offset(5);
        make.left.equalTo(_temperaturesLB.mas_right).offset(4);
        make.height.equalTo(40);
        make.width.equalTo(60);
    }];
    
    CGFloat statusWidth = [_statusLB.text sizeWithFont:_statusLB.font constrainedToWidth:130].width + statusLBHeight;
    [_statusLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-32);
        make.bottom.equalTo(_temperaturesLB.mas_bottom).offset(-15);
        make.height.equalTo(statusLBHeight);
        make.width.equalTo(statusWidth);
    }];
    
    CGFloat highestLBWidth = [_highestLB.text sizeWithFont:_highestLB.font constrainedToWidth:300].width + 8;
    [_highestLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_highestValueLB.mas_left).offset(-12);
        make.top.equalTo(_temperaturesLB.mas_bottom).offset(24);
        make.height.equalTo(22);
        make.width.equalTo(highestLBWidth);
    }];
    
    //最高温度值LB宽度
    CGFloat highestValueLBWidth = [@"36.8度" sizeWithFont:_highestValueLB.font constrainedToWidth:1000].width + 8;
    [_highestValueLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_statusLB.mas_right);
        make.top.equalTo(_highestLB.mas_top);
        make.height.equalTo(_highestLB.mas_height);
        make.width.equalTo(highestValueLBWidth);
    }];
    
    [_testTimeLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_highestLB.mas_right);
        make.top.equalTo(_highestLB.mas_bottom).offset(10);
        make.height.equalTo(_highestLB.mas_height);
        make.width.equalTo(_highestLB.mas_width);
    }];
    
    [_testTimeValueLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_highestValueLB.mas_right);
        make.top.equalTo(_testTimeLB.mas_top);
        make.height.equalTo(_testTimeLB.mas_height);
        make.width.equalTo(_highestValueLB.mas_width);
    }];
    
    [_deviceLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_testTimeLB.mas_bottom).offset(10);
        make.right.equalTo(_testTimeLB.mas_right);
        make.width.equalTo(_testTimeLB.mas_width);
        make.height.equalTo(_testTimeLB.mas_height);
    }];
    
    [_deviceSignalIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_deviceLB.mas_centerY);
        make.left.equalTo(_deviceLB.mas_right).offset(12);
        make.height.equalTo(22);
        make.width.equalTo(22);
        //make.height.equalTo(32);
        //make.width.equalTo(32);
    }];
    
    [_deviceBatteryIV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_deviceSignalIV.mas_centerY);
        make.left.equalTo(_deviceSignalIV.mas_right).offset(4);
        make.height.equalTo(_deviceSignalIV.mas_height);
        make.width.equalTo(_deviceSignalIV.mas_width);
    }];
}

- (UILabel*)creatLBText:(NSString*)text
{
    UILabel *lb = [[UILabel alloc] init];
    lb.text = text;
    lb.textColor = Common_BlackColor;
    lb.textAlignment = NSTextAlignmentRight;
    lb.font = SP18Font;
    [self addSubview:lb];
    lb.hidden = YES;
    return lb;
}


#pragma mark - set
- (void)setIsFTypeTemperature:(BOOL)isFTypeTemperature
{
    NSString *temperatureImgStr = _isFTypeTemperature ? @"home_temperature_bg_f" : @"home_temperature_bg_t";
    _temperaturesIV.image = [UIImage imageNamed:temperatureImgStr];
    
    _unitLB.text = _isFTypeTemperature ? @"°F" : @"°C";
}

- (void)setIsShowTemperatureStatus:(BOOL)isShowTemperatureStatus
{
    _isShowTemperatureStatus = isShowTemperatureStatus;
    if (_isShowTemperatureStatus)
    {
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:[UILabel class]]) {
                subView.hidden = NO;
            }
        }
        _searchLB.hidden = YES;
    }
}


- (void)setTemperature:(CGFloat)temperature
{
    CGFloat height = DynamicWidthValue640(275/1.5);
    
    if (temperature <= 32)
    {
        
    }
    else if (temperature >= 44)
    {
        height = _temperaturesIV.height;
    }
    else
    {
        height += (temperature - 32) * DynamicWidthValue640(50/1.5);
    }
    
    
    _temperaturesColorView.frame = CGRectMake(_temperaturesColorView.frameOriginX, CGRectGetMaxY(_temperaturesIV.frame) - height, _temperaturesColorView.width, height);
    _temperaturesColorView.backgroundColor = [TemperaturesShowView getTemperaturesColor:temperature];
    
    CGFloat nowTemperature = _isFTypeTemperature ? [BLEManager getFTemperatureWithC:temperature] : temperature;
    NSString *nowTemperatureString = [NSString stringWithFormat:@"%.1lf",nowTemperature];
    
    //华式显示会有查过100的情况。
    _temperaturesLB.font = nowTemperatureString.length > 4 ? [UIFont fontWithName:@"UniDreamLED" size:79] : [UIFont fontWithName:@"UniDreamLED" size:90];
    _temperaturesLB.text = nowTemperatureString;
    _temperaturesLB.textColor = _temperaturesColorView.backgroundColor;
    _unitLB.textColor = _temperaturesLB.textColor;
    _statusLB.backgroundColor = _temperaturesColorView.backgroundColor;
    _statusLB.text = [TemperaturesShowView getTemperaturesStatus:temperature];
    
    if (nowTemperature > _highestTemperatures) {
        _highestTemperatures = nowTemperature;
        _highestValueLB.text = [NSString stringWithFormat:@"%.1lf度",nowTemperature];
    }
}

- (void)setBettey:(CGFloat)bettey
{
    _deviceBatteryIV.image = [UIImage imageNamed:[TemperaturesShowView getBetteyImage:bettey]];
}


@end
