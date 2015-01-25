//
//  ExamineVersionBC.m
//  o2o
//
//  Created by leo on 14-9-16.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "ExamineVersionBC.h"
#import "InterfaceHUDManager.h"
#import "HUDManager.h"

@implementation ExamineVersionBC
{
    successHandle   _success;
    failedHandle    _failed;
    NSDictionary    *_appInfo;
    BOOL            _showHUD;//是否显示提示
}

- (id)init
{
    self = [super init];
    if (self) {
        _hasNewVersion = NO;
    }
    return self;
}

- (void)ExamineVersionRequestAutoShowHUD:(BOOL)show SuccessHandle:(successHandle)success failedHandle:(failedHandle)failed
{
    _success = success;
    _failed = failed;
    _showHUD = show;
    
    [HUDManager showHUDWithToShowStr:[LanguagesManager getStr:Version_LoadingShowKey] HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0.1 userInteractionEnabled:NO];
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=com.ejushang.o2o"];
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:nil requestMethodType:RequestMethodType_GET requestTag:1000 delegate:self userInfo:nil];
}


- (void)dealloc
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [HUDManager hideHUD];
    if (_showHUD) {
        [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:[LanguagesManager getStr:Version_NowNewVersionKey]];
    }
    _failed(error);
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    NSDictionary *appInfo = (NSDictionary*)infoObj;
    if ([appInfo isAbsoluteValid])
    {
        _appInfo = appInfo;
        _hasNewVersion = [self compareVersion];
        if (_showHUD)
        {
            if (_hasNewVersion)
            {
                [self showAlertChoiceUpdate];
            }
            else
            {
                [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:[LanguagesManager getStr:Version_NowNewVersionKey]];
            }
        }
    }
    _success(infoObj,_hasNewVersion);
}


#pragma mark - cutsom method
//比较版本
- (BOOL)compareVersion
{
    //iTunes返回版本
    NSString *latestVersion = [_appInfo objectForKey:@"version"];
    
    //当前版本
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    
    if ([currentVersion doubleValue] < [latestVersion doubleValue])
        return YES;
    
    return NO;
}

- (void)showAlertChoiceUpdate
{
    if ([self compareVersion])
    {
        [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil message:[LanguagesManager getStr:Password_PasswordModifyFailKey] alertShowType:AlertShowType_Informative cancelTitle:@"取消" cancelBlock:^(GJHAlertView *alertView, NSInteger index) {
            
        } otherTitle:@"马上升级" otherBlock:^(GJHAlertView *alertView, NSInteger index) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_appInfo objectForKey:@"trackViewUrl"]]];
        }];
    }
}

@end
