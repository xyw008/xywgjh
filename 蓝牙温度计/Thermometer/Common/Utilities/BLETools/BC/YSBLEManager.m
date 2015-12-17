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
#import "PRPAlertView.h"
#import "BaseNetworkViewController+NetRequestManager.h"

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

#define channelOnCharacteristicMacView @"CharacteristicMacView"


@interface YSBLEManager ()<NetRequestDelegate>
{
    
    NSString                    *_identifier;
    
    BabyBluetooth               *_babyBluethooth;
    NSDate                      *_startScanBluethoothDate;//开始扫描蓝牙时间
    
    
    NSString                    *_defaultMacAddrStr;//默认设备mac地址
    NSMutableArray              *_ysPeripheralArray;//搜索到的于氏温度设备
    NSInteger                   _currLinkIndex;//现在链接设备所在数组的index
    BOOL                        _isConnectPeripheraling;//连接per中
    BOOL                        _isShowAlerting;//显示提示状态
    BOOL                        _hasNotifiy;
    
    
    CBPeripheral                *_currPeripheral;//现在的外围设备
    CBService                   *_currTemperatureService;//现在的服务
    CBService                   *_macSerivce;//mac地址服务
    CBPeripheral                *_macPeripheral;//mac地址的外围设备
    
    
    BOOL                        _hasGroupNotifiy;//是否已经设置温度组的通知（defalut:NO）
    NSInteger                   _groupIndex;//取温度的组数从1开始(30秒 最大6，5分钟 最大30)
    NSMutableDictionary         *_groupTemperatureDic;//温度组
    BOOL                        _isFirstGetGroupTemp;//是否是第一次获取温度数据（用于判断是否是蓝牙缓存数据，决定是否上传）
    
    BOOL                        _isGetLastUploadTimeRequesting;//获取最后一个上传时间的请求
    NSDate                      *_nowUploadLastDate;//正在上传的最后一个温度的时间
    
    BOOL                        _isUploadRequesting;//数据上报状态
    BOOL                        _hasReturnCurrTemp;//有开始返回实时温度了
    NSMutableArray<BLECacheDataEntity*>  *_willUploadTempArray;//将要上传的温度数组
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
        
        _ysPeripheralArray = [NSMutableArray new];
        _currLinkIndex = 0;
        
        _groupIndex = 1;
        _hasGroupNotifiy = NO;
        _groupTemperatureDic = [[NSMutableDictionary alloc] init];
        _isFirstGetGroupTemp = YES;
        
        _willUploadTempArray = [NSMutableArray new];
//        _uploadIndex = 1;
        _isUploadRequesting = NO;
        _hasReturnCurrTemp = NO;
//        _currTempArray = [NSMutableArray new];
//        _currTempDateArray = [NSMutableArray new];
//        _hasUploadIndex = 0;
        
        _isFUnit = [[UserInfoModel getIsFUnit] boolValue];
        
        _defaultMacAddrStr = [UserInfoModel getDeviceMacAddr];
        _deviceIdentifier = [UserInfoModel getDeviceIdentifier];
    }
    return self;
}

- (void)initBluetoothInfo
{
    [_ysPeripheralArray removeAllObjects];
    _currPeripheral = nil;
    _hasGroupNotifiy = NO;
    _hasNotifiy = NO;
    _isShowAlerting = NO;
    _isConnectPeripheraling = NO;
    
    //初始化BabyBluetooth 蓝牙库
    _babyBluethooth = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self bluethoothDelegate];
    
}

