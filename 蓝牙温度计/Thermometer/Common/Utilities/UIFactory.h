//
//  UIFactory.h
//
//  Created by zzc on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PinYin4Objc.h"

@interface UIFactory : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

AS_SINGLETON(UIFactory);

#pragma mark - Common Function

+ (BOOL)isValidIPAddress:(NSString *)address;                   //校验IP
+ (BOOL)isValidPortAddress:(NSString *)address;                 //校验Port
+ (BOOL)isRetina;                                               //是否Retina屏
+ (float)getSystemVersion;                                      //获得系统版本

+ (NSString *)getDeviceTokenFromData:(NSData *)deviceToken;     //获取APNS设备令牌

+ (void)showAppCommentWithAppID:(int)appID;                     //显示AppStore应用评论
+ (void)invokeVibration;                                        //震动
+ (void)call:(NSString *)telephoneNum;                          //拨打电话
- (void)sendSMS:(NSString *)telephoneNum;                       //发送短信
- (void)sendEmail:(NSString *)emailAddr;                        //发送邮件
+ (void)openUrl:(NSString *)url;                                //打开网页

/// 本地通知
+ (BOOL)isRegisteredForLocalNotifications;
+ (BOOL)addLocalNotificationWithFireDate:(NSDate *)fireDate
                            alertBodyStr:(NSString *)alertBody
                          alertActionStr:(NSString *)alertAction;

/// 清空通知数字显示
+ (void)clearApplicationBadgeNumber;

/// 注册远程推送
+ (void)registerRemoteNotification;

/**
 @ 方法描述    汉字转换为拼音,且截取首个英文字母并过滤重复的字母,然后排序再按照首个字母把汉字归组(龚归为G组)
 @ 输入参数    CNStringArray: 要排序的中文数组 sortedFirstLetterArray: 转换为拼音并排好序的首字母数组
 sortedSectionNSStringDic: 排序并按首字母为key值分组存储的中文数组字典
 @ 返回值      Void
 @ 创建人      龚俊慧
 @ 创建时间    2014-11-10
 */
+(void)toHanyuPinyinStringWithCNStringArray:(NSArray *)CNStringArray
                     sortedFirstLetterArray:(NSMutableArray *__strong *)firstLetterArray
                   sortedSectionCNStringDic:(NSMutableDictionary *__strong *)sectionCNStringDic;

+ (NSStringEncoding)getGBKEncoding;                             //获得中文gbk编码

/*
+ (NSData *)useAES256Encrypt:(NSString *)plainText;             //加密
+ (NSString *)useAES256Decrypt:(NSData *)cipherData;            //解密
 */

@end
