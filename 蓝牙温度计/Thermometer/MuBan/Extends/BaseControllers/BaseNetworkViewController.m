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
    UILabel     *netStatusRemindLabel;
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
        
        [self setDefaultNetFailedBlock];
        
        // 分页相关参数
        _page = 1;
        _pageSize = 20;
    }
    return self;
}

- (void)dealloc
{
    [self clearDelegate];
    /*
    // 自动的登录相关
    [[NSNotificationCenter defaultCenter] removeObserver:self name:didLoginSuccessNotificationKey object:nil];
     */
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
    /*
    // 自动的登录相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginSuccessAction) name:didLoginSuccessNotificationKey object:nil];
     */
}

// 有的类需要登录后才能请求服务器数据(此方法会在自动弹出登录界面并且登录成功后调用以再次发起推出登录界面控制器的网络请求)
- (void)didLoginSuccessAction
{
    [self getNetworkData];
}

#pragma mark - 设置网络背景状态图

// 设置网络背景状态图
- (void)setNetworkStatusViewByImage:(UIImage *)image userInteractionEnabled:(BOOL)yesOrNo
{
    [self setNetworkStatusViewByImage:image
                           remindText:nil
               userInteractionEnabled:yesOrNo];
}

- (void)setNetworkStatusViewByImage:(UIImage *)image remindText:(NSString *)text userInteractionEnabled:(BOOL)yesOrNo
{
    [self setNetworkStatusViewWithFrame:self.view.bounds
                                  Image:image
                             remindText:text
                 userInteractionEnabled:yesOrNo];
}

- (void)setNetworkStatusViewWithFrame:(CGRect)frame Image:(UIImage *)image remindText:(NSString *)text userInteractionEnabled:(BOOL)yesOrNo
{
    if (!netBackgroundStatusImgView)
    {
        netBackgroundStatusImgView = InsertImageView(self.view, frame, nil, nil);
        netBackgroundStatusImgView.contentMode = UIViewContentModeScaleAspectFit;
        [netBackgroundStatusImgView keepAutoresizingInFull];
        
        [self.view addSubview:netBackgroundStatusImgView];
    }
    if (!netStatusRemindLabel)
    {
        netStatusRemindLabel = InsertLabel(netBackgroundStatusImgView,
                                           CGRectMake(0, 0, netBackgroundStatusImgView.boundsWidth - 10 * 2, 0),
                                           NSTextAlignmentCenter,
                                           text,
                                           SP15Font,
                                           [UIColor blackColor],
                                           YES);
    }
    
    netBackgroundStatusImgView.image = image;
    
    netStatusRemindLabel.text = text;
    [netStatusRemindLabel sizeToFit];
    netStatusRemindLabel.frameOrigin = CGPointMake((netBackgroundStatusImgView.boundsWidth - netStatusRemindLabel.boundsWidth) / 2, netBackgroundStatusImgView.boundsHeight / 2 + 40);
    
    [netBackgroundStatusImgView removeGestureWithTarget:self andAction:@selector(getNetworkData)];
    
    if (yesOrNo && [self respondsToSelector:@selector(getNetworkData)])
    {
        netBackgroundStatusImgView.userInteractionEnabled = yesOrNo;
        [netBackgroundStatusImgView addTarget:self action:@selector(getNetworkData)];
    }
}

- (void)setNoDataSourceStatusView
{
    [self setNoDataSourceStatusViewWithRemindText:@"亲,还没有内容哦!"];
}

- (void)setNoDataSourceStatusViewWithRemindText:(NSString *)remindText
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"gwc_kkry"]
                           remindText:remindText
               userInteractionEnabled:NO];
}

- (void)setNoNetworkConnectionStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"Unify_Image_w51"]
                           remindText:NoConnectionNetwork
               userInteractionEnabled:YES];
}