- (void)startScanPeripherals
{
    if (_babyBluethooth == nil) {
        [self initBluetoothInfo];
    }
    
    _startScanBluethoothDate = [NSDate date];
    //停止之前的连接
    [_babyBluethooth cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    _babyBluethooth.scanForPeripherals().begin();
    
}

- (void)cancelAllPeripheralsConnection
{
    _groupIndex = 1;
    _hasGroupNotifiy = NO;
    _hasNotifiy = NO;
    
    _groupTemperatureDic = [[NSMutableDictionary alloc] init];
    _isFirstGetGroupTemp = YES;
    _lastUploadTempDate = nil;
    
    
    _willUploadTempArray = [NSMutableArray new];
    _isUploadRequesting = NO;
    _hasReturnCurrTemp = NO;
    
    [_babyBluethooth cancelAllPeripheralsConnection];
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
    
    //如果是第一次读取组数据，请求服务器获取最后一个上传的温度时间，来判定哪些缓存数据是否需要上传
    if (!_lastUploadTempDate) {
        //_lastUploadTempDate = nil;
        [self getDownloadLastestTemp];
    }
    
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
            //30s 和 5分钟类型数据
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

//链接外围设备
- (void)bluethoothchannelOnPeropheralView
{
    _isConnectPeripheraling = YES;
    
    _babyBluethooth.having(_currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
}


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
            if (![strongSelf->_ysPeripheralArray containsObject:peripheral]) {
                [strongSelf->_ysPeripheralArray addObject:peripheral];
            }
            
            if (strongSelf->_isConnectPeripheraling)
                return ;
            
            NSString *identifier = peripheral.identifier.UUIDString;
            
            //有默认地址
            if ([strongSelf->_deviceIdentifier isAbsoluteValid])
            {
                if ([identifier isEqualToString:strongSelf->_deviceIdentifier])
                {
                    strongSelf->_currPeripheral = peripheral;
                    strongSelf->_rssi = [RSSI floatValue];
                    strongSelf->_currLinkIndex = 0;
                    [strongSelf bluethoothchannelOnPeropheralView];
                    
                    [strongSelf->_babyBluethooth cancelScan];
                }
                else
                {
                    //没搜索到默认地址设备
                    NSInteger scanTime = [strongSelf->_startScanBluethoothDate timeIntervalSinceNow];
                    //扫描超过10秒
                    if (labs(scanTime) > 10)
                    {
                        strongSelf->_currPeripheral = peripheral;
                        strongSelf->_rssi = [RSSI floatValue];
                        strongSelf->_currLinkIndex = 0;
                        [strongSelf bluethoothchannelOnPeropheralView];
                        
                        strongSelf->_deviceIdentifier = identifier;
                        [UserInfoModel setUserDefaultDeviceIdentifier:identifier];
                        
                        [strongSelf->_babyBluethooth cancelScan];
                    }
                }
            }
            else
            {
                if (strongSelf->_isShowAlerting)
                {
                    
                }
                else
                {
                    strongSelf->_isShowAlerting = YES;
                    [PRPAlertView showWithTitle:nil message:@"搜索到温度计是否链接" cancelTitle:Cancel cancelBlock:^{
                        
                        strongSelf->_isShowAlerting = NO;
                        
                    } otherTitle:Confirm otherBlock:^{
                        
                        strongSelf->_isShowAlerting = NO;
                        
                        strongSelf->_currPeripheral = peripheral;
                        strongSelf->_rssi = [RSSI floatValue];
                        strongSelf->_currLinkIndex = 0;
                        [strongSelf bluethoothchannelOnPeropheralView];
                        strongSelf->_deviceIdentifier = identifier;
                        [UserInfoModel setUserDefaultDeviceIdentifier:identifier];
                        
                        [strongSelf->_babyBluethooth cancelScan];
                    }];
                }
            }
            
            //停止扫描
            /*
            [strongSelf->_babyBluethooth cancelScan];
            _babyBluethooth.having(_currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
            */
            

        }
    }];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [_babyBluethooth setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        DLog(@"连接成功");
        
        [[AccountStautsManager sharedInstance] cancelAlarmAlert];
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
        //[[AccountStautsManager sharedInstance] disconnectBluetoothAlarm];
        //[SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
    }];
    
    [_babyBluethooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        DLog(@"连接：%@--连接断开",peripheral.name);
        //断开连接报警
        //[[AccountStautsManager sharedInstance] disconnectBluetoothAlarm];
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
        
        if ([service.UUID.UUIDString isEqualToString:@"1809"])
        {
            strongSelf->_currTemperatureService = service;
            
            for (CBCharacteristic *c in service.characteristics)
            {
                DLog(@"uuid = %@   de = %@",c.UUID,c.description);
            }
            //[weakSelf getMacChannle];
            [weakSelf setCurrTemperatureNotifiy];
        }
        
        //获取设备mac
        if ([service.UUID.UUIDString isEqualToString:@"180A"])
        {
            strongSelf->_macSerivce = service;
            strongSelf->_macPeripheral = peripheral;
        }
        
        //获取设备mac
//        if ([service.UUID.UUIDString isEqualToString:@"180A"])
//        {
//            //获取蓝牙mac地址
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
//        }
        
        //插入row到tableview
        //[weakSelf insertRowToTableView:service];
    }];
    //设置读取characteristics的委托
    [_babyBluethooth setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//        STRONGSELF
//        if ([strongSelf->_macAdd isAbsoluteValid] || strongSelf->_hasNotifiy) {
//            return ;
//        }
        
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
            
            for (CBCharacteristic *c in strongSelf->_currTemperatureService.characteristics) {
                NSString *cUUIDString = [c.UUID.UUIDString lowercaseString];
                //fff3 2a1c fff5
                if ([cUUIDString isEqualToString:@"fff5"]) {
                    strongSelf->_babyBluethooth.channel(channelOnCharacteristicView).characteristicDetails(strongSelf->_currPeripheral,c);
                }
            }
            
            /*
            
            //如果有默认mac地址
            if ([strongSelf->_defaultMacAddrStr isAbsoluteValid])
            {
                //搜到默认地址设备直接链接
                if ([strongSelf->_defaultMacAddrStr isEqualToString:macString])
                {
                    strongSelf->_macAdd = macString;
                    [weakSelf setCurrTemperatureNotifiy];
                }
                else
                {
                    //没搜索到默认地址设备
                    NSInteger scanTime = [strongSelf->_startScanBluethoothDate timeIntervalSinceNow];
                    //扫描超过10秒
                    if (labs(scanTime) > 10)
                    {
                        [PRPAlertView showWithTitle:nil message:@"未搜到默认设备，发现新设备，是否链接" cancelTitle:Cancel cancelBlock:^{
                            
                            NSInteger perCount = strongSelf->_ysPeripheralArray.count;
                            //如果还有其他设备
                            if (perCount > 1)
                            {
                                //还有没有链接过得设备，继续链接获取mac地址判断
                                if (strongSelf->_currLinkIndex + 1 < perCount)
                                {
                                    strongSelf->_currLinkIndex ++;
                                    strongSelf->_currPeripheral = [strongSelf->_ysPeripheralArray objectAtIndex:strongSelf->_currLinkIndex];
                                    strongSelf->_isConnectPeripheraling = NO;
                                    [weakSelf bluethoothchannelOnPeropheralView];
                                }
                            }
                            else
                            {
                                strongSelf->_currPeripheral = nil;
                                strongSelf->_currLinkIndex = 0;
                                strongSelf->_isConnectPeripheraling = NO;
                            }
                            
                        } otherTitle:Confirm otherBlock:^{
                            strongSelf->_macAdd = macString;
                            [weakSelf setCurrTemperatureNotifiy];
                        }];
                    }
                    else
                    {
                        NSInteger perCount = strongSelf->_ysPeripheralArray.count;
                        
                        //如果还有其他设备
                        if (perCount > 1)
                        {
                            //还有没有链接过得设备，继续链接获取mac地址判断
                            if (strongSelf->_currLinkIndex + 1 < perCount)
                            {
                                strongSelf->_currLinkIndex ++;
                                strongSelf->_currPeripheral = [strongSelf->_ysPeripheralArray objectAtIndex:strongSelf->_currLinkIndex];
                                strongSelf->_isConnectPeripheraling = NO;
                                [weakSelf bluethoothchannelOnPeropheralView];
                            }
                        }
                        else
                        {
                            strongSelf->_macAdd = macString;
                            [weakSelf setCurrTemperatureNotifiy];
                        }
                    }
                }
            }
            else
            {
                strongSelf->_macAdd = macString;
                [weakSelf setCurrTemperatureNotifiy];
            }
             
             */
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

- (void)getMacChannle
{
    //获取蓝牙mac地址
    for (CBCharacteristic *c in _macSerivce.characteristics)
    {
        //DLog(@"180A uuid = %@  uuid string  = %@ de = %@",c.UUID,c.UUID.UUIDString,c.description);
        NSString *cUUIDString = [c.UUID.UUIDString lowercaseString];
        NSString *sysIdString = [@"2A23" lowercaseString];

        if ([cUUIDString isEqualToString:sysIdString])
        {
            _babyBluethooth.channel(channelOnCharacteristicView).characteristicDetails(_macPeripheral,c);
        }
    }
}

//当前温度通知
- (void)setCurrTemperatureNotifiy
{
    
    _hasNotifiy = YES;
    //停止扫描
    [_babyBluethooth cancelScan];
    
    //定时刷新rssi
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(refreshRssi) userInfo:nil repeats:YES];
    
    
    if ([_macAdd isAbsoluteValid]) {
        [UserInfoModel setUserDefaultDeviceMacAddr:_macAdd];
    }
    
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
    
    //切换到 读取mac地址的 per后，rssi 读取不到了 why
//    //获取蓝牙mac地址
//    for (CBCharacteristic *c in _macSerivce.characteristics)
//    {
//        //DLog(@"180A uuid = %@  uuid string  = %@ de = %@",c.UUID,c.UUID.UUIDString,c.description);
//        NSString *cUUIDString = [c.UUID.UUIDString lowercaseString];
//        NSString *sysIdString = [@"2A23" lowercaseString];
//        
//        if ([cUUIDString isEqualToString:sysIdString])
//        {
//            _babyBluethooth.channel(channelOnCharacteristicView).characteristicDetails(_macPeripheral,c);
//        }
//    }
}

