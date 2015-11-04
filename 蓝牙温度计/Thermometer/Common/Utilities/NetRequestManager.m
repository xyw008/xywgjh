//
//  NetRequestManager.m
//  websiteEmplate
//
//  Created by admin on 13-4-10.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "NetRequestManager.h"
#import "DownloadCache.h"
#import "CoreDataManager.h"
#import "CoreData+MagicalRecord.h"
#import "UserInfoModel.h"

static NSString * const CacheKey = @"CacheKey";
static NSString * const CacheExpiresInSecondsKey = @"CacheExpiresInSecondsKey";

@implementation NetRequest

@synthesize delegate;
@synthesize tag;
@synthesize userInfo;
@synthesize asiFormRequest;
@synthesize resultInfoObj;
@synthesize resultErorr;
@synthesize didUseCachedResponse;

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    if (asiFormRequest) [asiFormRequest release];
    if (userInfo) [userInfo release];
    if (resultInfoObj) [resultInfoObj release];
    if (resultErorr) [resultErorr release];
    
    [super dealloc];
}

- (NSData *)JSONData:(NSData *)aData
{
    NSString *networkDataStr = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];

    NSMutableString *resultStr = [NSMutableString stringWithString:networkDataStr];
    
//[s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//[s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [resultStr replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [resultStr length])];
    [resultStr replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [resultStr length])];
    [resultStr replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [resultStr length])];
    [resultStr replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [resultStr length])];
    [resultStr replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [resultStr length])];
    
    NSData *resultData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];

    return resultData;
}

//数据解析
- (BOOL)isParseSuccessWithResponseData:(NSData *)data result:(id *)result
{
    if (!networkDataIsJsonType)
    {
        *result = data;
        
        return YES;
    }
    
    NSError *err = nil;
    
//    NSLog(@"result = %@",resultStr);
    
    *result = [NSJSONSerialization JSONObjectWithData:[self JSONData:data] options:NSJSONReadingMutableContainers error:&err];
    if (err)
    {
        *result = err;
        
        return NO;
    }
//    NSLog(@"resultDic = %@",*result);
    
    // 做服务器返回的业务code判断,因为如果服务器方法报错或者业务逻辑出错HTTP码还是返回的200,但是加了自己定义的一套code码(详情可参考WIKI上面的约定)
    NSNumber *myCodeNum = [*result objectForKey:@"code"];
    NSString *myMsgStr = [*result objectForKey:@"msg"];
    
    if (!myCodeNum || MyHTTPCodeType_Success != myCodeNum.integerValue)
    {
        err = [[NSError alloc] initWithDomain:@"MYSERVER_ERROR_DOMAIN" code:myCodeNum.integerValue userInfo:[NSDictionary dictionaryWithObjectsAndKeys:myMsgStr, NSLocalizedDescriptionKey, nil]];
        
        *result = err;
       
        return NO;
    }
    *result = [*result objectForKey:@"data"];
    
    return YES;
}

// 解析cookies
- (NSArray *)cookiesArrayByResponseHeaders:(NSDictionary *)responseHeaders url:(NSURL *)url
{
    if (SafetyObject(responseHeaders) && [responseHeaders isAbsoluteValid])
    {
        BOOL isNeedToRequestSetCookies = NO;
        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:responseHeaders forURL:url];
        for (NSHTTPCookie *cookieItem in cookies)
        {
            if ([cookieItem.name isEqualToString:@"ss"] && [cookieItem.value isAbsoluteValid] &&
                ![cookieItem.value isEqualToString:@"\"\""])
            {
                isNeedToRequestSetCookies = YES;
                break;
            }
        }
        if (isNeedToRequestSetCookies)
        {
            return cookies;
        }
    }
    return nil;
}

#pragma mark- ASIProgressDelegate methods

- (void)setProgress:(float)newProgress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:setProgress:)])
    {
        [delegate netRequest:self setProgress:newProgress];
    }
}

