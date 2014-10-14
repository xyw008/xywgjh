//
//  UserInfoModel.h
//  zmt
//
//  Created by gongjunhui on 13-8-12.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

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

//////////////////////////////////////////////////////////////////////////////////////////

+ (void)setUserDefaultLoginToken:(NSString *)token;
+ (NSString *)getUserDefaultLoginToken;

+ (void)setUserDefaultLoginToken_V:(NSString *)token_V;
+ (NSString *)getUserDefaultLoginToken_V;

+ (NSDictionary *)getRequestHeader_TokenDic;

+ (void)setUserDefaultSearchHistoryArray:(NSArray*)historyArray;
+ (NSArray*)getUserDefaultSearchHistoryArray;


@end