//温度组 通知
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
        
//        NSDate *date = [NSDate date];
//        //保存数据，用于上传
//        NSString *dateString = [self getToSeviserTimeStr:date];
//        NSDictionary *tempDic = @{@"temp":[NSString stringWithFormat:@"%.1lf",newTemperature],
//                                  @"date":dateString};
//        [_currTempArray addObject:tempDic];
//        [_currTempDateArray addObject:date];
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
        //排序
        NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
        NSArray *keyArray = _groupTemperatureDic.allKeys;
        keyArray = [keyArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        for (NSInteger i=0; i< keyArray.count; i++)
        {
            NSArray *oneGroupItemArray = [_groupTemperatureDic safeObjectForKey:[keyArray objectAtIndex:i]];
            [dataArray addObjectsFromArray:oneGroupItemArray];
        }
        
        //没有上报需要做上报处理，只有30s 的数据才上报
        if (_is30Second)
        {
            [_willUploadTempArray addObjectsFromArray:dataArray];
            if (_lastUploadTempDate)
            {
                [self uploadRequest];
            }
            else
            {
                [self getDownloadLastestTemp];
            }
        }
        
        if (_groupTemperatureCallBack) {
            _groupTemperatureCallBack(_groupTemperatureDic,dataArray,_is30Second);
        }
    }
}