#pragma mark- ASIHTTPRequestDelegate methods

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:didReceiveResponseHeaders:)])
    {
        [delegate netRequest:self didReceiveResponseHeaders:responseHeaders];
    }
    
    // 解析cookies
    NSArray *cookies = [self cookiesArrayByResponseHeaders:responseHeaders url:request.url];
    if ([cookies isAbsoluteValid])
    {
        [UserInfoModel setUserDefaultCookiesArray:cookies];
    }
    
    // 登陆的状态.10000:已登录,正常状态, -10001:未登陆或者登陆session已过期
    NSString *loginStatusStr = [responseHeaders objectForKey:@"sfStatus"];
    if (loginStatusStr && 0 != loginStatusStr.length)
    {
        if (NotLoginStatusErrorCode == loginStatusStr.intValue)
        {
            /*
            if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
            {
                NSError *error = [[NSError alloc] initWithDomain:@"LOGIN_STATUS_ERROR_DOMAIN" code:NotLoginStatusErrorCode userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"未登陆或者登陆session已过期", NSLocalizedDescriptionKey, nil]];
                self.resultErorr = error;
                
                [delegate netRequest:self failedWithError:error];
            }
            */
            /*
            [[NetRequestManager sharedInstance] removeRequest:self];
            
            // session已经过期,重新自动登录
            [[LoginSessionModel shareLoginSessionModel] login];
            */
            
            return;
        }
    }
    
    NSString *contentTypeStr = [responseHeaders objectForKey:@"Content-Type"];
    
    // 判断从服务器请求下来的数据是否为json格式的
    if (contentTypeStr && ([contentTypeStr containsString:@"application/json"] ||
                           [contentTypeStr containsString:@"text/json"]))
    {
        networkDataIsJsonType = YES;
    }
    else
    {
        networkDataIsJsonType = NO;
    }
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(netRequestDidStarted:)])
    {
        [delegate netRequestDidStarted:self];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    id result = nil;
    
    if (200 == request.responseStatusCode && [self isParseSuccessWithResponseData:request.responseData result:&result])
    {
        // 缓存数据
        NSString *cacheKeyStr = [request.userInfo objectForKey:CacheKey]; // 缓存key值
        NSNumber *expiresInSeconds = [request.userInfo objectForKey:CacheExpiresInSecondsKey]; // 缓存时间
        
        if (cacheKeyStr && 0 != cacheKeyStr.length && expiresInSeconds)
        {
            [CachedDownloadManager storeResponseData:[self JSONData:request.responseData] cacheKey:cacheKeyStr expiresInSeconds:expiresInSeconds.doubleValue];
        }
        
        // 回调委托
        self.resultInfoObj = result;
        self.didUseCachedResponse = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:successWithInfoObj:)])
        {
            [delegate netRequest:self successWithInfoObj:result];
        }
    }
    else
    {
        self.resultErorr = (NSError *)result;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
        {
            [delegate netRequest:self failedWithError:(NSError *)result];
        }
    }
    [[NetRequestManager sharedInstance] removeRequest:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.resultErorr = request.error;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(netRequest:failedWithError:)])
    {
        [delegate netRequest:self failedWithError:request.error];
    }
    [[NetRequestManager sharedInstance] removeRequest:self];
}

@end

#pragma mark- NetRequestManager /////////////////////////////////////////////////////////////////////////

@interface NetRequestManager ()
{
    
}

/// 保存所有的请求参数,已便如果session过期再重新登录以后发送上一次的历史请求
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSDictionary *parameterDic;
@property (nonatomic, retain) NSDictionary *requestHeaders;
@property (nonatomic, copy)   NSString *methodType;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) id<NetRequestDelegate> delegate;
@property (nonatomic, retain) NSDictionary *userInfo;
@property (nonatomic, retain) NSString *savePath;
@property (nonatomic, retain) NSString *tempPath;
@property (nonatomic, retain) NSDictionary *fileDic;
@property (nonatomic, assign) NetCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval cacheSeconds;

