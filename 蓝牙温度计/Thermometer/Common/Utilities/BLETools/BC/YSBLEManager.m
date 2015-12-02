//
//  YSBLEManager.m
//  Thermometer
//
//  Created by leo on 15/11/16.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "YSBLEManager.h"
#import "BLEManager.h"
#import "BabyBluetooth.h"
#import "SystemConvert.h"
#import "BabyToy.h"
#import "UserInfoModel.h"
#import "AccountStautsManager.h"
#import "NetRequestManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"


@interface YSBLEManager ()<NetRequestDelegate>
{
    BabyBluetooth               *_babyBluethooth;
    CBPeripheral                *_currPeripheral;//现在的外围设备
    CBService                   *_currTemperatureService;//现在的服务
    
    BOOL                        _hasGroupNotifiy;//是否已经设置温度组的通知（defalut:NO）
    NSInteger                   _groupIndex;//取温度的组数从1开始(30秒 最大6，5分钟 最大30)
    NSMutableDictionary         *_groupTemperatureDic;//温度组
    
    
    NSInteger                   _uploadIndex;//上传数据计数，和rssi一个定时器。5秒一次回调，30秒请求一次上报
    BOOL                        _isUploadRequesting;//数据上报状态
    BOOL                        _hasReturnCurrTemp;//有开始返回实时温度了
    NSMutableArray<NSDictionary*>  *_currTempArray;//实时温度保存数组(温度和对应的时间)
    NSInteger                   _hasUploadIndex;//数组数据已经上传到的index
}

@end

@implementation YSBLEManager

DEF_SINGLETON(YSBLEManager);

- (void)dealloc
{
    if (_babyBluethooth) {
        [_babyBluethooth cancelAllPeripheralsConnection];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _groupIndex = 1;
        _hasGroupNotifiy = NO;
        _groupTemperatureDic = [[NSMutableDictionary alloc] init];
        
        _uploadIndex = 1;
        _isUploadRequesting = NO;
        _hasReturnCurrTemp = NO;
        _currTempArray = [NSMutableArray new];
        _hasUploadIndex = 0;
        
        _isFUnit = [[UserInfoModel getIsFUnit] boolValue];
        
        
    }
    return self;
}

- (void)initBluetoothInfo
{
    //初始化BabyBluetooth 蓝牙库
    _babyBluethooth = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self bluethoothDelegate];
}