- (void)refreshRssi
{
    //有蓝牙返回的实时温度 以及有选中成员
//    if (_hasReturnCurrTemp && [AccountStautsManager sharedInstance].nowUserItem)
//    {
//        _uploadIndex++;
//        if (6 <= _uploadIndex) {
//            _uploadIndex = 1;
//            [self uploadRequest];
//        }
//    }
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
    if (_isUploadRequesting ||
        !_lastUploadTempDate ||
        ![_willUploadTempArray isAbsoluteValid] ||
        ![_willUploadTempArray isAbsoluteValid] ||
        ![AccountStautsManager sharedInstance].nowUserItem ||
        ![AccountStautsManager sharedInstance].isBluetoothType)
        return;
    
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    for (NSInteger i=0; i<_willUploadTempArray.count; i++)
    {
        BLECacheDataEntity *item = [_willUploadTempArray objectAtIndex:i];
        if ([item.date isLaterThanDate:_lastUploadTempDate])
        {
            if (_nowUploadLastDate)
            {
                //蓝牙返回的数据是从现在开往回退30分钟的
                if ([item.date isLaterThanDate:_nowUploadLastDate])
                {
                    _nowUploadLastDate = item.date;
                }
            }
            else
                _nowUploadLastDate = item.date;
            
            NSString *dateString = [self getToSeviserTimeStr:item.date];
            NSDictionary *tempDic = @{@"temp":[NSString stringWithFormat:@"%.1lf",item.temperature],
                                      @"date":dateString};
            [tempArray addObject:tempDic];
            //[tempArray addObject:item];
        }
    }
    
    //如果有未上传的温度
    if ([tempArray isAbsoluteValid])
    {
        _isUploadRequesting = YES;
        
        NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetTempRequestType_UploadTemp] andArgsDic:nil];
        
        NSDictionary *dic = @{@"name":[AccountStautsManager sharedInstance].nowUserItem.userName,
                              @"tempList":tempArray};
        NSDictionary *parameterDic = @{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":@[dic]};
        
        [[NetRequestManager sharedInstance] sendRequest:url
                                           parameterDic:parameterDic
                                      requestMethodType:RequestMethodType_POST
                                             requestTag:NetTempRequestType_UploadTemp
                                               delegate:self
                                               userInfo:nil];
    }
    else
    {
        [_willUploadTempArray removeAllObjects];
    }
}