- (void)setLoadFailureStatusView
{
    [self setNetworkStatusViewByImage:[UIImage imageNamed:@"gouwuche_morentupian"]
                           remindText:OperationFailure
               userInteractionEnabled:YES];
}

#pragma mark - 分页请求属性设置

- (void)setPagingSuccessActionWithResultCount:(NSInteger)resultCount
{
    ++_page;
    _isRequesting = NO;
    
    // 改变tab底部刷新视图的显示
    if (resultCount < _pageSize)
    {
        _nextPageHasData = NO;
        [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_NoMoreData];
    }
    else
    {
        _nextPageHasData = YES;
        [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_Loading];
    }
}

- (void)setPagingFailedActionWithRequest:(NetRequest *)request error:(NSError *)error
{
    [self showHUDInfoByString:error.localizedDescription];
    _isRequesting = NO;
    
    // 第一页请求
    if (_page == 1)
    {
        [self setDefaultNetFailedBlockImplementationWithNetRequest:request
                                                             error:error
                                             isAddFailedActionView:YES
                                                       isAutoLogin:YES
                                                 otherExecuteBlock:nil];
    }
    else
    {
        if (MyHTTPCodeType_DataSourceNotFound == error.code)
        {
            _nextPageHasData = NO;
            [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_NoMoreData];
        }
        else
        {
            _nextPageHasData = YES;
            [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_Loading];
        }
    }
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

// 设置默认的失败后执行的代码块
- (void)setDefaultNetFailedBlock;
{
    WEAKSELF
    self.failedBlock = ^(NetRequest *request, NSError *error)
    {
        [weakSelf setDefaultNetFailedBlockImplementationWithNetRequest:request error:error otherExecuteBlock:nil];
    };
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error otherExecuteBlock:(void (^)(void))otherBlock
{
    [self setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:YES otherExecuteBlock:otherBlock];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView otherExecuteBlock:(void (^)(void))otherBlock
{
    [self setDefaultNetFailedBlockImplementationWithNetRequest:request error:error isAddFailedActionView:isAddActionView isAutoLogin:YES otherExecuteBlock:otherBlock];
}

- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView isAutoLogin:(BOOL)isAutoLogin otherExecuteBlock:(void (^)(void))otherBlock
{
    // 无数据
    if (error.code == MyHTTPCodeType_DataSourceNotFound)
    {
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:[LanguagesManager getStr:All_DataSourceNotFoundKey]];
        }
        
        // 没数据时的状态图
        if (isAddActionView)
        {
            [self setNoDataSourceStatusView];
        }
    }
    // 未登录或登录过期
    else if (error.code == MyHTTPCodeType_TokenIllegal ||
             error.code == MyHTTPCodeType_TokenIncomplete ||
             error.code == MyHTTPCodeType_TokenOverdue)
    {
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:NotLogin];
        }
        
        if (isAutoLogin)
        {
            // 自动跳入登录页面
            /*
             LoginAndRegisterVC *login = [LoginAndRegisterVC loadFromNib];
             UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
             [self presentViewController:loginNav
             modalTransitionStyle:UIModalTransitionStyleCoverVertical
             completion:^{
             
             }];
             */
        }
    }
    else
    {
        /*
         [weakSelf showHUDInfoByType:HUDInfoType_Failed];
         */
        if (error.localizedDescription)
        {
            [self showHUDInfoByString:error.localizedDescription];
        }
        else
        {
            [self showHUDInfoByString:OperationFailure];
        }
        
        // 设置主view的状态背景图(点击重新刷新的图)
        if (isAddActionView)
        {
            [self setLoadFailureStatusView];
        }
    }
    
    if (otherBlock)
    {
        otherBlock();
    }
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

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    发送必须带header的请求(如果没有登录,header就会为nil,那么就会自动跳转到登录页面)
 @ 创建人      龚俊慧
 @ 创建时间    2014-10-21
 */
- (void)sendMustWithTokenHeadersRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    // 待实现...
}

///////////////////////////////////////////////////////////////////////////////////////////////////

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
