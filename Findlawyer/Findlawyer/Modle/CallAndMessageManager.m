//
//  CallBCManager.m
//  Find lawyer
//
//  Created by leo on 14-10-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "CallAndMessageManager.h"
#import "ACETelPrompt.h"
#import <MessageUI/MessageUI.h>
#import "StringJudgeManager.h"

@interface CallAndMessageManager()<MFMessageComposeViewControllerDelegate>

@property (nonatomic,copy)CallBlock         callBlock;
@property (nonatomic,copy)CallCancelBlock   cancelBlock;
@property (nonatomic,copy)MessageBloack     messageResultBlock;

@end

@implementation CallAndMessageManager


DEF_SINGLETON(CallAndMessageManager);

+ (void)callNumber:(NSString *)number call:(CallBlock)call callCancel:(CallCancelBlock)cancel
{
    CallAndMessageManager *manager = [CallAndMessageManager sharedInstance];
    manager.callBlock = call;
    manager.cancelBlock = cancel;
    
    if (number.length > 0)
    {
        if ([manager isRightMobile:number])
        {
            BOOL success = [ACETelPrompt callPhoneNumber:number
                                                    call:^(NSTimeInterval duration) {
                                                        [CallAndMessageManager sharedInstance].callBlock (duration);
                                                    }
                                                  cancel:^{
                                                        [CallAndMessageManager sharedInstance].cancelBlock ();
                                                  }];
            if (!success)
                [CallAndMessageManager showAlertErrorStr:@"号码无效，拨打失败"];
        }
        else
        {
            [CallAndMessageManager showAlertErrorStr:@"非法手机号"];
        }
    }
    else
    {
        [CallAndMessageManager showAlertErrorStr:@"号码为空，拨打失败"];
    }
}

+ (void)sendMessageNumber:(NSString *)number resultBlock:(MessageBloack)result
{
    [CallAndMessageManager sharedInstance].messageResultBlock = result;
    if (number.length > 0)
    {
        CallAndMessageManager *manager = [CallAndMessageManager sharedInstance];
        if([manager isRightMobile:number])
        {
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            if (messageClass != nil)
            {
                if ([MFMessageComposeViewController canSendText])
                {
                    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                    vc.messageComposeDelegate = [CallAndMessageManager sharedInstance];
                    NSArray * array = @[number];
                    vc.recipients = array;
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
                    }];
                }
                else
                    [CallAndMessageManager showAlertErrorStr:@"抱歉！该设备不支持发送短信的功能"];
            }
            else
                [CallAndMessageManager showAlertErrorStr:@"抱歉！发送失败"];
        }
        else
            [CallAndMessageManager showAlertErrorStr:@"非法手机号"];
    }
    else
        [CallAndMessageManager showAlertErrorStr:@"号码为空!"];
}


#pragma mark - judge method
- (BOOL)isRightMobile:(NSString *)mobile
{
    if ([StringJudgeManager isValidateStr:mobile regexStr:MobilePhoneNumRegex])
        return YES;
    
    if ([StringJudgeManager isValidateStr:mobile regexStr:PhoneNumRegex])
        return YES;
    
    return NO;
    
    /*
    if ([StringJudgeManager isValidateStr:@"95599" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"400-800-0333" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"400-8003-033" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"0755-77777777" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"0755-7777777" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"002-77777777" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"002-7777777" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    if ([StringJudgeManager isValidateStr:@"18688897808" regexStr:PhoneNumRegex])
    {
        DLog(@"sdf");
    }
    */
}


#pragma mark - Message compose view controller delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    CallAndMessageManager *manager = [CallAndMessageManager sharedInstance];
    if (result == MessageComposeResultCancelled)
    {
        manager.messageResultBlock (MessageSendResultType_Cancelled);
    }
    else if (result == MessageComposeResultSent)
    {
        manager.messageResultBlock (MessageSendResultType_Success);
    }
    else
    {
        manager.messageResultBlock (MessageSendResultType_Failed);
    }
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - show Alert method

+ (void)showAlertErrorStr:(NSString*)error
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}



/*
+ (BOOL)judgeSendMessageNumber:(NSString *)number
{
    if (number.length > 0)
    {
        CallAndMessageManager *manager = [CallAndMessageManager sharedInstance];
        if([manager isRightMobile:number])
        {
            Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
            if (messageClass != nil)
            {
                if ([MFMessageComposeViewController canSendText])
                {
                    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                    vc.messageComposeDelegate = [CallAndMessageManager sharedInstance];
                    NSArray * array = @[number];
                    vc.recipients = array;
                    
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
                    }];
                    return YES;
                }
                else
                {
                    [CallAndMessageManager showAlertErrorStr:@"抱歉！该设备不支持发送短信的功能"];
                    return NO;
                }
            }
            else
            {
                [CallAndMessageManager showAlertErrorStr:@"抱歉！发送失败"];
                return NO;
            }
        }
        else
        {
            [CallAndMessageManager showAlertErrorStr:@"非法手机号"];
            return NO;
        }
    }
    else
    {
        [CallAndMessageManager showAlertErrorStr:@"号码为空!"];
        return NO;
    }
}
*/

@end
