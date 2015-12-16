//
//  UserInfoModel.h
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

AS_SINGLETON(UserInfoModel);

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setUserDefaultEmail:(NSString *)email;
+ (NSString *)getUserDefaultEmail;

+ (void)setUserDefaultSession:(NSString *)session;
+ (NSString *)getUserDefaultSession;

+ (void)setUserDefaultUserId:(NSNumber *)userId;
+ (NSNumber *)getUserDefaultUserId;

+ (void)setUserDefaultLoginName:(NSString *)loginName;
+ (NSString *)getUserDefaultLoginName;

+ (void)setUserDefaultUserName:(NSString *)userName;
+ (NSString *)getUserDefaultUserName;

+ (void)setUserDefaultPassword:(NSString *)password;
+ (NSString *)getUserDefaultPassword;

+ (void)setUserDefaultUserHeaderImgId:(NSNumber *)userHeaderImgId;
+ (NSNumber *)getUserDefaultUserHeaderImgId;

+ (void)setUserDefaultUserHeaderImgData:(NSData *)userHeaderImgData;
+ (NSData *)getUserDefaultUserHeaderImgData;

+ (void)setUserDefaultLastLoginDate:(NSDate *)lastLoginDate;
+ (NSDate *)getUserDefaultLastLoginDate;

+ (void)setUserDefaultAreaCommunity:(NSString *)areaCommunity;
+ (NSString *)getUserDefaultAreaCommunity;

+ (void)setUserDefaultIsBindGovWeb:(NSNumber *)isBindGovWeb;
+ (NSNumber *)getUserDefaultIsBindGovWeb;

+ (void)setUserDefaultIdCard:(NSString *)idCard;
+ (NSString *)getUserDefaultIdCard;

+ (void)setUserDefaultBrightness_Device:(CGFloat)brightness;
+ (CGFloat)getUserDefaultBrightness_Device;

+ (void)setUserDefaultAppBrightness_App:(CGFloat)brightness;
+ (CGFloat)getUserDefaultBrightness_App;

@property (nonatomic, assign) BOOL isLoadedThemeChoosePage; // 是否已经点击过换肤按钮

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setUserDefaultLoginToken:(NSString *)token;
+ (NSString *)getUserDefaultLoginToken;

+ (void)setUserDefaultLoginToken_V:(NSString *)token_V;
+ (NSString *)getUserDefaultLoginToken_V;

+ (NSDictionary *)getRequestHeader_TokenDic;

+ (void)setUserDefaultSearchHistoryArray:(NSArray*)historyArray;
+ (NSArray*)getUserDefaultSearchHistoryArray;

+ (void)setUserDefaultCookiesArray:(NSArray *)cookies;
+ (NSArray *)getUserDefaultCookiesArray;

+ (void)setUserDefaultDeviceToken:(NSString *)token;
+ (NSString *)getUserDefaultDeviceToken;


//第一次进入app
+ (void)setUserDefaultNoFirstGoApp:(NSNumber*)noFirstGoApp;
+ (NSNumber *)getNoFirstGoApp;


//选中了的成员id
+ (void)setUserDefaultSelectMemberId:(NSNumber*)selectMemberId;
+ (NSNumber *)getSelectMemberId;


//蓝牙设备mac地址
+ (void)setUserDefaultDeviceMacAddr:(NSString *)deviceMacAddr;
+ (NSString *)getDeviceMacAddr;


//温度显示模式是华氏还是摄氏(YES：F)
+ (void)setUserDefaultIsFUnit:(NSNumber*)isFUnit;
+ (NSNumber *)getIsFUnit;

//最后一次上传温度
+ (void)setUserDefaultLastUploadTempDate:(NSDate*)lastUploadTempDate;
+ (NSDate *)getLastUploadTempDate;



//高低温报警开关
+ (void)setUserDefaultHighAndLowTepmAlarm:(NSNumber*)highLowAlarm;
+ (NSNumber *)getHighAndLowTepmAlarm;

//断开报警开关
+ (void)setUserDefaultDisconnectAlarm:(NSNumber*)disconnectAlarm;
+ (NSNumber *)getDisconnectAlarm;

//报警铃声开关
+ (void)setUserDefaultBellAlarm:(NSNumber*)bellAlarm;
+ (NSNumber *)getBellAlarm;

//报警震动开关
+ (void)setUserDefaultShakeAlarm:(NSNumber*)shakeAlarm;
+ (NSNumber *)getShakeAlarm;

//高温报警值
+ (void)setUserDefaultHighTemp:(NSNumber*)highTemp;
+ (NSNumber *)getHighTemp;

//低温报警值
+ (void)setUserDefaultLowTemp:(NSNumber*)lowTemp;
+ (NSNumber *)getLowTemp;

//报警铃声名字
+ (void)setUserDefaultBellMp3Name:(NSString*)bellMp3Name;
+ (NSString *)getBellMp3Name;

//最后一次警告时间
+ (void)setUserDefaultLastAlarmDate:(NSDate*)lastAlarmDate;
+ (NSDate *)getLastAlarmDate;

//最后一次警告 后间隔时间
+ (void)setUserDefaultLastAlarmBetween:(NSNumber*)lastAlarmBetween;
+ (NSNumber *)getLastAlarmBetween;

@end