- (void)startScanPeripherals
{
    //停止之前的连接
    [_babyBluethooth cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    _babyBluethooth.scanForPeripherals().begin();
}

- (void)setIsFUnit:(BOOL)isFUnit
{
    _isFUnit = isFUnit;
    [UserInfoModel setUserDefaultIsFUnit:@(_isFUnit)];
}

#pragma mark - write

//写入
- (void)writeIs30Second:(BOOL)is30Second
{
    _is30Second = is30Second;
    _groupIndex = 1;
    
    if (!_hasGroupNotifiy) {
        [self setTemperatureGroupNotifiy];
    }
    
    [self startWriteGourpData];
}


- (void)startWriteGourpData
{
    if (1 == _groupIndex) {
        [_groupTemperatureDic removeAllObjects];
    }
    
    for (CBCharacteristic *characteristic in _currTemperatureService.characteristics)
    {
        if ([characteristic.UUID.UUIDString isEqualToString:@"FFF3"])
        {
            NSInteger type = _is30Second ? 1 : 2;
            NSInteger total = type + _groupIndex;
            
            NSString *hexType = [SystemConvert decimalToHex:type];
            NSString *hexIndex = [SystemConvert decimalToHex:_groupIndex];
            NSString *hexTotal = [SystemConvert decimalToHex:total];
            
            NSMutableData *data = [NSMutableData dataWithCapacity:3];
            [data appendData:[BabyToy ConvertHexStringToData:hexType]];
            [data appendData:[BabyToy ConvertHexStringToData:hexIndex]];
            [data appendData:[BabyToy ConvertHexStringToData:hexTotal]];
            
            [_currPeripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}


#pragma mark - bluethooth
//蓝牙网关初始化和委托方法设置
-(void)bluethoothDelegate
{
    WEAKSELF
    [_babyBluethooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            DLog(@"设备打开成功，开始扫描设备");
        }
    }];
    
    
    //设置扫描到设备的委托
    [_babyBluethooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        DLog(@"搜索到了设备:%@",peripheral.name);
        STRONGSELF
        
        NSString *name = [peripheral.name lowercaseString];
        NSString *ys = [@"Yushi_MODT" lowercaseString];
        
        if ([name isEqualToString:ys])
        {
            //停止扫描
            [strongSelf->_babyBluethooth cancelScan];
            
            strongSelf->_currPeripheral = peripheral;
            strongSelf->_rssi = [RSSI floatValue];
            
            strongSelf->_babyBluethooth.having(strongSelf->_currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
            
            //定时刷新rssi
            [NSTimer scheduledTimerWithTimeInterval:5.0f target:strongSelf selector:@selector(refreshRssi) userInfo:nil repeats:YES];
        }
    }];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_babyBluethooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        DLog(@"连接成功");
        
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置设备连接失败的委托
    [_babyBluethooth setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"设备：%@--连接失败",peripheral.name);
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
    }];
    
    //设置设备断开连接的委托
    [_babyBluethooth setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        DLog(@"设备：%@--断开连接",peripheral.name);
        //断开连接报警
        [[AccountStautsManager sharedInstance] disconnectBluetoothAlarm];
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
    
    //设置发现设备的Services的委托
    [_babyBluethooth setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services)
        {
            DLog(@"搜索到服务:%@",s.UUID.UUIDString);
            ///插入section到tableview
            //[weakSelf insertSectionToTableView:s];
        }
    }];
    //设置发现设service的Characteristics的委托
    [_babyBluethooth setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        //DLog(@"===service name:%@   string = %@",service.UUID,service.UUID.UUIDString);
        STRONGSELF
        
        //获取设备mac
//        if ([service.UUID.UUIDString isEqualToString:@"180A"])
//        {
//            for (CBCharacteristic *c in service.characteristics)
//            {
//                //DLog(@"180A uuid = %@  uuid string  = %@ de = %@",c.UUID,c.UUID.UUIDString,c.description);
//                NSString *cUUIDString = [c.UUID.UUIDString lowercaseString];
//                NSString *sysIdString = [@"2A23" lowercaseString];
//                
//                if ([cUUIDString isEqualToString:sysIdString])
//                {
//                    strongSelf->_babyBluethooth.channel(channelOnCharacteristicView).characteristicDetails(peripheral,c);
//                }
//            }
//            
//        }
        
        
        if ([service.UUID.UUIDString isEqualToString:@"1809"])
        {
            strongSelf->_currTemperatureService = service;
            
            for (CBCharacteristic *c in service.characteristics)
            {
                DLog(@"uuid = %@   de = %@",c.UUID,c.description);
            }
            
            [weakSelf setCurrTemperatureNotifiy];
        }
        //插入row到tableview
        //[weakSelf insertRowToTableView:service];
    }];
    //设置读取characteristics的委托
    [_babyBluethooth setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
        NSString *cUUIDString = [characteristics.UUID.UUIDString lowercaseString];
        NSString *sysIdString = [@"2A23" lowercaseString];
        
        if ([cUUIDString isEqualToString:sysIdString])
        {
            NSString *value = [NSString stringWithFormat:@"%@",characteristics.value];
            NSMutableString *macString = [[NSMutableString alloc] init];
            [macString appendString:[[value substringWithRange:NSMakeRange(16, 2)] uppercaseString]];
            [macString appendString:@":"];
            [macString appendString:[[value substringWithRange:NSMakeRange(14, 2)] uppercaseString]];
            [macString appendString:@":"];
            [macString appendString:[[value substringWithRange:NSMakeRange(12, 2)] uppercaseString]];
            [macString appendString:@":"];
            [macString appendString:[[value substringWithRange:NSMakeRange(5, 2)] uppercaseString]];
            [macString appendString:@":"];
            [macString appendString:[[value substringWithRange:NSMakeRange(3, 2)] uppercaseString]];
            [macString appendString:@":"];
            [macString appendString:[[value substringWithRange:NSMakeRange(1, 2)] uppercaseString]];
            
            STRONGSELF
            strongSelf->_macAdd = macString;
        }
    }];
    
    
    //设置读取Descriptor的委托
    [_babyBluethooth setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置发现characteristics的descriptors的委托
    [_babyBluethooth setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            //[weakSelf insertDescriptor:d];
        }
    }];
    
    [_babyBluethooth setBlockOnDidReadRSSIAtChannel:channelOnPeropheralView block:^(NSNumber *RSSI, NSError *error) {
        //DLog(@"change  rssi = %@",RSSI);
        STRONGSELF
        strongSelf->_rssi = [RSSI floatValue];
    }];
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [_babyBluethooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}