@end

@implementation NetRequestManager

DEF_SINGLETON(NetRequestManager);

- (id)init
{
    self = [super init];
    if (self)
    {
        netRequestArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.url = nil;
    self.parameterDic = nil;
    self.requestHeaders = nil;
    self.methodType = nil;
    self.userInfo = nil;
    self.savePath = nil;
    self.tempPath = nil;
    self.fileDic = nil;
    
    [netRequestArray release];
    
    [super dealloc];
}

// 发送请求
- (void)startRequestWithUrl:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath fileDic:(NSDictionary *)fileDic netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds
{
    // 保存所有的请求参数,已便如果session过期再重新登录以后发送上一次的历史请求
    self.url = url;
    self.parameterDic = parameterDic;
    self.requestHeaders = headers;
    self.methodType = methodType;
    self.tag = tag;
    self.delegate = delegate;
    self.userInfo = userInfo;
    self.savePath = savePath;
    self.tempPath = tempPath;
    self.fileDic = fileDic;
    self.cachePolicy = cachePolicy;
    self.cacheSeconds = cacheSeconds;
    
    NetRequest *netRequest = [[[NetRequest alloc] init] autorelease];
    netRequest.tag = tag;
    netRequest.userInfo = userInfo;
    netRequest.delegate = delegate;
    netRequest.asiFormRequest = [ASIFormDataRequest requestWithURL:url];
    netRequest.asiFormRequest.delegate = netRequest;
    [netRequest.asiFormRequest setRequestMethod:methodType];
    netRequest.asiFormRequest.timeOutSeconds = 30;
    
    /*
    // 设置session cookie
    if ([UserInfoModel getUserDefaultCookiesArray])
    {
        [netRequest.asiFormRequest setRequestCookies:[NSMutableArray arrayWithArray:[UserInfoModel getUserDefaultCookiesArray]]];
    }
     */
    
    //设置session
    /*
    NSString *sessionValue = SessionDefaultValue;
    if (0 != sessionValue.length)
    {
        [netRequest.asiFormRequest addRequestHeader:@"Cookie" value:sessionValue];
    }
    */
    netRequest.asiFormRequest.useCookiePersistence = YES;                       // 如果设置useCookiePersistence为YES(默认值),cookie会被存储在共享的 NSHTTPCookieStorage 容器中,并且会自动被其他request重用。
    netRequest.asiFormRequest.shouldAttemptPersistentConnection = NO;           // 设置是否持续连接
    netRequest.asiFormRequest.numberOfTimesToRetryOnTimeout = 0;                // 设置超时重试连接的次数
	netRequest.asiFormRequest.downloadProgressDelegate = netRequest;            // 设置下载的代理
    netRequest.asiFormRequest.uploadProgressDelegate = netRequest;              // 设置上传的代理
	netRequest.asiFormRequest.allowResumeForFileDownloads = YES;                // 设置是是否支持断点下载
    netRequest.asiFormRequest.showAccurateProgress = YES;                       // 设置是否精确进度条
    netRequest.asiFormRequest.validatesSecureCertificate = NO;                  // 如果值为NO则支持HTTPS
    
    netRequest.asiFormRequest.downloadDestinationPath = savePath;               // 下载文件的保持路径
    netRequest.asiFormRequest.temporaryFileDownloadPath = tempPath;             // 下载文件的临时路径
    
    /**
     @ 修改描述     修改HTTP的Content-Type(类库默认设置不符合自己的业务需求,改为通过addRequestHeaders方式设置)
     @ 修改人       龚俊慧
     @ 修改时间     2014-08-11
     @ 修改开始
     */
    // 修改开始
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding([netRequest.asiFormRequest stringEncoding]));
    
    if ([methodType isEqualToString:RequestMethodType_GET])
    {
        [netRequest.asiFormRequest addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset]];
    }
    else
    {
        [netRequest.asiFormRequest addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"application/json; charset=%@",charset]];
        
        // 以对象方式设置请求消息体
        if ([parameterDic isAbsoluteValid])
        {
            NSString *postBodyStr = [parameterDic jsonStringByError:NULL];
            NSData *postBodyData = [postBodyStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [netRequest.asiFormRequest setPostBody:[NSMutableData dataWithData:postBodyData]];
        }
    }
    // 修改结束
    
    if ([fileDic isAbsoluteValid])
    {
        for (NSString *key in fileDic.allKeys)
        {
            /*
            [netRequest.asiFormRequest setFile:[fileDic objectForKey:key] forKey:key];
            */
            
            // 上传文件
            NSString *filePath = [fileDic objectForKey:key];
            NSString *fileName = [filePath substringFromIndex:[filePath rangeOfString:@"/" options:NSBackwardsSearch].location + 1];
            [netRequest.asiFormRequest setFile:filePath withFileName:fileName andContentType:@"multipart/form-data" forKey:key];
        }
    }

    if ([headers isAbsoluteValid])
    {
        for (NSString *headerKey in headers.allKeys)
        {
            [netRequest.asiFormRequest addRequestHeader:headerKey value:[headers objectForKey:headerKey]];
        }
    }
    
    /**
     @ 修改描述     配合修改HTTP的Content-Type,修改post传参方式
     @ 修改人       龚俊慧
     @ 修改时间     2014-08-11
     @ 修改开始
     */
    // 修改开始
    /*
    if ([parameterDic isAbsoluteValid])
    {
        for (NSString *key in parameterDic.allKeys)
        {
            [netRequest.asiFormRequest setPostValue:[parameterDic objectForKey:key] forKey:key];
        }
    }
     */
    // 修改结束
    
    // 判断是否要作数据缓存
    if (NetNotCachePolicy != cachePolicy)
    {
        NSString *cacheKeyStr = [[url absoluteString] stringByAppendingFormat:@"/%@",[NSString urlArgsStringFromDictionary:parameterDic]];
        
        // 如果存在缓存且没有过期则使用缓存数据,否则重新向服务器发送请求(成功委托只调用1次)
        if (NetAskServerIfModifiedWhenStaleCachePolicy == cachePolicy)
        {
            NSData *cacheData = [CachedDownloadManager cachedResponseDataForKey:cacheKeyStr];
            // 存在缓存数据且没有过期
            if (cacheData)
            {
                [netRequest setValue:@(YES) forKey:@"networkDataIsJsonType"];
                id result = nil;
                
                if ([netRequest isParseSuccessWithResponseData:cacheData result:&result])
                {
                    netRequest.didUseCachedResponse = YES;
                    netRequest.resultInfoObj = result;
                    
                    if (netRequest.delegate && [netRequest.delegate respondsToSelector:@selector(netRequest:successWithInfoObj:)])
                    {
                        [netRequest.delegate netRequest:netRequest successWithInfoObj:result];
                    }
                    return;
                }
            }
            else
            {
                netRequest.asiFormRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cacheKeyStr,CacheKey,[NSNumber numberWithDouble:cacheSeconds],CacheExpiresInSecondsKey, nil];
            }
        }
        // 如果存在缓存且没有过期则使用缓存数据,然后再向服务器发送请求(成功委托会调用2次)
        else if (NetUseCacheFirstWhenCacheValidAndAskServerAgain == cachePolicy)
        {
            NSData *cacheData = [CachedDownloadManager cachedResponseDataForKey:cacheKeyStr];
            // 先用缓存数据
            if (cacheData)
            {
                [netRequest setValue:@(YES) forKey:@"networkDataIsJsonType"];
                id result = nil;
                
                if ([netRequest isParseSuccessWithResponseData:cacheData result:&result])
                {
                    netRequest.didUseCachedResponse = YES;
                    netRequest.resultInfoObj = result;
                    
                    if (netRequest.delegate && [netRequest.delegate respondsToSelector:@selector(netRequest:successWithInfoObj:)])
                    {
                        [netRequest.delegate netRequest:netRequest successWithInfoObj:result];
                    }
                }
            }
            
            // 再请求服务器
            netRequest.asiFormRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cacheKeyStr,CacheKey,[NSNumber numberWithDouble:cacheSeconds],CacheExpiresInSecondsKey, nil];
        }
        // 无视缓存数据,总是向服务器请求新的数据
        else if (NetAlwaysAskServerCachePolicy == cachePolicy)
        {
            // 删除旧的缓存数据
            [CachedDownloadManager removeCachedDataForKey:cacheKeyStr];
            
            netRequest.asiFormRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:cacheKeyStr,CacheKey,[NSNumber numberWithDouble:cacheSeconds],CacheExpiresInSecondsKey, nil];
        }
    }
    
    [netRequest.asiFormRequest startAsynchronous];
    
    [netRequestArray addObject:netRequest];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    [self sendRequest:url parameterDic:parameterDic requestMethodType:RequestMethodType_GET requestTag:tag delegate:delegate userInfo:userInfo];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo;

