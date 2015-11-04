//
//  LoginBC.m
//  o2o
//
//  Created by leo on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "LoginBC.h"
#import "HUDManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "UrlManager.h"
#import "InterfaceHUDManager.h"

@interface LoginBC ()
{
    successHandle   _success;
    failedHandle    _failed;
}

@end

@implementation LoginBC

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password autoLogin:(BOOL)autoLogin showHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([userName isAbsoluteValid])
    {
        if ([password isAbsoluteValid] && password.length >= 6 && password.length <= 16)
        {
            _success = success;
            _failed = failed;
            
            if (show)
            {
                [HUDManager showHUDWithToShowStr:LocalizedStr(Login_LoadingShowInfoKey)
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                                      afterDelay:0
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Login];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            NSDictionary *dic = @{@"username": userName,
                                  @"password": password,
                                  @"rememberMe": (autoLogin ? @"on" : @"")};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:NetUserCenterRequestType_Login
                                                   delegate:self
                                                   userInfo:nil];
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

- (void)dynamicLoginWithUserName:(NSString *)userName verificationCode:(NSString *)code autoLogin:(BOOL)autoLogin showHUD:(BOOL)show successHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    if ([userName isAbsoluteValid])
    {
        if ([code isAbsoluteValid])
        {
            _success = success;
            _failed = failed;
            
            if (show)
            {
                [HUDManager showHUDWithToShowStr:LocalizedStr(Login_LoadingShowInfoKey)
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                                      afterDelay:0
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:88];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            NSDictionary *dic = @{@"username": userName,
                                  @"checkCode": code,
                                  @"rememberMe": (autoLogin ? @"on" : @"")};
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:88
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
    [HUDManager hideHUD];
    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:error.localizedDescription];
    
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationKey object:nil];
    
    if (_success)
    {
        _success(infoObj);
    }
}

@end