//去服务器拿最后一次上传的数据，通过时间来判定后面获取的数据那些需要上传
- (void)getDownloadLastestTemp
{
    if (_isGetLastUploadTimeRequesting ||
        _lastUploadTempDate ||
        ![AccountStautsManager sharedInstance].isLogin ||
        ![AccountStautsManager sharedInstance].nowUserItem)
    {
        return;
    }
    
    _isGetLastUploadTimeRequesting = YES;
    
    
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetTempRequestType_DownloadLastestTemp] andArgsDic:nil];
    
    NSDictionary *memberDic = @{@"name":[AccountStautsManager sharedInstance].nowUserItem.userName};
    NSDictionary *dic = @{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":@[memberDic]};
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:dic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetTempRequestType_DownloadLastestTemp
                                           delegate:self
                                           userInfo:nil];

}



#pragma mark - NetRequest delegate
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    //上传温度数据
    if (request.tag == NetTempRequestType_UploadTemp)
    {
        _isUploadRequesting = NO;
        
        _lastUploadTempDate = _nowUploadLastDate;
        
        //移除已经上传成功的数据,保留未上传的温度数据
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSInteger i=0; i<_willUploadTempArray.count; i++)
        {
            BLECacheDataEntity *item = [_willUploadTempArray objectAtIndex:i];
            if ([item.date isLaterThanDate:_lastUploadTempDate])
            {
                [tempArray addObject:item];
            }
        }
        _willUploadTempArray = tempArray;
    }
    
    //服务器同步一段时间的数据
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
                        //没有超出这个时间的才需要
                        if ([item.date isEarlierThanDate:beginDate] && [item.date isEqualToDateIgnoringTime:endDate]) {
                            [array addObject:item];
                        }
                        [array addObject:item];
                    }
                    
                    if (_remoteTempCallBack)
                    {
                        _remoteTempCallBack(array,nil,beginDate,endDate);
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
    
    //服务器拿取最有一个上传的数据
    else if (request.tag == NetTempRequestType_DownloadLastestTemp)
    {
        NSArray *memberArray = [[infoObj safeObjectForKey:@"user"] safeObjectForKey:@"memberList"];
        
        if ([memberArray isAbsoluteValid])
        {
            NSDictionary *firstDic = [memberArray firstObject];
            NSArray *tempArray = [firstDic safeObjectForKey:@"tempList"];
            if ([tempArray isAbsoluteValid])
            {
                NSDictionary *firstTempDic = [tempArray firstObject];
                if ([firstTempDic isSafeObject])
                {
                    RemoteTempItem *item = [RemoteTempItem initWithDict:firstTempDic];
                    _lastUploadTempDate = item.date;
                }
                else
                {
                    NSDate *date = [NSDate date];
                    _lastUploadTempDate = [date dateBySubtractingMinutes:40];
                }
            }
            else
            {
                NSDate *date = [NSDate date];
                _lastUploadTempDate = [date dateBySubtractingMinutes:40];
            }
        }
        _isGetLastUploadTimeRequesting = NO;
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
    else if (request.tag == NetTempRequestType_DownloadLastestTemp)
    {
        _isGetLastUploadTimeRequesting = NO;
    }
}

@end
