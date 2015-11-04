//
//  NetRequestManager.h
//  websiteEmplate
//
//  Created by admin on 13-4-10.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

// GET / POST / PUT / DELETE (default is GET)
# define RequestMethodType_GET      @"GET"
# define RequestMethodType_POST     @"POST"
# define RequestMethodType_PUT      @"PUT"
# define RequestMethodType_DELETE   @"DELETE"

// 自定义业务状态码
/**
 @ 1200	操作成功(查询成功,修改成功,新增成功,删除成功)
 @ 1404	资源无法找到
 @ 1500	内部错误
 @ 1600	参数不合法
 
 @ 8034 用户凭证过期
 @ 8005 用户凭证不完整
 @ 8006 非法的用户凭证
 */
typedef NS_ENUM (NSInteger, MyHTTPCodeType)
{
    MyHTTPCodeType_Success                  = 1200,
    MyHTTPCodeType_DataSourceNotFound       = 1404,
    MyHTTPCodeType_InternalError            = 1500,
    MyHTTPCodeType_IllegalParameter         = 1600,
    
    MyHTTPCodeType_TokenOverdue             = 8034,
    MyHTTPCodeType_TokenIncomplete          = 8005,
    MyHTTPCodeType_TokenIllegal             = 8006,
};

typedef enum
{
    /// 如果存在缓存且没有过期则使用缓存数据,否则重新向服务器发送请求(成功委托只调用1次)
    NetAskServerIfModifiedWhenStaleCachePolicy,
    
    /// 如果存在缓存且没有过期则使用缓存数据,然后再向服务器发送请求(成功委托会调用2次)
    NetUseCacheFirstWhenCacheValidAndAskServerAgain,
    
    /// 无视缓存数据,总是向服务器请求新的数据
	NetAlwaysAskServerCachePolicy,
    
    /// 不做数据缓存
	NetNotCachePolicy
    
} NetCachePolicy; /// 缓存策略

@protocol NetRequestDelegate;

@interface NetRequest : NSObject <ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASIFormDataRequest *asiFormRequest;
    
@private
    BOOL networkDataIsJsonType;
}

@property (nonatomic,retain) ASIFormDataRequest *asiFormRequest;
@property (nonatomic,assign) int tag;
@property (nonatomic,retain) NSDictionary *userInfo;
@property (nonatomic,assign) id<NetRequestDelegate>delegate;
@property (nonatomic,retain) id resultInfoObj;
@property (nonatomic,retain) NSError *resultErorr;
@property (nonatomic,assign) BOOL didUseCachedResponse; /// 是否使用的缓存数据

@end

/////////////////////////////////////////////////////////////////////////

#pragma mark- NetRequestManager

@interface NetRequestManager : NSObject
{
@private
    NSMutableArray *netRequestArray;
}

AS_SINGLETON(NetRequestManager);

/**
 @ 方法描述    发送一个普通请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 requestMethodType: HTTP请求方式
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-23
 */
- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

/**
 @ 方法描述    发送一个带缓存的请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 netCachePolicy: 缓存策略 cacheSeconds: 缓存时间
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-23
 */
- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds;

/**
 @ 方法描述    发送一个下载文件请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 savePath: 文件保持路径 tempPath: 文件下载临时路径
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-23
 */
- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate savePath:(NSString *)savePath tempPath:(NSString *)tempPath;

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath;
/**
 @ 方法描述    发送一个上传文件的请求
 @ 输入参数    parameterDic: 参数字典,如是引用对象需转换成JSON格式的字符串 fileDic: 文件沙盒路径
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-23
 */
- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate fileDic:(NSDictionary *)fileDic;

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo fileDic:(NSDictionary *)fileDic;

/// 发送最后一次的历史请求
- (void)sendLatestRequest;

- (void)removeRequest:(NetRequest*)request;
- (void)clearDelegate:(id<NetRequestDelegate>)delegate;

@end

/////////////////////////////////////////////////////////////////////////

@interface CachedDownloadManager : NSObject
{
    
}

/// 缓存一个数据
+ (void)storeResponseData:(NSData *)data cacheKey:(NSString *)key expiresInSeconds:(NSTimeInterval)expiresInSeconds;

/// 根据key值获取一个已缓存的数据
+ (NSData *)cachedResponseDataForKey:(NSString *)key;

/// 根据key值移除一个已缓存的数据
+ (void)removeCachedDataForKey:(NSString *)key;

/// 移除所以已缓存的数据
+ (void)clearAllCachedResponses;

@end

/////////////////////////////////////////////////////////////////////////

@protocol NetRequestDelegate <NSObject>

@optional
- (void)netRequest:(NetRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)netRequestDidStarted:(NetRequest *)request;
- (void)netRequest:(NetRequest *)request setProgress:(float)newProgress;
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj;
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error;

@end