{
    [self sendRequest:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo
{
    [self sendRequest:url parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo netCachePolicy:NetNotCachePolicy cacheSeconds:0.0];
}

- (void)sendRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestHeaders:(NSDictionary *)headers requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo netCachePolicy:(NetCachePolicy)cachePolicy cacheSeconds:(NSTimeInterval)cacheSeconds
{
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:headers requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:nil tempPath:nil fileDic:nil netCachePolicy:cachePolicy cacheSeconds:cacheSeconds];
}

/////////////////////////////////////////////////////////////////////////

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate savePath:(NSString *)savePath tempPath:(NSString *)tempPath
{
    [self sendDownloadRequest:url parameterDic:parameterDic requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil savePath:savePath tempPath:tempPath];
}

- (void)sendDownloadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo savePath:(NSString *)savePath tempPath:(NSString *)tempPath
{
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:savePath tempPath:tempPath fileDic:nil netCachePolicy:NetNotCachePolicy cacheSeconds:0.0];
}

/////////////////////////////////////////////////////////////////////////

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate fileDic:(NSDictionary *)fileDic
{
    [self sendUploadRequest:url parameterDic:parameterDic requestMethodType:methodType requestTag:tag delegate:delegate userInfo:nil fileDic:fileDic];
}

- (void)sendUploadRequest:(NSURL *)url parameterDic:(NSDictionary *)parameterDic requestMethodType:(NSString *)methodType requestTag:(int)tag delegate:(id<NetRequestDelegate>)delegate userInfo:(NSDictionary *)userInfo fileDic:(NSDictionary *)fileDic
{
    [self startRequestWithUrl:url parameterDic:parameterDic requestHeaders:nil requestMethodType:methodType requestTag:tag delegate:delegate userInfo:userInfo savePath:nil tempPath:nil fileDic:fileDic netCachePolicy:NetNotCachePolicy cacheSeconds:0.0];
}

