//
//  RegisterBC.m
//  o2o
//
//  Created by swift on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "RegisterBC.h"
#import "HUDManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"
#import "StringJudgeManager.h"
#import "InterfaceHUDManager.h"

@interface RegisterBC ()
{
    successHandle   _success;
    failedHandle    _failed;
}

@end

@implementation RegisterBC

- (void)getVerificationCodeWithMobilePhoneNumber:(NSString *)phoneNumber successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:phoneNumber regexStr:MobilePhoneNumRegex])
    {
        _success = success;
        _failed = failed;
        
        NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:0];
        NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
        NSDictionary *dic = @{@"username": phoneNumber};
        
        [[NetRequestManager sharedInstance] sendRequest:url
                                           parameterDic:dic
                                      requestMethodType:RequestMethodType_POST
                                             requestTag:0
                                               delegate:self
                                               userInfo:nil];
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入手机号码"];
    }
}

- (void)registerWithMobilePhoneUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm verificationCode:(NSString *)verificationCode successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:userName regexStr:MobilePhoneNumRegex])
    {
        if ([password isAbsoluteValid] && password.length >= 6 && password.length <= 16)
        {
            if ([passwordConfirm isAbsoluteValid] && passwordConfirm.length >= 6 && passwordConfirm.length <= 16)
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    if ([verificationCode isAbsoluteValid])
                    {
                        _success = success;
                        _failed = failed;
                        
                        // 进行注册操作
                        NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                        NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                        NSDictionary *dic = @{@"username": userName, @"password": password, @"checkCode": verificationCode};
                        
                        [[NetRequestManager sharedInstance] sendRequest:url
                                                           parameterDic:dic
                                                      requestMethodType:RequestMethodType_POST
                                                             requestTag:NetUserCenterRequestType_Register
                                                               delegate:self
                                                               userInfo:nil];
                    }
                    else
                    {
                        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入验证码"];
                    }
                }
                else
                {
                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"2次密码输入不一致"];
                }
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请再次输入密码"];
            }
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入密码"];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入手机号码"];
    }
}

- (void)registerWithEmailUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([StringJudgeManager isValidateStr:userName regexStr:EmailRegex])
    {
        if ([password isAbsoluteValid] && password.length >= 6 && password.length <= 16)
        {
            if ([passwordConfirm isAbsoluteValid] && passwordConfirm.length >= 6 && passwordConfirm.length <= 16)
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    _success = success;
                    _failed = failed;
                    
                    // 进行注册操作
                    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                    NSDictionary *dic = @{@"username": userName,
                                          @"password": password};
                    
                    [[NetRequestManager sharedInstance] sendRequest:url
                                                       parameterDic:dic
                                                  requestMethodType:RequestMethodType_POST
                                                         requestTag:NetUserCenterRequestType_Register
                                                           delegate:self
                                                           userInfo:nil];
            
                }
                else
                {
                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"2次密码输入不一致"];
                }
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请再次输入密码"];
            }
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入密码"];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入邮箱"];
    }
}

- (void)registerWithNormalUserName:(NSString *)userName password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([userName isAbsoluteValid])
    {
        if ([password isAbsoluteValid] && password.length >= 6 && password.length <= 16)
        {
            if ([passwordConfirm isAbsoluteValid] && passwordConfirm.length >= 6 && passwordConfirm.length <= 16)
            {
                if ([password isEqualToString:passwordConfirm])
                {
                    _success = success;
                    _failed = failed;
                    
                    // 进行注册操作
                    NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Register];
                    NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
                    NSDictionary *dic = @{@"username": userName,
                                          @"password": password};
                    
                    [[NetRequestManager sharedInstance] sendRequest:url
                                                       parameterDic:dic
                                                  requestMethodType:RequestMethodType_POST
                                                         requestTag:NetUserCenterRequestType_Register
                                                           delegate:self
                                                           userInfo:nil];
                    
                }
                else
                {
                    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"2次密码输入不一致"];
                }
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请再次输入密码"];
            }
        }
        else
        {
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入密码"];
        }
    }
    else
    {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入用户名"];
    }
}

- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:error.localizedDescription];
    
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    if (_success)
    {
        _success(infoObj);
    }
}

@end