//当前温度通知
- (void)setCurrTemperatureNotifiy
{
    
    if(_currPeripheral.state != CBPeripheralStateConnected){
        //[SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    
    WEAKSELF
    for (CBCharacteristic *characteristic in _currTemperatureService.characteristics)
    {
        //DLog(@"uuid = %@   de = %@",characteristic.UUID,characteristic.description);
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"2A1C"])
        {
            if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate){
                
                if(characteristic.isNotifying)
                {
                    [_babyBluethooth cancelNotify:_currPeripheral characteristic:characteristic];
                }
                else
                {
                    [_currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                    
                    [_babyBluethooth notify:_currPeripheral
                             characteristic:characteristic
                                      block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                                          
                                          [weakSelf giveActualTimeValue:characteristics];
                                      }];
                }
            }
            else{
                //[SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
                return;
            }
        }
    }
}

//温度组通知
- (void)setTemperatureGroupNotifiy
{
    if(_currPeripheral.state != CBPeripheralStateConnected){
        //[SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    
    WEAKSELF
    for (CBCharacteristic *characteristic in _currTemperatureService.characteristics)
    {
        //DLog(@"uuid = %@   de = %@",characteristic.UUID,characteristic.description);
        
        if ([characteristic.UUID.UUIDString isEqualToString:@"FFF5"])
        {
            if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate){
                
                if(characteristic.isNotifying)
                {
                    [_babyBluethooth cancelNotify:_currPeripheral characteristic:characteristic];
                }
                else
                {
                    _hasGroupNotifiy = YES;
                    
                    [_currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                    
                    [_babyBluethooth notify:_currPeripheral
                             characteristic:characteristic
                                      block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                                          [weakSelf giveGroupTemperature:characteristics];
                                      }];
                }
            }
            else{
                //[SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限"];
                return;
            }
        }
    }
}

//返回实时温度
- (void)giveActualTimeValue:(CBCharacteristic*)characteristic
{
    if (_actualTimeValueCallBack)
    {
        CGFloat newTemperature = [BLEManager getTemperatureWithBLEData:characteristic.value];
        CGFloat newBettey = [BLEManager getBatteryWithBLEData:characteristic.value];
        _actualTimeValueCallBack(newTemperature,_rssi,newBettey);
        _hasReturnCurrTemp = YES;
        
        //保存数据，用于上传
        NSString *dateString = [self getToSeviserTimeStr:[NSDate date]];
        NSDictionary *tempDic = @{@"temp":[NSString stringWithFormat:@"%.1lf",newTemperature],
                                  @"date":dateString};
        [_currTempArray addObject:tempDic];
    }
}

//返回组别温度
- (void)giveGroupTemperature:(CBCharacteristic*)characteristic
{
    NSDictionary *dic = [BLEManager getCacheTemperatureDataWithBLEData:characteristic.value error:nil];
    //DLog(@"dic   =%@",dic);
    
    [_groupTemperatureDic addEntriesFromDictionary:dic];
    
    if ([dic isAbsoluteValid])
    {
        _groupIndex++;
        
        if (_is30Second)
        {
            //30秒的只能取6组
            if (_groupIndex > 6) {
                _groupIndex = 1;
            }
        }
        else
        {
            //5分钟的只需要取30组，一共100组
            if (_groupIndex > 30) {
                _groupIndex = 1;
            }
        }
        
        if (_groupIndex > 1)
        {
            [self startWriteGourpData];
        }
    }
    
    if (1 == _groupIndex)
    {
        if (_groupTemperatureCallBack) {
            _groupTemperatureCallBack(_groupTemperatureDic);
        }
    }
}

- (void)refreshRssi
{
    //有蓝牙返回的实时温度 以及有选中成员
    if (_hasReturnCurrTemp && [AccountStautsManager sharedInstance].nowUserItem)
    {
        _uploadIndex++;
        if (6 <= _uploadIndex) {
            _uploadIndex = 1;
            [self uploadRequest];
        }
    }
    [_currPeripheral readRSSI];
}

#pragma mark - 远程获取温度方法
- (NSString*)getToSeviserTimeStr:(NSDate*)date
{
    NSMutableString *dateString = [NSMutableString stringWithString:[NSDate stringFromDate:date withFormatter:DataFormatter_DateAndTime]];
    [dateString replaceCharactersInRange:NSMakeRange(10, 1) withString:@"/"];
    return dateString;
}

- (void)getRemoteTempBegin:(NSDate *)beginDate end:(NSDate *)endDate
{
    if (![AccountStautsManager sharedInstance].isLogin || ![AccountStautsManager sharedInstance].nowUserItem || !beginDate || !endDate)
    {
        return;
    }
    
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetTempRequestType_DownloadIntervalTemp] andArgsDic:nil];
    
    NSDictionary *dic = @{@"name":[AccountStautsManager sharedInstance].nowUserItem.userName,
                          @"begin":[self getToSeviserTimeStr:beginDate],
                          @"end":[self getToSeviserTimeStr:endDate]};
    NSDictionary *parameterDic = @{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":@[dic]};
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:parameterDic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetTempRequestType_DownloadIntervalTemp
                                           delegate:self
                                           userInfo:@{@"begin":beginDate,@"end":endDate}];
}

