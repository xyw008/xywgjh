//
//  BaseNetworkViewController.m
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"

@interface BaseNetworkViewController ()
{
    UIImageView *netBackgroundStatusImgView;
}

@end

@implementation BaseNetworkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 该地方一定要注意block引起的retain cycle
        __weak BaseNetworkViewController *weakSelf = self;
        
        self.noNetworkBlock = ^{
            
            BaseNetworkViewController *strongSelf = weakSelf;
            if (strongSelf)
            {
                // 给主view赋值状态背景图(无网络连接)
                [strongSelf setNoNetworkConnectionStatusView];
            }
        };
        
        self.startedBlock = ^(NetRequest *request)
        {
            [weakSelf showHUDInfoByType:HUDInfoType_Loading];
        };
        
        self.failedBlock = ^(NetRequest *request, NSError *error)
        {
            if (error.code == MyHTTPCodeType_DataSourceNotFound)
            {
                [weakSelf showHUDInfoByString:[LanguagesManager getStr:All_DataSourceNotFoundKey]];
            }
            else
            {
//                [weakSelf showHUDInfoByType:HUDInfoType_Failed];
                
                if (error.localizedDescription)
                {
                    [weakSelf showHUDInfoByString:error.localizedDescription];
                }
                else
                {
                    [weakSelf showHUDInfoByString:OperationFailure];
                    
                    // 给主view赋值状态背景图(点击重新刷新的图)
                    [weakSelf setLoadFailureStatusView];
                }

            }
        };
    }
    return self;
}

- (void)dealloc
{
    [self clearDelegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置网络请求中每个阶段需要执行的代码块
    [self setNetworkRequestStatusBlocks];
    /*
    // 请求网络数据
    [self getNetworkData];
     */
}

#pragma mark - 设置网络背景状态图

// 设置网络背景状态图
- (void)setNetworkStatusViewByImage:(UIImage *)image userInteractionEnabled:(BOOL)yesOrNo
{
    if (!netBackgroundStatusImgView)
    {
        netBackgroundStatusImgView = InsertImageView(self.view, self.view.bounds, nil, nil);
        netBackgroundStatusImgView.contentMode = UIViewContentModeScaleAspectFit;
        [netBackgroundStatusImgView keepAutoresizingInFull];
        
        [self.view insertSubview:netBackgroundStatusImgView atIndex:0];
    }
    
    netBackgroundStatusImgView.image = image;
    [netBackgroundStatusImgView removeGestureWithTarget:self andAction:@selector(getNetworkData)];
    
    if (yesOrNo && [self respondsToSelector:@selector(getNetworkData)])
    {
        netBackgroundStatusImgView.userInteractionEnabled = yesOrNo;
        [netBackgroundStatusImgView addTarget:self action:@selector(getNetworkData)];
    }
}

- (void)setNoNetworkConnectionStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"Unify_Image_w51"] userInteractionEnabled:YES];
}

- (void)setLoadFailureStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"gouwuche_morentupian"] userInteractionEnabled:YES];
}

#pragma mark - 设置代码块

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock
{
    [self setNetSuccessBlock:successBlock failedBlock:self.failedBlock];
}

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:self.noNetworkBlock SuccessBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock SuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:self.startedBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    [self setNoNetworkBlock:noNetworkBlock StartedBlock:startedBlock progressBlock:self.progressBlock successBlock:successBlock failedBlock:failedBlock];
}

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock progressBlock:(ExtendVCNetRequestProgressBlock)progressBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock
{
    self.noNetworkBlock = noNetworkBlock;
    self.startedBlock = startedBlock;
    self.progressBlock = progressBlock;
    self.successBlock = successBlock;
    self.failedBlock = failedBlock;
}

#pragma mark - 发送网络请求

- (void)clearDelegate
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

- (void)setNetworkRequestStatusBlocks
{
    // 子类实现,需在getNetworkData方法前调用
//    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
}

- (void)getNetworkData
{
    // do nothing
//    NSAssert(NO, @"%s - 子类没有实现此方法",__PRETTY_FUNCTION__);
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestMethodType:RequestMethodType_GET requestTag:tag];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:self];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    [self sendRequest:urlMethodName parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo netCachePolicy:NetNotCachePolicy cacheSeconds:0.0];
}

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds
{
    if (![NetworkStatusManager isConnectNetwork])
    {
        // 执行没有网络连接的代码块
        if (self.noNetworkBlock)
        {
            self.noNetworkBlock();
        }
        
        [self showHUDInfoByType:HUDInfoType_NoConnectionNetwork];
        
        return;
    }
    
    NSURL *url = nil;
    BOOL isGETRequest = [methodType isEqualToString:RequestMethodType_GET]; // 是否为GET方式的请求
    
    if (isGETRequest)
    {
        url = [UrlManager getRequestUrlByMethodName:urlMethodName andArgsDic:parameterDic];
    }
    else
    {
        url = [UrlManager getRequestUrlByMethodName:urlMethodName];
    }
    
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:!isGETRequest ? parameterDic : nil requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo netCachePolicy:cachePolicy cacheSeconds:cacheSeconds];
}

#pragma mark - NetRequestDelegate Methods

- (void)netRequestDidStarted:(NetRequest *)request
{
    if (self.startedBlock)
    {
       self.startedBlock(request);
    }
}

- (void)netRequest:(NetRequest *)request setProgress:(float)newProgress
{
    if (self.progressBlock)
    {
        self.progressBlock(request, newProgress);
    }
}

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    [self hideHUD];
    
    // 清空加载网络数据的背景图
    if (netBackgroundStatusImgView.superview)
    {
        [netBackgroundStatusImgView removeFromSuperview];
    }
    
    if (self.successBlock)
    {
        self.successBlock(request, infoObj);
    }
    
//    [self parserNetworkData:infoObj request:request];
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    [self hideHUD];
    
    if (self.failedBlock)
    {
        self.failedBlock(request, error);
    }
}

/*
#pragma  mark - 数据解析

- (void)parserNetworkData:(id)data request:(NetRequest *)request
{
    // do nothing
}
 */

#if defined(__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)
- (BOOL)prefersStatusBarHidden
{
    /*
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        return YES;
    }
    else
    {
        return NO;
    }
     */
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#endif

@end
