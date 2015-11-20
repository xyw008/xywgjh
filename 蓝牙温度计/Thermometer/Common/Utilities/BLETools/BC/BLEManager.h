//
//  BLEManager.h
//  BabyBluetoothAppDemo
//
//  Created by 龚 俊慧 on 15/11/4.
//  Copyright © 2015年 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BLECacheDataEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLEManager : NSObject

/**
 @ 方法描述: 根据蓝牙特征返回的Data获取温度值(正常的温度值是25°~45°,低于25时统一返回24,高于45时统一返回46)
 @ 输入参数: Data
 @ 返回值:   温度值
 @ 创建人:   龚俊慧
 @ Creat:   2015-11-04
 */
+ (CGFloat)getTemperatureWithBLEData:(NSData *)data;

/**
 @ 方法描述: 根据蓝牙特征返回的Data获取温度计电量
 @ 输入参数: Data
 @ 返回值:   电量值10~100
 @ 创建人:   龚俊慧
 @ Creat:   2015-11-04
 */
+ (NSInteger)getBatteryWithBLEData :(NSData *)data;

/**
 @ 方法描述: 根据蓝牙特征返回的Data获取温度计30s类型的缓存温度数据
 @ 输入参数: Data
 @ 返回值:   {key: 第几组, value: BLECacheDataEntity的数组}
 @ 创建人:   龚俊慧
 @ Creat:   2015-11-05
 */
+ (NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *)getCacheTemperatureDataWithBLEData:(NSData *)data error:(NSError **)error;


/**
 @ 方法描述: 摄氏文档转华氏温度
 @ 输入参数:  摄氏温度
 @ 返回值:   华氏温度
 @ 创建人:   熊耀文
 @ Creat:   2015-11-15
 */
+ (CGFloat)getFTemperatureWithC:(CGFloat)c_temperature;

@end

NS_ASSUME_NONNULL_END
