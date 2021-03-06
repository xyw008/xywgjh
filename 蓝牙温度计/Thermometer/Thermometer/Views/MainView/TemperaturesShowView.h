//
//  TemperaturesShowView.h
//  Thermometer
//
//  Created by leo on 15/11/8.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperaturesShowView : UIView
@property (nonatomic,assign)BOOL    isFTypeTemperature;//是否显示华氏温度（defautl:NO,显示摄氏温度）
@property (nonatomic,assign)BOOL    isRemoteType;//是否是远程状态(default:NO 蓝牙模式)
@property (nonatomic,assign)BOOL    isShowTemperatureStatus;//是否显示温度状态（default:NO,搜索状态）

- (void)setTemperature:(CGFloat)temperature;

- (void)setRssi:(CGFloat)rssi;

- (void)setBettey:(CGFloat)bettey;

- (void)setSearchLBText:(NSString*)text;

@end
