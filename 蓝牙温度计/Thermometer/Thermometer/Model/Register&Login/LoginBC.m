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
#import "AccountStautsManager.h"

@interface LoginBC ()
{
    successHandle   _success;
    failedHandle    _failed;
    NSString        *_userName;
    NSString        *_password;
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
            _userName = userName;
            _password = password;
            
            if (show)
            {
                [HUDManager showHUDWithToShowStr:nil
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
                          userInteractionEnabled:NO];
            }
            
            // 登录操作
            NSString *methodNameStr = [BaseNetworkViewController getRequestURLStr:NetUserCenterRequestType_Login];
            NSURL *url = [UrlManager getRequestUrlByMethodName:methodNameStr];
            NSDictionary *dic = @{@"phone": userName,
                                  @"password": password};
            
//            NSString *dicJsonStr = [dic jsonStringByError:nil];
//            dicJsonStr = [NSString stringWithFormat:@"json=%@",dicJsonStr];
//            dicJsonStr = [dicJsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//            dicJsonStr = [dicJsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//            dicJsonStr = [dicJsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // NSDictionary *jsonDic = @{@"json":dicJsonStr};
            
            
            // url = [UrlManager getRequestUrlByMethodName:methodNameStr andArgsDic:jsonDic];
            
            //NSString *urlString = [NSString stringWithFormat:@"%@?%@",url.absoluteString,dicJsonStr];
            //urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //url = [NSURL URLWithString:urlString];
            
            [[NetRequestManager sharedInstance] sendRequest:url
                                               parameterDic:dic
                                          requestMethodType:RequestMethodType_POST
                                                 requestTag:NetUserCenterRequestType_Login
                                                   delegate:self
                                                   userInfo:nil];
        }
        else
        {
            // [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入密码"];
            [HUDManager showAutoHideHUDWithToShowStr:LocalizedStr(fill_error) HUDMode:MBProgressHUDModeText];
        }
    }
    else
    {
        // [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:@"请输入用户名"];
        [HUDManager showAutoHideHUDWithToShowStr:LocalizedStr(fill_error) HUDMode:MBProgressHUDModeText];
    }
}

/*
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
                [HUDManager showHUDWithToShowStr:nil
                                         HUDMode:MBProgressHUDModeIndeterminate
                                        autoHide:NO
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
 */

- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [HUDManager hideHUD];
    
    NSString *errMessage = nil;
    if (3 == error.code) {
        errMessage = LocalizedStr(phone_pw_error);
    } else if (2 == error.code) {
        errMessage = LocalizedStr(phone_no_exist);
    }
    
    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:errMessage];
    
    if (_failed)
    {
        _failed(error);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    
    [UserInfoModel setUserDefaultLoginName:_userName];
    [UserInfoModel setUserDefaultPassword:_password];
    
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotificationKey object:nil];
    
    if (_success)
    {
        [AccountStautsManager sharedInstance].isLogin = YES;
        _success(infoObj);
    }
}

@end
