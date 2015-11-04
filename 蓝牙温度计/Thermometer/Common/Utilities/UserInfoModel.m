//
//  UserInfoModel.m
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "UserInfoModel.h"

// 设置信息key值
#define UserDefault_EmailKey             @"userDefault_EmailKey"            // 用户邮箱
#define UserDefault_SessionKey           @"userDefault_SessionKey"          // 登录的会话
#define UserDefault_UserIdKey            @"userDefault_UserIdKey"           // 用户ID
#define UserDefault_LoginNameKey         @"userDefault_LoginNameKey"        // 用户登录名
#define UserDefault_UserNameKey          @"userDefault_UserNameKey"         // 用户名
#define UserDefault_PasswordKey          @"userDefault_PasswordKey"         // 登录密码
#define UserDefault_UserHeaderImgIdKey   @"userDefault_UserHeaderImgIdKey"  // 用户图像ID
#define UserDefault_UserHeaderImgDataKey @"userDefault_UserHeaderImgDataKey"// 用户图像
#define UserDefault_LastLoginDateKey     @"userDefault_LastLoginDateKey"    // 用户最近登录时间
#define UserDefault_AreaCommunityKey     @"userDefault_AreaCommunityKey"    // 用户所在小区
#define UserDefault_IsBindGovWebKey      @"userDefault_IsBindGovWebKey"     // 用户是否实名认证
#define UserDefault_IdCardKey            @"userDefault_IdCardKey"           // 用户实名认证后的身份证号
#define UserDefault_UserObjKey           @"userDefault_UserObjKey"          // 用户对象

#define UserDefault_Brightness_Device    @"userDefault_Brightness_Device"   // 设备屏幕亮度
#define UserDefault_Brightness_App       @"userDefault_Brightness_App"      // 设备屏幕亮度

// o2o
#define UserDefault_UserLoginTokenKey       @"userDefault_UserLoginTokenKey"    // 用户登陆成功后服务器返回的token
#define UserDefault_UserLoginToken_VKey     @"userDefault_UserLoginToken_VKey"  // 用户登陆成功后服务器返回的token(加密版)
#define UserDefault_UserSearchHistroyKey    @"userDefault_UserSearchHistroyKey" // 用户搜索记录
#define UserDefault_CookiesArrayKey         @"userDefault_CookiesArrayKey"      // HTTP响应cookies
#define UserDefault_DeviceTokenKey          @"userDefault_DeviceTokenKey"       // 用户注册通知成功后返回的token

@implementation UserInfoModel

DEF_SINGLETON(UserInfoModel);

+ (void)saveUserDefaultInfo
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setObject:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [self saveUserDefaultInfo];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - ///////////////////////////////////////////////////////

+ (void)setUserDefaultEmail:(NSString *)email
{
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:UserDefault_EmailKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultEmail
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_EmailKey];
}


+ (void)setUserDefaultSession:(NSString *)session
{
    [[NSUserDefaults standardUserDefaults] setObject:session forKey:UserDefault_SessionKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultSession
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_SessionKey];
}


+ (void)setUserDefaultUserId:(NSNumber *)userId
{
    [[NSUserDefaults standardUserDefaults] setObject:userId forKey:UserDefault_UserIdKey];
    [self saveUserDefaultInfo];
}

+ (NSNumber *)getUserDefaultUserId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserIdKey];
}


+ (void)setUserDefaultLoginName:(NSString *)loginName
{
    [[NSUserDefaults standardUserDefaults] setObject:loginName forKey:UserDefault_LoginNameKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultLoginName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_LoginNameKey];
}


+ (void)setUserDefaultUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:UserDefault_UserNameKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultUserName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserNameKey];
}


+ (void)setUserDefaultPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:UserDefault_PasswordKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_PasswordKey];
}


+ (void)setUserDefaultUserHeaderImgId:(NSNumber *)userHeaderImgId
{
    [[NSUserDefaults standardUserDefaults] setObject:userHeaderImgId forKey:UserDefault_UserHeaderImgIdKey];
    [self saveUserDefaultInfo];
}

+ (NSNumber *)getUserDefaultUserHeaderImgId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserHeaderImgIdKey];
}


+ (void)setUserDefaultUserHeaderImgData:(NSData *)userHeaderImgData
{
    [[NSUserDefaults standardUserDefaults] setObject:userHeaderImgData forKey:UserDefault_UserHeaderImgDataKey];
    [self saveUserDefaultInfo];
}

+ (NSData *)getUserDefaultUserHeaderImgData
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserHeaderImgDataKey];
}


+ (void)setUserDefaultLastLoginDate:(NSDate *)lastLoginDate
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginDate forKey:UserDefault_LastLoginDateKey];
    [self saveUserDefaultInfo];
}

+ (NSDate *)getUserDefaultLastLoginDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_LastLoginDateKey];
}


