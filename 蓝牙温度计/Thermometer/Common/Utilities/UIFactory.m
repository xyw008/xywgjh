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
#import "AppDelegate.h"

@implementation UIFactory

DEF_SINGLETON(UIFactory);

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
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)sendSMS:(NSString *)telephoneNum
{
    /*
    NSString *str = [NSString stringWithFormat:@"sms://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
    
    MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
    if (message)
    {
        message.modalTransitionStyle = UIModalPresentationFullScreen;
        message.messageComposeDelegate = self;
        message.subject = nil;
        message.body = nil;
        message.recipients = [NSArray arrayWithObjects:telephoneNum,nil];
        
        [SharedAppDelegate.window.rootViewController presentViewController:message animated:YES completion:nil];
    }
}

- (void)sendEmail:(NSString *)emailAddr
{
    /*
    NSString *str = [NSString stringWithFormat:@"mailto://%@", emailAddr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    if (mail)
    {
        mail.modalTransitionStyle = UIModalPresentationFullScreen;
        mail.mailComposeDelegate = self;
        [mail setSubject:nil];                  // 设置主题
        [mail setMessageBody:nil isHTML:YES];
        [mail setToRecipients:[NSArray arrayWithObjects:emailAddr,nil]]; // 设置收件人,可以设置多人
        
        [SharedAppDelegate.window.rootViewController presentViewController:mail animated:YES completion:nil];
    }
}

+ (void)openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (BOOL)isRegisteredForLocalNotifications
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        return [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
    }
    return YES;
}

+ (BOOL)addLocalNotificationWithFireDate:(NSDate *)fireDate alertBodyStr:(NSString *)alertBody alertActionStr:(NSString *)alertAction
{
    if ([self isRegisteredForLocalNotifications])
    {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = fireDate;
        localNotification.repeatInterval = 0;
        localNotification.timeZone = [NSTimeZone localTimeZone];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        /*
        localNotification.applicationIconBadgeNumber = 1;
         */
        localNotification.alertBody = alertBody;
        localNotification.alertAction = alertAction;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        return YES;
    }
    else
    {
        // iOS8以后本地通知也需要注册了,之前的系统版本只需要注册远程通知
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
        }
        return NO;
    }
}

// 清空通知数字显示
+ (void)clearApplicationBadgeNumber
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if (0 != application.applicationIconBadgeNumber)
    {
        application.applicationIconBadgeNumber = 0;
    }
    else
    {
        application.applicationIconBadgeNumber = 1;
        application.applicationIconBadgeNumber = 0;
    }
}

// 注册远程推送
+ (void)registerRemoteNotification
{
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

+ (void)toHanyuPinyinStringWithCNStringArray:(NSArray *)CNStringArray sortedFirstLetterArray:(NSMutableArray *__strong *)firstLetterArray sortedSectionCNStringDic:(NSMutableDictionary *__strong *)sectionCNStringDic
{
    if (![CNStringArray isAbsoluteValid]) return;
    
    if (!*firstLetterArray) *firstLetterArray = [NSMutableArray arrayWithCapacity:CNStringArray.count];
    if (!*sectionCNStringDic) *sectionCNStringDic = [NSMutableDictionary dictionaryWithCapacity:CNStringArray.count];
    
    const NSString *kPinyinKey = @"kPinyinKey";
    const NSString *kHanziKey = @"kHanziKey";
    
    NSMutableArray *tempPinyinAndHanziObjArray = [NSMutableArray arrayWithCapacity:CNStringArray.count]; // 包含拼音和汉字对象的数组(用以拿拼音给汉字排序)
    
    // 把中文转换为拼音
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeUppercase];
    
    // 获取首字母数组
    for (NSString *str in CNStringArray)
    {
        NSString *outputPinyin = [[PinyinHelper toHanyuPinyinStringWithNSString:str withHanyuPinyinOutputFormat:outputFormat withNSString:@""] uppercaseString];
        NSString *firstLetterStr = [outputPinyin substringToIndex:1];
        
        if ([firstLetterStr isAbsoluteValid] && ![*firstLetterArray containsObject:firstLetterStr])
        {
            [*firstLetterArray addObject:firstLetterStr];
        }
        
        // 配置拼音和汉字的对象数组
        [tempPinyinAndHanziObjArray addObject:@{kHanziKey : str, kPinyinKey : outputPinyin}];
    }
    
    // 排序首字母数组
    [*firstLetterArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    // 排序汉字
    [tempPinyinAndHanziObjArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        return [[obj1 objectForKey:kPinyinKey ] compare:[obj2 objectForKey:kPinyinKey] options:NSCaseInsensitiveSearch];
    }];
    
    // 获取分组存储的中文数组字典
    for (NSString *firstLetterItem in *firstLetterArray)
    {
        NSMutableArray *oneSectionArray = [NSMutableArray array];
        
        for (NSDictionary *pinyinAndHanziObjItem in tempPinyinAndHanziObjArray)
        {
            NSString *pinyinStr = [pinyinAndHanziObjItem objectForKey:kPinyinKey];
            NSString *hanziStr = [pinyinAndHanziObjItem objectForKey:kHanziKey];
            
            if ([pinyinStr hasPrefix:firstLetterItem])
            {
                [oneSectionArray addObject:hanziStr];
            }
        }
        
        [*sectionCNStringDic setObject:oneSectionArray forKey:firstLetterItem];
    }
}

+ (NSStringEncoding)getGBKEncoding
{
    
    //获得中文gbk编码
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
}

#pragma mark - MFMailComposeViewControllerDelegate & MFMessageComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:^{
        
    }];
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