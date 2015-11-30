//
//  AccountAndUserStautsManager.m
//  Thermometer
//
//  Created by leo on 15/11/29.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AccountStautsManager.h"
#import "UserInfoModel.h"

@implementation AccountStautsManager

DEF_SINGLETON(AccountStautsManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _highAndLowAlarm = [[UserInfoModel getHighAndLowTepmAlarm] boolValue];
        _disconnectAlarm = [[UserInfoModel getDisconnectAlarm] boolValue];
        _bellAlarm = [[UserInfoModel getBellAlarm] boolValue];
        _shakeAlarm = [[UserInfoModel getShakeAlarm] boolValue];
        
        NSNumber *highTemp = [UserInfoModel getHighTemp];
        NSNumber *lowTemp = [UserInfoModel getLowTemp];
        if (highTemp)
            _highTemp = [highTemp floatValue];
        else
            _highTemp = 37.9;
        
        if (lowTemp)
            _lowTemp = [lowTemp floatValue];
        else
            _lowTemp = 35.9;
        
        _bellMp3Name = [UserInfoModel getBellMp3Name];
        if (![_bellMp3Name isAbsoluteValid]) {
            self.bellMp3Name = @"beacon";
        }
    }
    return self;
}


- (void)setNowUserItem:(UserItem *)nowUserItem
{
    _nowUserItem = nowUserItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeNowUserNotificationKey object:nil];
}

#pragma mark - 报警相关
- (void)setHighAndLowAlarm:(BOOL)highAndLowAlarm
{
    _highAndLowAlarm = highAndLowAlarm;
    [UserInfoModel setUserDefaultHighAndLowTepmAlarm:@(_highAndLowAlarm)];
}

- (void)setDisconnectAlarm:(BOOL)disconnectAlarm
{
    _disconnectAlarm = disconnectAlarm;
    [UserInfoModel setUserDefaultDisconnectAlarm:@(_disconnectAlarm)];
}

- (void)setBellAlarm:(BOOL)bellAlarm
{
    _bellAlarm = bellAlarm;
    [UserInfoModel setUserDefaultBellAlarm:@(_bellAlarm)];
}

- (void)setShakeAlarm:(BOOL)shakeAlarm
{
    _shakeAlarm = shakeAlarm;
    [UserInfoModel setUserDefaultShakeAlarm:@(_shakeAlarm)];
}

- (void)setHighTemp:(CGFloat)highTemp
{
    _highTemp = highTemp;
    [UserInfoModel setUserDefaultHighTemp:@(_highTemp)];
}

- (void)setLowTemp:(CGFloat)lowTemp
{
    _lowTemp = lowTemp;
    [UserInfoModel setUserDefaultLowTemp:@(_lowTemp)];
}

- (void)setBellMp3Name:(NSString *)bellMp3Name
{
    if (bellMp3Name) {
        _bellMp3Name = bellMp3Name;
        [UserInfoModel setUserDefaultBellMp3Name:_bellMp3Name];
    }
}

@end
