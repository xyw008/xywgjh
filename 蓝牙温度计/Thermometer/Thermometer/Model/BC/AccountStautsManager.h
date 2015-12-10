//
//  AccountAndUserStautsManager.h
//  Thermometer
//
//  Created by leo on 15/11/29.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEntity.h"

//校验手机结果通知
static NSString * const kCheckPhoneNumResultKey = @"kCheckPhoneNumResultKey";

//更换当前用户成功
static NSString * const kChangeNowUserNotificationKey = @"kChangeNowUserNotificationKey";


@interface AccountStautsManager : NSObject

@property (nonatomic,assign)BOOL        enterBackground;//是否进入后台

@property (nonatomic,assign)BOOL        isLogin;//登陆状态

@property (nonatomic,strong)UserItem    *nowUserItem;//现在选择的成员，如果为空则有可能没登陆，或则登陆后账号没有成员
@property (nonatomic,assign)BOOL        uploadTempData;//是否同步数据(defalut:YES)

@property (nonatomic,assign)BOOL        isBluetoothType;//是否是蓝牙模式

#pragma mark 报警相关
@property (nonatomic,assign)BOOL        highAndLowAlarm;//高低温报警开关
@property (nonatomic,assign)BOOL        disconnectAlarm;//断开报警开关
@property (nonatomic,assign)BOOL        bellAlarm;//报警铃声开关
@property (nonatomic,assign)BOOL        shakeAlarm;//报警震动开关
@property (nonatomic,assign)CGFloat     highTemp;//高温报警值
@property (nonatomic,assign)CGFloat     lowTemp;//低温报警值
@property (nonatomic,copy)NSString      *bellMp3Name;//报警铃声


AS_SINGLETON(AccountStautsManager);

//检测温度
- (void)checkTemp:(CGFloat)temp;

//断开蓝牙报警
- (void)disconnectBluetoothAlarm;

/**
 *  校验手机号码是否注册，通过通知返回
 */
- (void)checkPhoneNumRequest:(NSString*)phoneNum;

@end
