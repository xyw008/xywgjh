//
//  Network.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-11.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "Network.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "NSObject+QFramework.h"


@implementation Network

static Network *sharedNetwork = nil;

+ (Network *)sharedNetwork
{
	@synchronized(self) {
		if (sharedNetwork == nil) {
			sharedNetwork = [[self alloc] init];
        }
	}
	return sharedNetwork;
}

- (void)create
{
    self.actionQueue = [NSMutableDictionary dictionaryWithCapacity:0];
    [self addSignalObserver];
}

- (void)destroy
{
    [self cancelAllAction];
    self.actionQueue = nil;
}

- (void)enterForeground
{

}

- (void)enterBackground
{
  
}


- (NSDictionary *)parseJSON:(id)JSON
{
    NSDictionary *info = nil;
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil)
    {
        QLog(@"%@", [error localizedDescription]);
    }
    
    error = nil;
    
    info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error != nil)
    {
        QLog(@"%@", [error localizedDescription]);
    }
    
    return info;
}

- (NSURLRequest *)requestWithUrlString:(NSString *)urlString timeoutInterval:(NSTimeInterval)timeoutInterval
{
    const char *utf8Char = [urlString UTF8String];
    NSString *utf8String = [NSString stringWithUTF8String:utf8Char];
    utf8String = [utf8String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    QDLog(@"%@", utf8String);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:utf8String]];
    [request setTimeoutInterval:timeoutInterval];
    
    return request;
}

- (BOOL)isRightMobile:(NSString *)mobile
{
    //^1[3|4|5|8][0-9]\d{4,8}$
    // NSString *regular = @"^1[3|4|5|8]\\d{9}$";
    //  NSString *regular = @"^(1[3|4|5|8]\\d{9})|(17[6|7|8]\\d{8})$";
    NSString *regular = @"^(1[3|4|5|8]\\d{9})|(17[6|7|8]\\d{8})$";
    
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"regular mobile error:%@",error);
        return NO;
    }
    else
    {
        NSInteger matches = [regularExpression numberOfMatchesInString:mobile options:0 range:NSMakeRange(0, [mobile length])];
        if (matches != 0)
        {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Action

- (BOOL)addAction:(NetAction *)action
{
    if (action != nil && action.key != nil)
    {
        if (![self isDoingActionForKey:action.key])
        {
            QDLog(@"添加Action key：%@", action.key);
            [self.actionQueue setObject:action forKey:action.key];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)removeActionForKey:(NSString *)key
{
    if (key != nil)
    {
        QDLog(@"移除Action key：%@", key);
        [self.actionQueue removeObjectForKey:key];
        return YES;
    }
    return NO;
}

- (BOOL)isDoingActionForKey:(NSString *)key
{
    if (key != nil && self.actionQueue[key] != nil)
    {
        QDLog(@"该Action正在执行：%@", key);
        return YES;
    }
    return NO;
}

- (NetAction *)actionForKey:(NSString *)key
{
    if (key)
    {
        return self.actionQueue[key];
    }
    return nil;
}

- (void)cancelAllAction
{
    QDLog(@"取消所有Network action");
    
    for (NetAction *action in self.actionQueue.allValues)
    {
        id op = action.action;
      // 注意：用的是新库
        if ([op isKindOfClass:[AFHTTPRequestOperation class]])
        {
            if ([op isExecuting])
            {
                [op cancel];
            }
        }
        
        [self removeActionForKey:action.key];
    }
}

- (NetReturnType)checkWithActionKey:(NSString *)key type:(NSInteger)type  // Type: 0表示server 1表示web
{

    if (![Network isEnableNetwork])
    {
        return NetworkDisenable;
    }
    
    if (key && [self isDoingActionForKey:key])
    {
        return NetRequesting;
    }
    
//    if (sharedData.userInfo.account.length == 0 || sharedData.userInfo.password.length == 0 )
//    {
//        return ECLNetParameterError;
//    }
//    
    return NetBeginRequest;
}


#pragma mark - NetworkState

+ (BOOL)isEnableNetwork
{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable))
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isEnableWifi
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)isEnable3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

- (NetReturnType)loadlawfirmInfoWithID:(NSInteger)lawfirmID completion:(CompletionBlock)completion

{
    
    // Check action.
    __weak Network * weakSelf = self;
    NetReturnType ret = [self checkWithActionKey:nil type:1];
    if (ret != NetBeginRequest)
    {
        return ret;
    }
    // Request.
    NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/APPService/AppHandler.ashx?fn=GetLawFirmInfo&id=%d",
                        lawfirmID];
    
    NSURLRequest *request = [self requestWithUrlString:urlStr timeoutInterval:10.0];
   [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    // 
    AFJSONRequestOperation *op = [AFJSONRequestOperation
                                  JSONRequestOperationWithRequest:request
                                  
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                      NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
                                      if (completion)
                                      {
                                          completion ( YES, jsonInfo[@"msg"], jsonInfo);
                                      }
                                  }
         
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                      
                                      QLog(@"Request fail: %@", [NSString stringWithFormat:@"%@",error]);
                                      [weakSelf requestFailed:completion];
                                  }];
    
    [op start];
    
    return NetBeginRequest;
}