#pragma mark - request
- (void)uploadRequest
{
    if (_isUploadRequesting || ![_currTempArray isAbsoluteValid] || ![AccountStautsManager sharedInstance].nowUserItem || ![AccountStautsManager sharedInstance].isBluetoothType)
        return;
    
    _isUploadRequesting = YES;
    
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetTempRequestType_UploadTemp] andArgsDic:nil];
    
    NSArray *tempArray = _currTempArray;
    NSDictionary *dic = @{@"name":[AccountStautsManager sharedInstance].nowUserItem.userName,
                          @"tempList":tempArray};
    NSDictionary *parameterDic = @{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":@[dic]};
    
    _hasUploadIndex = _currTempArray.count - 1;
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:parameterDic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetTempRequestType_UploadTemp
                                           delegate:self
                                           userInfo:nil];
}

#pragma mark - NetRequest delegate
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (request.tag == NetTempRequestType_UploadTemp)
    {
        _isUploadRequesting = NO;
        
        //移除已经上传成功的数据
        for (NSInteger i=0; i<_hasUploadIndex; i++)
        {
            if ([_currTempArray isAbsoluteValid])
                [_currTempArray removeObjectAtIndex:0];
        }
    }
    else if (request.tag == NetTempRequestType_DownloadIntervalTemp)
    {
        if (infoObj && [infoObj isKindOfClass:[NSDictionary class]])
        {
            NSArray *memberArray = [[infoObj safeObjectForKey:@"user"] safeObjectForKey:@"memberList"];
            
            NSDate *beginDate = [request.userInfo safeObjectForKey:@"begin"];
            NSDate *endDate = [request.userInfo safeObjectForKey:@"end"];
            
            if ([memberArray isAbsoluteValid])
            {
                NSDictionary *firstDic = [memberArray firstObject];
                NSArray *tempArray = [firstDic safeObjectForKey:@"tempList"];
                if ([tempArray isAbsoluteValid])
                {
                    NSMutableArray *array = [NSMutableArray new];
                    for (NSDictionary *obj in tempArray)
                    {
                        RemoteTempItem *item = [RemoteTempItem initWithDict:obj];
                        [array addObject:item];
                    }
                    
                    //填充数据的数组
                    NSMutableArray *fillingArray = [NSMutableArray new];
                    /*
                    //做数据填充，填充到每秒一个数据，否则返回的数据
                    if ([array isAbsoluteValid])
                    {
                        NSTimeInterval interval = [endDate timeIntervalSinceDate:beginDate];
                        NSInteger arrayIndex = 0;
                        
                        
                        for (NSInteger i=0; i<(NSInteger)interval; i++)
                        {
                            NSDate *nextSencondDate = [beginDate dateByAddingSecond:i];
                            NSString *timeStr = [self getToSeviserTimeStr:nextSencondDate];
                            
                            if (array.count > arrayIndex)
                            {
                                RemoteTempItem *hasItem = [array objectAtIndex:arrayIndex];
                                if ([hasItem.time isEqualToString:timeStr])
                                {
                                    [fillingArray addObject:hasItem];
                                    arrayIndex++;
                                }
                                else
                                {
                                    RemoteTempItem *fillingItem = [[RemoteTempItem alloc] init];
                                    fillingItem.temp = 0;
                                    fillingItem.time = timeStr;
                                    [fillingArray addObject:fillingItem];
                                }
                            }
                            else
                            {
                                RemoteTempItem *fillingItem = [[RemoteTempItem alloc] init];
                                fillingItem.temp = 0;
                                fillingItem.time = timeStr;
                                [fillingArray addObject:fillingItem];
                            }
                        }
                    }
                     */
                
                    if (_remoteTempCallBack)
                    {
                        _remoteTempCallBack(array,fillingArray,beginDate,endDate);
                    }
                }
                else
                {
                    if (_remoteTempCallBack)
                    {
                        _remoteTempCallBack(nil,nil,beginDate,endDate);
                    }
                }
            }
            else
            {
                if (_remoteTempCallBack)
                {
                    _remoteTempCallBack(nil,nil,beginDate,endDate);
                }
            }
        }
    }
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    if (request.tag == NetTempRequestType_UploadTemp)
    {
        _isUploadRequesting = NO;
    }
    else if (request.tag == NetTempRequestType_DownloadIntervalTemp)
    {
        if (_remoteTempCallBack)
        {
            _remoteTempCallBack(nil,nil,
                                [request.userInfo safeObjectForKey:@"begin"],
                                [request.userInfo safeObjectForKey:@"end"]);
        }
    }
}

@end
