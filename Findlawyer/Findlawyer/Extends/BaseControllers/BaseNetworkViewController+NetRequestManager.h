//
//  BaseNetworkViewController+NetRequestManager.h
//  o2o
//
//  Created by swift on 14-8-27.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef enum
{
    // 主页新闻
    NetHomePageNewsRequestType_GetMainNewsDetail          = 0, // 获取主页新闻详情(GET)
    NetHomePageNewsRequestType_GetMainNewsList               , // 获取主页新闻列表(GET)
    
    NetConsultInfoRequestType_GetAskId                       , // 获取咨询系统分配ID (GET)
    NetConsultInfoRequestType_PostPhoto                      , // 上传咨询图片 (POST)
    NetConsultInfoRequestType_PostSaveAskInfo                , // 上传咨询信息 (POST)
    
    // 用户中心
    NetUserCenterRequestType_Register                        , // 注册
    NetUserCenterRequestType_Login                           , // 登录
    NetUserCenterRequestType_GetVerificationCode             , // 获取验证码
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

