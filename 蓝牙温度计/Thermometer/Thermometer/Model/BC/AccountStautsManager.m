//
//  AccountAndUserStautsManager.m
//  Thermometer
//
//  Created by leo on 15/11/29.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AccountStautsManager.h"
#import "UserInfoModel.h"
#import "ATAudioPlayManager.h"
#import "InterfaceHUDManager.h"
#import "LoginBC.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"

#import <AVFoundation/AVFoundation.h>

@interface AccountStautsManager ()<NetRequestDelegate>
{
    BOOL        _alarming;//警报状态
    NSDate      *_lastAlarmingTime;//最后一次提醒时间
    NSInteger   _betweenTime;//警报间隔时间
}

@end


@implementation AccountStautsManager

DEF_SINGLETON(AccountStautsManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uploadTempData = YES;
        
        if ([[UserInfoModel getUserDefaultLoginName] isAbsoluteValid]) {
            _isLogin = YES;
            
            //只要用户名就直接当做登陆处理
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationKey object:nil];
        }
        
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
        
        _lastAlarmingTime = [UserInfoModel getLastAlarmDate];
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


#pragma mark - 
- (void)checkTemp:(CGFloat)temp
{
    if (_highAndLowAlarm)
    {
        if (temp >= _highTemp)
        {
            [self startAlarm:@"高温警报"];
        }
        
        if (temp <= _lowTemp)
        {
            [self startAlarm:@"低温警报"];
        }
    }
}

- (void)disconnectBluetoothAlarm
{
    if (_disconnectAlarm)
    {
        [self startAlarm:@"设备已断开"];
    }
}

- (void)startAlarm:(NSString*)title
{
    if (!_isLogin) {
        return;
    }
    
    //警报中
    if (_alarming)
        return;
    
    DLog(@"before = %ld  lasttime = %@   now = %@",[_lastAlarmingTime minutesBeforeDate:[NSDate date]],_lastAlarmingTime,[NSDate date]);
    
    //离上次报警时间低于10分钟
    if (_lastAlarmingTime && [_lastAlarmingTime minutesBeforeDate:[NSDate date]] < _betweenTime)
        return;
    
    
    if (_bellAlarm)
    {
        NSString *name = [NSString stringWithFormat:@"%@.mp3",_bellMp3Name];
        [[ATAudioPlayManager shardManager] stopAudioDelegate:self];
        AVAudioPlayer *player = [[ATAudioPlayManager shardManager] playAudioNamed:name delegate:self tag:1000];
        player.numberOfLoops = 1000;
    }
    if (_shakeAlarm)
    {
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    if (_bellAlarm || _shakeAlarm)
    {
        _alarming = YES;
        _lastAlarmingTime = [NSDate date];
        [UserInfoModel setUserDefaultLastAlarmDate:_lastAlarmingTime];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"报警提示" message:@"报警提示" delegate:self cancelButtonTitle:nil otherButtonTitles:@"十分钟后再次提醒",@"二十分钟后再次提醒",@"三十分钟后再次提醒", nil];
        [alert show];
        
//        [[InterfaceHUDManager sharedInstance] showAlertWithTitle:@"报警提示" message:title alertShowType:AlertShowType_Informative cancelTitle:@"十分钟后再次提醒" cancelBlock:^(GJHAlertView *alertView, NSInteger index) {
//            [[ATAudioPlayManager shardManager] stopAllAudio];
//            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
//            _alarming = NO;
//            _lastAlarmingTime = [NSDate date];
//        } otherTitle:@"三十分钟后再次提醒" otherBlock:nil];
    }
}


//震动完成回调
void systemAudioCallback()
{
    //延时震动
    [NSTimer scheduledTimerWithTimeInterval:.8f target:[AccountStautsManager sharedInstance] selector:@selector(againShake) userInfo:nil repeats:NO];
}

- (void)againShake
{
    if (_alarming) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark -
- (void) audioPlayerManager:(ATAudioPlayManager*)manager finishPlayTag:(NSInteger)tag error:(NSError*)error
{
    if (_alarming)
    {
//        NSString *name = [NSString stringWithFormat:@"%@.mp3",_bellMp3Name];
//        [[ATAudioPlayManager shardManager] stopAudioDelegate:self];
//        [[ATAudioPlayManager shardManager] playAudioNamed:name delegate:self tag:1000];
    }
}


#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[ATAudioPlayManager shardManager] stopAllAudio];
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    _alarming = NO;
    _lastAlarmingTime = [NSDate date];
    if (buttonIndex == 0)
        _betweenTime = 10;
    else if (buttonIndex == 1)
        _betweenTime = 20;
    else if (buttonIndex == 2)
        _betweenTime = 30;
}


#pragma mark - request
- (void)checkPhoneNumRequest:(NSString *)phoneNum
{
    if (![phoneNum isAbsoluteValid]) {
        return;
    }
    NSString *baseUrl = [UrlManager getRequestNameSpace];
    NSString *addUrl = [[BaseNetworkViewController class] getRequestURLStr:NetUserRequestType_GetAllUserInfoNoImage];
    
    NSURL *url = [NSURL URLWithString:[UrlManager getImageRequestUrlStrByNameSpace:baseUrl urlComponent:addUrl]];
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:@{@"phone":phoneNum}
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:NetUserRequestType_GetAllUserInfoNoImage
                                           delegate:self
                                           userInfo:nil];
}

#pragma mark - NetRequest Delegate
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    BOOL hasRegister = NO;
    NSInteger result = [[infoObj safeObjectForKey:@"result"] integerValue];
    if (result != 2) {
        hasRegister = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckPhoneNumResultKey object:nil userInfo:@{@"hasRegister":@(hasRegister)}];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheckPhoneNumResultKey object:nil userInfo:@{@"hasRegister":@(NO)}];
    
    //    switch (request.tag)
    //    {
    //        case NetDeviceInfoRequestType_PostUserDevice:
    //
    //            break;
    //
    //        default:
    //            break;
    //    }
}

@end
