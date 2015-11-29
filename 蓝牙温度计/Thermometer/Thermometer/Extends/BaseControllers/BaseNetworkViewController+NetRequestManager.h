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
    // 温度
    NetTempRequestType_UploadTemp                               = 0, // 上传体温信息（30秒一次）
    
    
    // 用户中心
    NetUserCenterRequestType_Register                              , // 注册(POST)
    NetUserCenterRequestType_Login                                 , // 登录
    NetUserCenterRequestType_ModifyPossword                        , // 修改密码(POST)
    
   
    NetUserRequestType_AddUser                                     , // 添加成员
    NetUserRequestType_DeleteUser                                  , // 删除成员
    NetUserRequestType_ChangeUserInfo                              , // 修改成员信息
    NetUserRequestType_GetAllUserInfo                              , // 获取所有成员信息
    NetUserRequestType_GetAllUserInfoNoImage                       , // 获取所有成员信息不包括图片，用于忘记密码和判断此账户是否存在成员
    
    
    
    
    // 上传deviceToken
    NetUploadDeviceTokenRequestType_UploadDeviceToken              , // 上传deviceToken
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

