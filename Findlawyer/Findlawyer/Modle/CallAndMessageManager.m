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

@interface CallAndMessageManager()

@property (nonatomic,copy)CallBlock         callBlock;
@property (nonatomic,copy)CallCancelBlock   cancelBlock;

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
                                                        CallAndMessageManager *manager1 = [CallAndMessageManager sharedInstance];
                                                        manager1.callBlock (duration);
                                                    }
                                                  cancel:^{
                                                      CallAndMessageManager *manager1 = [CallAndMessageManager sharedInstance];
                                                      manager1.cancelBlock ();
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
                 
//                    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
//                    vc.messageComposeDelegate = self;
//                    NSArray * array = @[number];
//                    vc.recipients = array;
//
//                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:^{
//                    }];
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

#pragma mark - judge method
- (BOOL)isRightMobile:(NSString *)mobile
{
    //^1[3|4|5|8][0-9]\d{4,8}$
    // NSString *regular = @"^1[3|4|5|8]\\d{9}$";
    //  NSString *regular = @"^(1[3|4|5|8]\\d{9})|(17[6|7|8]\\d{8})$";
    NSString *regular = @"^(1[3|4|5|8]\\d{9})|(17[6|7|8]\\d{8})$";
    
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"regular mobile error:%@",error);
        return NO;
    }
    else
    {
        NSInteger matches = [regularExpression numberOfMatchesInString:mobile options:0 range:NSMakeRange(0, [mobile length])];
        if (matches != 0)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - show Alert method

+ (void)showAlertErrorStr:(NSString*)error
{
    [[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
}


@end