/////////////////////////////////////////////////////////////////////////

- (void)sendLatestRequest
{
    [self startRequestWithUrl:self.url parameterDic:self.parameterDic requestHeaders:self.requestHeaders requestMethodType:self.methodType requestTag:self.tag delegate:self.delegate userInfo:self.userInfo savePath:self.savePath tempPath:self.tempPath fileDic:self.fileDic netCachePolicy:self.cachePolicy cacheSeconds:self.cacheSeconds];
}

- (void)clearDelegate:(id<NetRequestDelegate>)delegate
{
    NSMutableArray *toRemoveRequestArray = [NSMutableArray array];
    
    for (NetRequest *request in netRequestArray)
    {
        if (delegate == request.delegate)
        {
            [request.asiFormRequest clearDelegatesAndCancel];
            request.delegate = nil;
            
            [toRemoveRequestArray addObject:request];
        }
    }
    
    if (0 != toRemoveRequestArray.count)
    {
        [netRequestArray removeObjectsInArray:toRemoveRequestArray];
    }
}

- (void) removeRequest:(NetRequest*)request
{
    [request.asiFormRequest clearDelegatesAndCancel];
    request.delegate = nil;
    [netRequestArray removeObject:request];
}

@end

#pragma mark - implementation CachedDownloadManager  ///////////////////////////////////////////////

