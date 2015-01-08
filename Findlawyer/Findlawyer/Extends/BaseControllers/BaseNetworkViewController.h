//
//  BaseNetworkViewController.h
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInfoModel.h"
#import "NetRequestManager.h"
#import "NetworkStatusManager.h"
#import "UrlManager.h"

// 缓存网络数据的时间
typedef enum
{
    /// 1分钟
    CacheNetDataTimeType_OneMinute = 60,
    
    /// 1小时
    CacheNetDataTimeType_OneHour   = 60 * 60,
    
    /// 1天
    CacheNetDataTimeType_OneDay    = 60 * 60 * 24,
    
    /// 1周
    CacheNetDataTimeType_OneWeek   = 60 * 60 * 24 * 7,
    
    /// 1个月
    CacheNetDataTimeType_OneMonth  = 60 * 60 * 24 * 30,
    
}CacheNetDataTimeType;


@interface BaseNetworkViewController : BaseViewController <NetRequestDelegate>
{
@protected
    NSMutableDictionary         *_networkDataDic;
}

typedef void (^ExtendVCNetRequestNoNetworkBlock) (void);
typedef void (^ExtendVCNetRequestStartedBlock)   (NetRequest *request);
typedef void (^ExtendVCNetRequestProgressBlock)  (NetRequest *request, float progress);
typedef void (^ExtendVCNetRequestSuccessBlock)   (NetRequest *request, id successInfoObj);
typedef void (^ExtendVCNetRequestFailedBlock)    (NetRequest *request, NSError *error);


/// 没有网络连接需要执行的代码块
@property (nonatomic, copy) ExtendVCNetRequestNoNetworkBlock noNetworkBlock; // 默认为页面显示没有网络连接的提示图

/// 网络请求开始需要执行的代码块
@property (nonatomic, copy) ExtendVCNetRequestStartedBlock startedBlock;     // 默认为用HUD显示"加载中..."

/// 网络请求过程需要执行的代码块
@property (nonatomic, copy) ExtendVCNetRequestProgressBlock progressBlock;   // 默认为nil

/// 网络请求成功需要执行的代码块
@property (nonatomic, copy) ExtendVCNetRequestSuccessBlock successBlock;     // 默认为nil

/// 网络请求失败需要执行的代码块
@property (nonatomic, copy) ExtendVCNetRequestFailedBlock failedBlock;       // 默认为用HUD显示"加载失败,且页面显示点击重新刷新的提示图"

/////////////////////////////////////////////////////////////////////////////////////////


/// 设置网络背景状态图
- (void)setNetworkStatusViewByImage:(UIImage *)image userInteractionEnabled:(BOOL)yesOrNo;

/// 设置没有网络连接的背景图
- (void)setNoNetworkConnectionStatusView;

/// 设置请求网络数据失败的背景图
- (void)setLoadFailureStatusView;

/////////////////////////////////////////////////////////////////////////////////////////


/// 设置网络请求中每个阶段需要执行的代码块(子类必须实现)
- (void)setNetworkRequestStatusBlocks;

/// 默认的失败后执行的代码块实现
- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error otherExecuteBlock:(void(^)(void))otherBlock;

/// 默认的失败后执行的代码块实现,可设置失败后是否点击重试的操作
- (void)setDefaultNetFailedBlockImplementationWithNetRequest:(NetRequest *)request error:(NSError *)error isAddFailedActionView:(BOOL)isAddActionView otherExecuteBlock:(void(^)(void))otherBlock;

/// 请求网络数据(子类必须实现)
- (void)getNetworkData;

/// 网络数据解析
//- (void)parserNetworkData:(id)data request:(NetRequest *)request;

/// 清空request委托
- (void)clearDelegate;

/// 设置代码块
- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock;

- (void)setNetSuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock;

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock SuccessBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock;

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock;

- (void)setNoNetworkBlock:(ExtendVCNetRequestNoNetworkBlock)noNetworkBlock StartedBlock:(ExtendVCNetRequestStartedBlock)startedBlock progressBlock:(ExtendVCNetRequestProgressBlock)progressBlock successBlock:(ExtendVCNetRequestSuccessBlock)successBlock failedBlock:(ExtendVCNetRequestFailedBlock)failedBlock;

/////////////////////////////////////////////////////////////////////////////////////////


/**
 @ 方法描述    发送各类请求
 @ 输入参数    parameterDic: 参数字典,如果requestMethodType为POST则以JSON格式的字符串传入方法体中,如果为GET在拼装在URL中
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-24
 */
- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag;

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag;

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag;

///////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    发送必须带header的请求(如果没有登录,header就会为nil,那么就会自动跳转到登录页面)
 @ 输入参数    parameterDic: 参数字典,如果requestMethodType为POST则以JSON格式的字符串传入方法体中,如果为GET在拼装在URL中
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-10-21
 */
- (void)sendMustWithTokenHeadersRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate;

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

- (void)sendRequest:(NSString *)urlMethodName parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds;

@end
