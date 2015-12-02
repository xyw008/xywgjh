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
#import <AVFoundation/AVFoundation.h>

@interface AccountStautsManager ()
{
    BOOL        _alarming;//警报状态
}

@end


@implementation AccountStautsManager

DEF_SINGLETON(AccountStautsManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uploadTempData = YES;
        
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
    //警报中
    if (_alarming)
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
        [[InterfaceHUDManager sharedInstance] showAlertWithTitle:@"报警提示" message:title alertShowType:AlertShowType_Informative cancelTitle:@"确定" cancelBlock:^(GJHAlertView *alertView, NSInteger index) {
            [[ATAudioPlayManager shardManager] stopAllAudio];
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            _alarming = NO;
        } otherTitle:nil otherBlock:nil];
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

@end
