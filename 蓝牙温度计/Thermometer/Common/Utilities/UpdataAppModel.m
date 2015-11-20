//
//  UpdataAppModel.m
//  zmt
//
//  Created by ygsoft on 13-8-25.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "UpdataAppModel.h"
#import "HUDManager.h"
#import "UrlManager.h"
#import "NetworkStatusManager.h"

//设置下载地址
#define downloadUrlString @"/ios/zmt.html"

//定义tag值
#define UpdataAppRequestTag 100
#define DownloadAppRequestTag 200

UpdataAppModel *staticShareUpdataAppModel;
/// 当前版本
static NSString *currentVersion;
/// appStore的升级地址
static NSString *updateUrlStr;

@implementation UpdataAppModel

+ (void)updataAppVersion
{
    [self getNetworkData];
}

#pragma mark - NetRequestDelegate Methods

//请求网络数据
+ (void)getNetworkData
{
    if ([NetworkStatusManager getNetworkStatus] == NotReachable)
    {
        [HUDManager showHUDWithToShowStr:NoConnectionNetwork HUDMode:MBProgressHUDModeCustomView autoHide:YES userInteractionEnabled:YES showType:HUDOperationFailed];
        return;
    }
    //传参 1个参数
    NSMutableDictionary *updataAppDict = [NSMutableDictionary dictionary];
    //参数1 类型（android,ios）
    [updataAppDict setObject:@"ios" forKey:@"type"];
    //网络请求 检查新版本
    NSURL *updataAppUrl = [UrlManager getRequestUrlByMethodName:@"com.ygsoft.omc.base.service.SystemUpgradeService/getSystemUpgradeByType"];
    [[NetRequestManager sharedInstance] sendRequest:updataAppUrl parameterDic:updataAppDict requestTag:UpdataAppRequestTag delegate:self userInfo:nil];
}

+ (void)netRequestDidStarted:(NetRequest *)request
{
    if (request.tag == UpdataAppRequestTag)
    {
        [HUDManager showHUDWithToShowStr:@"版本更新检查中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO userInteractionEnabled:YES showType:HUDOthers];
    }
    else if (request.tag == DownloadAppRequestTag)
    {
        [HUDManager showHUDWithToShowStr:@"版本更新中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO userInteractionEnabled:YES showType:HUDOthers];
    }
}

//发生请求成功时
+ (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [HUDManager hideHUD];
    
    //解析数据
    if (request.tag == UpdataAppRequestTag)
    {
        if ([infoObj isKindOfClass:[NSDictionary class]])
        {
            
            //dataVersion = "1.0";
            //downloadUrl = "http://10.51.108.1:8080/omc/apk/omc.apk";
            //forcedUpgrade = 0;
            //id = 00000000004;
            //requestUrl = "http://omc.ygsoft.net/omc/";
            //status = Y;
            //type = ios;
            
            //最新版本号
            NSString *lastVersionString = [NSString stringWithFormat:@"%@",[(NSDictionary *)infoObj objectForKey:@"dataVersion"]];
            BOOL isUpdataApp = [self updataApp:lastVersionString];
            [self showUpdataAppAlertView:isUpdataApp];
        }
    }
    else
    {
        [HUDManager showHUDWithToShowStr:@"版本更新成功!" HUDMode:MBProgressHUDModeCustomView autoHide:YES userInteractionEnabled:YES showType:HUDOperationSuccess];
    }
}

//发送请求失败时
+ (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [HUDManager hideHUD];
    [HUDManager showHUDWithToShowStr:@"版本更新检查失败..." HUDMode:MBProgressHUDModeCustomView autoHide:YES userInteractionEnabled:YES showType:HUDOperationFailed];
}

#pragma mark - 判断是否有更新

+ (BOOL)updataApp:(NSString *)lastVersion
{
    //当前版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //最新版本号
    double currentAppVersionNum = [currentAppVersion doubleValue];
    double lastAppVersionNum = [lastVersion doubleValue];
    if (currentAppVersionNum >=lastAppVersionNum)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - UIAlertViewDelegate

+ (void)showUpdataAppAlertView:(BOOL)isupdata
{
    if (!isupdata)
    {
        [self showAlert:AlertTitle message:@"当前版本为最新版本!" delegate:nil cancelBtn:Confirm confimButton:nil];
    }
    else
    {
        [self showAlert:AlertTitle message:@"发现新版本,是否进行更新" delegate:self cancelBtn:Confirm confimButton:Cancel];
    }
}

+ (void)showAlert:(NSString *)titleString message:(NSString *)messageString delegate:(id)delegate cancelBtn:(NSString *)CancelString confimButton:(NSString *)ConfirmString
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:messageString
                                                       delegate:delegate
                                              cancelButtonTitle:CancelString
                                              otherButtonTitles:ConfirmString, nil];
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSURL *downloadLastVersionRequestURl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Img_NameSpace,downloadUrlString]];
            [[UIApplication sharedApplication] openURL:downloadLastVersionRequestURl];
            
        }
            break;
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
}

///////////////////////////////////////////////////////////////////////////////////

+ (UpdataAppModel *)shareUpdataAppModel
{
    if(nil == staticShareUpdataAppModel)
    {
        staticShareUpdataAppModel = [[UpdataAppModel alloc] init];
    }
    return staticShareUpdataAppModel;
}

- (void)updateAppVersionWithAppID:(NSString *)appID
{
    if ([NetworkStatusManager getNetworkStatus] == NotReachable)
        return;
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//    CFShow(infoDic);
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];//获得发布version信息
    
//    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];//获得build版本信息
//    NSLog(@"version = %@",appVersion);
    currentVersion = appVersion;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appID]];
    ASIFormDataRequest *versionRequest = [ASIFormDataRequest requestWithURL:url];
    [versionRequest setDelegate:self];
    [versionRequest setTimeOutSeconds:150];
    [versionRequest setDidFailSelector:@selector(versionRequestDidFailed:)];
    [versionRequest setDidFinishSelector:@selector(versionRequestDidSuccess:)];
    [versionRequest startAsynchronous];
}

// 发送请求失败时
- (void)versionRequestDidFailed:(ASIFormDataRequest *)request
{
    
}

// 发生请求成功时
- (void)versionRequestDidSuccess:(ASIFormDataRequest *)request
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:NULL];
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    
    if (infoArray && 0 != [infoArray count])
    {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion])
        {
            updateUrlStr = [releaseInfo objectForKey:@"trackViewUrl"];
            
            SimpleAlert(UIAlertViewStyleDefault, @"更新", @"有新的版本啦,是否前往更新?", 1000, self, Cancel, @"更新");
        }
        else
          SimpleAlert(UIAlertViewStyleDefault, @"更新", @"当前版本为最新版本!", 1001, nil, nil, Confirm);
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:@"更新"])
    {
        NSURL *url = [NSURL URLWithString:updateUrlStr];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
