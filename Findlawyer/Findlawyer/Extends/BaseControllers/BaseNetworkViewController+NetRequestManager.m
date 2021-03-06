//
//  BaseNetworkViewController+NetRequestManager.m
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController+NetRequestManager.h"

@implementation BaseNetworkViewController (NetRequestManager)

+ (NSString*) getRequestURLStr:(NetRequestType)requestType
{
    // 与"NetProductRequestType"一一对应
    static NSMutableArray *urlForTypeArray = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        urlForTypeArray = [NSMutableArray arrayWithObjects:
                           
                           // 主页新闻
                           @"GetMainNewsInfo",          // 获取主页新闻详情
                           @"InitLoadData",
                           @"GetMainNewsList",
                           
                           @"GetAskId",
                           @"AddAskPhoto",              // 上传图片
                           @"SaveAskInfo",
                           
                           // 用户中心
                           @"RegisterUser",
                           @"UserLogin",
                           @"SendSms",
                           
                           nil];
    });
    
    return urlForTypeArray[requestType];
}

@end
