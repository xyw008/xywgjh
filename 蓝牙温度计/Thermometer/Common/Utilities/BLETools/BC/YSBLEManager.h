//
//  YSBLEManager.h
//  Thermometer
//
//  Created by leo on 15/11/16.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEManager.h"

typedef void (^ActualTimeValueCallBack) (CGFloat newTemperature,CGFloat rssi, CGFloat newBettey);

typedef void (^GroupTemperatureCallBack) (NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic);

@interface YSBLEManager : NSObject

@property (nonatomic,strong)ActualTimeValueCallBack     actualTimeValueCallBack;//实时温度回调
@property (nonatomic,strong)GroupTemperatureCallBack    groupTemperatureCallBack;//温度组的回调

@property (nonatomic,assign)BOOL                        isFUnit;//是否是华氏单位显示(default:NO)

@property (nonatomic,assign)BOOL                        is30Second;//是否是30秒一组的数据

@property (nonatomic,assign)CGFloat                     rssi;//蓝牙信号强度（-50 -- 0 强  -70 --  -50 较强）
@property (nonatomic,readonly,strong)NSString           *macAdd;//mac地址

AS_SINGLETON(YSBLEManager);

- (void)startScanPeripherals;


- (void)writeIs30Second:(BOOL)is30Second;


@end
