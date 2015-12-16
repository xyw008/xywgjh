//
//  YSBLEManager.h
//  Thermometer
//
//  Created by leo on 15/11/16.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEManager.h"
#import "CommonEntity.h"

typedef void (^ActualTimeValueCallBack) (CGFloat newTemperature,CGFloat rssi, CGFloat newBettey);

/**
 *  获取蓝牙温度组数据
 *
 *  @param temperatureDic        没有排序有key是所在组的数据
 *  @param tempArray             排序后的数组
 *  @param is30Second            YES：30s类型数据
 */
typedef void (^GroupTemperatureCallBack) (NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic,NSArray<BLECacheDataEntity *> *tempArray,BOOL is30Second);


typedef void (^RemoteGroupTempCallBack) (NSArray<RemoteTempItem *> *tempArray,NSArray<RemoteTempItem *> *fillingTempArray, NSDate *beginDate, NSDate *endDate);


@interface YSBLEManager : NSObject

@property (nonatomic,strong)ActualTimeValueCallBack     actualTimeValueCallBack;//实时温度回调
@property (nonatomic,strong)GroupTemperatureCallBack    groupTemperatureCallBack;//温度组的回调
@property (nonatomic,strong)RemoteGroupTempCallBack     remoteTempCallBack;//远程获取时间段的温度数组

@property (nonatomic,assign)BOOL                        isFUnit;//是否是华氏单位显示(default:NO)

@property (nonatomic,assign)BOOL                        is30Second;//是否是30秒一组的数据

@property (nonatomic,assign)CGFloat                     rssi;//蓝牙信号强度（-50 -- 0 强  -70 --  -50 较强）
@property (nonatomic,strong)NSString                    *macAdd;//mac地址
@property (nonatomic,strong)NSString                    *deviceIdentifier;//设备id

@property (nonatomic,strong)NSDate                      *lastUploadTempDate;//最后上传温度数据的时间，这个后面的30s的温度组数据都要上传


AS_SINGLETON(YSBLEManager);

- (void)initBluetoothInfo;

//开始扫描链接
- (void)startScanPeripherals;

//断开所有链接
- (void)cancelAllPeripheralsConnection;

- (void)writeIs30Second:(BOOL)is30Second;

- (void)getRemoteTempBegin:(NSDate*)beginDate end:(NSDate*)endDate;



@end
