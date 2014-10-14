//
//  UIFactory.m
//
//  Created by zzc on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import "UIFactory.h"
#import "Reachability.h"
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation UIFactory

#pragma mark - Check IP/Port

+ (BOOL)isValidIPAddress:(NSString *)address
{
    if ([address length] < 1)
        return NO;
    
    struct in_addr addr;
    return (inet_aton([address UTF8String], &addr) == 1);
}

+ (BOOL)isValidPortAddress:(NSString *)address
{
    
    if ([address length] < 1)
        return NO;
    
    NSScanner * scanner = [NSScanner scannerWithString:address];
    if ([scanner scanInt:nil] && [scanner isAtEnd]) {
        return (1 <= [address integerValue]) && ([address integerValue] <= 255);
    }
    
    return NO;
    
}

#pragma mark  Common utilities

+ (BOOL)isRetina
{
    int scale = 1.0;
    UIScreen *screen = [UIScreen mainScreen];
    if ([screen respondsToSelector:@selector(scale)]) {
        scale = screen.scale;
    }
    if (scale == 2.0f) {
        return YES;
    }
    return NO;
}


+(float)getSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}


+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken
{
    //获取APNS设备令牌
    NSMutableString * deviceTokenStr = [NSMutableString stringWithFormat:@"%@",deviceToken];
    NSRange allRang;
    allRang.location    = 0;
    allRang.length      = deviceTokenStr.length;
    
    [deviceTokenStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:allRang];
    
    NSRange begin   = [deviceTokenStr rangeOfString:@"<"];
    NSRange end     = [deviceTokenStr rangeOfString:@">"];
    
    NSRange deviceRange;
    deviceRange.location    = begin.location + 1;
    deviceRange.length      = end.location - begin.location -1;
    
    return [deviceTokenStr substringWithRange:deviceRange];
}


+(void)invokeVibration
{
    // TODO: 振动调用
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+(void)showAppCommentWithAppID:(int)appID
{
    // 显示AppStore应用评论
    /*
    NSString *appUrlStr = [NSString stringWithFormat:kAPPCommentUrl, appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrlStr]];
     */
    
}

+ (void)call:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"tel://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendSMS:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"sms://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendEmail:(NSString *)emailAddr
{
    NSString *str = [NSString stringWithFormat:@"mailto://%@", emailAddr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSStringEncoding)getGBKEncoding
{
    
    //获得中文gbk编码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
    
}

/*
#pragma mark --加密解密

#define kAES256EncryptKey @"opqrstuvwxyzabcdefghijklmn"

// 加密
+ (NSData *)useAES256Encrypt:(NSString *)plainText
{
    NSData *res = nil;
    if (plainText) {
        NSData *plainData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        res = [plainData AES256EncryptWithKey:kAES256EncryptKey];
    }
    return res;
}

// 解密
+ (NSString *)useAES256Decrypt:(NSData *)cipherData
{
    NSString *res = nil;
    if ((cipherData != nil) && ([cipherData length] > 0)) {
        NSData *plainData = [cipherData AES256DecryptWithKey:kAES256EncryptKey];
        res = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    return res;
}
*/

@end