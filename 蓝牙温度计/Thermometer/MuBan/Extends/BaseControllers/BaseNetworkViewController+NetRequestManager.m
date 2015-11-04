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
                           // 产品
                           @"categorys",
                           
                           @"carts",
                           @"carts/items",
                           @"carts/items",              // 加入购物车
                           @"carts/items",
                           
                           @"favorit/items",
                           @"favorit/items",            // 加入收藏还要自己组装商品ID
                           @"favorit/items",            // 取消收藏还要自己组装商品ID
                           
                           @"products",
                           @"products",                 // 详情还要自己组装ID
                           @"activities",               // 活动商品还要组装活动ID
                           @"products",
                           
                           @"search/queryProducts",
                           @"search/querySuggest",
                           
                           // 用户中心
                           @"user/register",
                           @"user/login",
                           @"user/changePwd",
                           
                           @"account/my/info",
                           @"user/changeInfo",
                           
                           @"address/my",
                           @"address/my",
                           @"address/my",
                           @"address/my",
                           
                           //订单
                           @"orders",
                           @"orders",// 单个订单详情请求，还要自己组装订单ID
                           @"orders/ready",
                           @"orders",
                           
                           // 优惠
                           @"/activities",
                           
                           // FAQ
                           @"/faqs",
                           
                           //主页
                           @"/programs",
                           
                           // 168小时
                           @"promotions",
                           
                           nil];

        
    });
    
    return urlForTypeArray[requestType];
}

@end