@implementation CachedDownloadManager

+ (void)storeResponseData:(NSData *)data cacheKey:(NSString *)key expiresInSeconds:(NSTimeInterval)expiresInSeconds
{
    /*
     DownloadCache *downloadCache = [[CoreDataManager shareCoreDataManagerManager] createEmptyObjectWithEntityName:@"DownloadCache"];
     */
    // 删除可能存在的缓存
    [self removeCachedDataForKey:key];
    
    DownloadCache *downloadCache = [DownloadCache MR_createEntity];
    downloadCache.key = key;
    downloadCache.cacheDate = [NSDate date];
    downloadCache.expiresInSeconds = [NSNumber numberWithDouble:expiresInSeconds];
    downloadCache.contentData = data;
    downloadCache.expiryDate = [[NSDate date] dateByAddingTimeInterval:expiresInSeconds];
    /*
     [[CoreDataManager shareCoreDataManagerManager] save];
     */
    [downloadCache.managedObjectContext MR_saveToPersistentStoreAndWait];
}

+ (NSData *)cachedResponseDataForKey:(NSString *)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",key];/*用CONTAINS和LIKE(通配符)也可以,一定要注意字符串不能用''单引号括住*/
    
    /*
     NSArray *array = [[CoreDataManager shareCoreDataManagerManager] getListWithPredicate:predicate sortDescriptors:nil entityName:@"DownloadCache" limitNum:[NSNumber numberWithInt:1]];
     
     if (array && 0 != array.count)
     {
     DownloadCache *downloadCache = [array lastObject];
     
     // 存储的数据已过期
     if (NSOrderedDescending == [[NSDate date] compare:downloadCache.expiryDate])
     {
     // 删除过期数据
     [self removeCachedDataForKey:key];
     
     return nil;
     }
     return downloadCache.contentData;
     }
     return nil;
     */
    
    DownloadCache *downloadCache = [DownloadCache MR_findFirstWithPredicate:predicate];
    if (downloadCache)
    {
        // 存储的数据已过期
        if (NSOrderedDescending == [[NSDate date] compare:downloadCache.expiryDate])
        {
            // 删除过期数据
            [self removeCachedDataForKey:key];
            
            return nil;
        }
        return downloadCache.contentData;
    }
    return nil;
}

+ (void)removeCachedDataForKey:(NSString *)key
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key == %@",key];/*用CONTAINS和LIKE(通配符)也可以,一定要注意字符串不能用''单引号括住*/
    /*
     NSArray *array = [[CoreDataManager shareCoreDataManagerManager] getListWithPredicate:predicate sortDescriptors:nil entityName:@"DownloadCache" limitNum:[NSNumber numberWithInt:1]];
     
     if (array && 0 != array.count)
     {
     DownloadCache *downloadCache = [array lastObject];
     
     [[CoreDataManager shareCoreDataManagerManager] deleteObject:downloadCache];
     }
     */
    
    [DownloadCache MR_deleteAllMatchingPredicate:predicate];
}

+ (void)clearAllCachedResponses
{
    /*
     [[CoreDataManager shareCoreDataManagerManager] removeAllObjectWithEntityName:@"DownloadCache"];
     */
    
    [DownloadCache MR_truncateAll];
}

@end
