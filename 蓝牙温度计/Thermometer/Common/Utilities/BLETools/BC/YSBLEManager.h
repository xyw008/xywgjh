//
//  YSBLEManager.h
//  Thermometer
//
//  Created by leo on 15/11/16.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEManager.h"

typedef void (^ActualTimeValueCallBack) (CGFloat newTemperature,CGFloat newBettey);

typedef void (^GroupTemperatureCallBack) (NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic);

@interface YSBLEManager : NSObject

@property (nonatomic,strong)ActualTimeValueCallBack     actualTimeValueCallBack;//实时温度回调
@property (nonatomic,strong)GroupTemperatureCallBack    groupTemperatureCallBack;//温度组的回调

@property (nonatomic,assign)BOOL                        is30Second;//是否是30秒一组的数据

AS_SINGLETON(YSBLEManager);

- (void)startScanPeripherals;


- (void)writeIs30Second:(BOOL)is30Second;

@end