+ (void)setUserDefaultAreaCommunity:(NSString *)areaCommunity
{
    [[NSUserDefaults standardUserDefaults] setObject:areaCommunity forKey:UserDefault_AreaCommunityKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultAreaCommunity
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_AreaCommunityKey];
}

+ (void)setUserDefaultIsBindGovWeb:(NSNumber *)isBindGovWeb
{
    [[NSUserDefaults standardUserDefaults] setObject:isBindGovWeb forKey:UserDefault_IsBindGovWebKey];
    [self saveUserDefaultInfo];
}

+ (NSNumber *)getUserDefaultIsBindGovWeb
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_IsBindGovWebKey];
}

+ (void)setUserDefaultIdCard:(NSString *)idCard
{
    [[NSUserDefaults standardUserDefaults] setObject:idCard forKey:UserDefault_IdCardKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultIdCard
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_IdCardKey];
}

+ (void)setUserDefaultBrightness_Device:(CGFloat)brightness
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:brightness] forKey:UserDefault_Brightness_Device];
    [self saveUserDefaultInfo];
}

+ (CGFloat)getUserDefaultBrightness_Device
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_Brightness_Device] floatValue];
}

+ (void)setUserDefaultAppBrightness_App:(CGFloat)brightness;
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:brightness] forKey:UserDefault_Brightness_App];
    [self saveUserDefaultInfo];
}

+ (CGFloat)getUserDefaultBrightness_App
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_Brightness_App] floatValue];
}

+ (void)setUserObj:(NSDictionary *)userObj
{
    [[NSUserDefaults standardUserDefaults] setObject:userObj forKey:UserDefault_UserObjKey];
    
    [self setUserDefaultLoginName:[userObj objectForKey:@"loginName"]];
    [self setUserDefaultUserId:[userObj objectForKey:@"userId"]];
    [self setUserDefaultUserName:[userObj objectForKey:@"userName"]];
    [self setUserDefaultPassword:[userObj objectForKey:@"loginPswd"]];
    [self setUserDefaultEmail:[userObj objectForKey:@"email"]];
    [self setUserDefaultAreaCommunity:[userObj objectForKey:@"areaName"]];
    [self setUserDefaultLastLoginDate:[NSDate date]];
    [self setUserDefaultUserHeaderImgId:[userObj objectForKey:@"picId"]];
    [self setUserDefaultEmail:[userObj objectForKey:@"email"]];
    [self setUserDefaultIsBindGovWeb:[userObj objectForKey:@"hasBindGovWeb"]];
}

- (void)setIsLoadedThemeChoosePage:(BOOL)isLoadedThemeChoosePage
{
    [[NSUserDefaults standardUserDefaults] setObject:@(isLoadedThemeChoosePage) forKey:@"isLoadedThemeChoosePage"];
    [[self class] saveUserDefaultInfo];
}

- (BOOL)isLoadedThemeChoosePage
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoadedThemeChoosePage"] boolValue];
}

#pragma mark - ///////////////////////////////////////////////////////

+ (void)setUserDefaultLoginToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserDefault_UserLoginTokenKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultLoginToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserLoginTokenKey];
}

+ (void)setUserDefaultLoginToken_V:(NSString *)token_V
{
    [[NSUserDefaults standardUserDefaults] setObject:token_V forKey:UserDefault_UserLoginToken_VKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultLoginToken_V
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserLoginToken_VKey];
}

+ (NSDictionary *)getRequestHeader_TokenDic
{
    if ([[UserInfoModel getUserDefaultLoginToken] isAbsoluteValid] && [[UserInfoModel getUserDefaultLoginToken_V] isAbsoluteValid])
    {
        return @{@"Token": [UserInfoModel getUserDefaultLoginToken], @"TokenV": [UserInfoModel getUserDefaultLoginToken_V]};
    }
    else
    {
        return nil;
    }
}

+ (void)setUserDefaultSearchHistoryArray:(NSArray *)historyArray
{
    [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:UserDefault_UserSearchHistroyKey];
    [self saveUserDefaultInfo];
}

+ (NSArray*)getUserDefaultSearchHistoryArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_UserSearchHistroyKey];
}

+ (void)setUserDefaultCookiesArray:(NSArray *)cookies
{
    NSData *cookiesEncodedData = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    
    [[NSUserDefaults standardUserDefaults] setObject:cookiesEncodedData forKey:UserDefault_CookiesArrayKey];
    [self saveUserDefaultInfo];
}

+ (NSArray *)getUserDefaultCookiesArray
{
    NSData *unarchiverData = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_CookiesArrayKey];
    NSArray *cookiesArray = nil;
    if (unarchiverData)
    {
        cookiesArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiverData];
    }
    
    return cookiesArray;
}

+ (void)setUserDefaultDeviceToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserDefault_DeviceTokenKey];
    [self saveUserDefaultInfo];
}

+ (NSString *)getUserDefaultDeviceToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_DeviceTokenKey];
}

@end