- (NetReturnType)loadlawyerInfoWithID:(NSInteger)lawyerID completion:(CompletionBlock)completion
{
    __weak Network * weakSelf = self;
    
    NetReturnType ret = [self checkWithActionKey:nil type:1];
    if (ret != NetBeginRequest)
    {
        return ret;
    }
    // Request.
    NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/APPService/AppHandler.ashx?fn=GetLawyerInfo&id=%d",
                        lawyerID];
    
    NSURLRequest *request = [self requestWithUrlString:urlStr timeoutInterval:10.0];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    //
    AFJSONRequestOperation *op = [AFJSONRequestOperation
                                  JSONRequestOperationWithRequest:request
                                  
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                      NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
                                      if (completion)
                                      {
                                          completion ( YES, jsonInfo[@"msg"], jsonInfo);
                                      }
                                  }
                                  
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                      
                                      QLog(@"Request fail: %@", [NSString stringWithFormat:@"%@",error]);
                                      [weakSelf requestFailed:completion];
                                  }];
    
    [op start];
    
    return NetBeginRequest;

}

- (NetReturnType)loadArticleTypestWithID:(NSInteger)lawyerID completion:(CompletionBlock)completion
{
    __weak Network * weakSelf = self;
    
    NetReturnType ret = [self checkWithActionKey:nil type:1];
    if (ret != NetBeginRequest)
    {
        return ret;
    }
    // Request.
    NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/APPService/AppHandler.ashx?fn=GetLawyerNewsTypeList&id=%d",
                        lawyerID];
    
    NSURLRequest *request = [self requestWithUrlString:urlStr timeoutInterval:10.0];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation
                                  JSONRequestOperationWithRequest:request
                                  
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                      NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
                                      if (completion)
                                      {
                                          completion ( YES, jsonInfo[@"msg"], jsonInfo);
                                      }
                                  }
                                  
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                      
                                      QLog(@"Request fail: %@", [NSString stringWithFormat:@"%@",error]);
                                      [weakSelf requestFailed:completion];
                                  }];
    
    [op start];
    
    return NetBeginRequest;
}

- (NetReturnType)loadArticleListWithLawyerID:(NSInteger)lawyerID  typeID:(NSInteger)artypeid completion:(CompletionBlock)completion
{
    __weak Network * weakSelf = self;
    
    NetReturnType ret = [self checkWithActionKey:nil type:1];
    if (ret != NetBeginRequest)
    {
        return ret;
    }
    // Request.
    NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/APPService/AppHandler.ashx?fn=GetLawyerNewsList&id=%d&typeId=%d",
                        lawyerID,artypeid];
    
    NSURLRequest *request = [self requestWithUrlString:urlStr timeoutInterval:10.0];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation
                                  JSONRequestOperationWithRequest:request
                                  
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                      NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
                                      if (completion)
                                      {
                                          completion ( YES, jsonInfo[@"msg"], jsonInfo);
                                      }
                                  }
                                  
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                      
                                      QLog(@"Request fail: %@", [NSString stringWithFormat:@"%@",error]);
                                      [weakSelf requestFailed:completion];
                                  }];
    
    [op start];
    
    return NetBeginRequest;
}
- (NetReturnType)loadArticleInforWithID:(NSInteger)articleid completion:(CompletionBlock)completion
{
    __weak Network * weakSelf = self;
    
    NetReturnType ret = [self checkWithActionKey:nil type:1];
    if (ret != NetBeginRequest)
    {
        return ret;
    }
    // Request.
    NSString *urlStr = [NSString stringWithFormat:@"http://test3.sunlawyers.com/APPService/AppHandler.ashx?fn=GetNewsInfo&id=%d",
                        articleid];
    NSURLRequest *request = [self requestWithUrlString:urlStr timeoutInterval:10.0];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation
                                  JSONRequestOperationWithRequest:request
                                  
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                      NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
                                      if (completion)
                                      {
                                          completion ( YES, jsonInfo[@"msg"], jsonInfo);
                                      }
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                      
                                      QLog(@"Request fail: %@", [NSString stringWithFormat:@"%@",error]);
                                      [weakSelf requestFailed:completion];
                                  }];
    [op start];
    return NetBeginRequest;

}

- (void)requestFailed:(CompletionBlock)completion
{
    if (completion)
    {
        completion(-1, @"请求失败", nil);
    }
}



//- (void)loadlawfirmInfoRequestFinish:(id)JSON comletion:(CompletionBlock)completion
//{
//    NSDictionary *jsonInfo = [self parseJSON:JSON];  // Parse json.
//    
//    NSInteger ret = [jsonInfo[@"ret"] intValue];
//    ECLStaffInfo *staffInfo = nil;
//    NSDictionary *data = jsonInfo[@"data"];
//    
//    if (ret == 100 && data != nil)
//    {
//        [ECLCoreData saveStaffInfoWithJsonInfo:jsonInfo];
//        staffInfo = [self staffInfoWithJsonData:data];
//    }
//    
//    completion(ret,  jsonInfo[@"msg"], staffInfo);
//}


#pragma mark - Search

//- (NetReturnType)SearchLawFirmWithKey:(NSInteger)Index AndSearchType:(SearchType) searchtype completion:(CompletionBlock)completion
//{
//    
//}




@end
