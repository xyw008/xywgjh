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
    // 产品
    NetProductRequestType_GetAllCategorys                       = 0, // 获取商品所有分类(GET)
    
    NetProductRequestType_GetAllCarts                              , // 获取购物车所有产品(GET)
    NetProductRequestType_UpdateCartProduct                        , // 更新购物车商品 (PUT)
    NetProductRequestType_PostAddCart                              , // 加入购物车 (POST)
    NetProductRequestType_DeleteCartProduct                        , // 删除购物车的单项商品(DELETE)
    
    NetProductRequestType_GetAllFavorites                          , // 获取收藏夹所有产品(GET)
    NetProductRequestType_PostAddFavorites                         , // 加入收藏夹 (POST)
    NetProductRequestType_DeleteFavorite                           , // 取消商品收藏(DELETE)
    
    NetProductRequestType_GetProducts                              , // 获取商品列表(GET)
    NetProductRequestType_GetDetails                               , // 获取商品详情(GET)
    NetProductRequestType_GetActivityProducts                      , // 获取活动的商品列表(GET)
    NetProductRequestType_GetProductSkuInfo                        , // 获取商品的SKU信息(GET)
    
    NetProductRequestType_PostSearchQueryProducts                  , // 获取搜索商品列表
    NetProductRequestType_PostSearchQuerySuggest                   , // 获取搜索输入的智能关联建议
    
    // 用户中心
    NetUserCenterRequestType_Register                              , // 注册(POST)
    NetUserCenterRequestType_Login                                 , // 登录
    NetUserCenterRequestType_ModifyPossword                        , // 修改密码(POST)
    
    NetUserCenterRequestType_GetAccountInfo                        , // 个人信息获取(GET)
    NetUserCenterRequestType_ChangeAccountInfo                     , // 修改个人信息 (POST)
    
    NetUserCenterRequestType_GetAllMyAddress                       , // 获取所有收货地址列表(GET)
    NetUserCenterRequestType_AddOneAddress                         , // 添加一个收货地址(POST)
    NetUserCenterRequestType_ModifyOneAddress                      , // 修改一个收货地址(PUT)
    NetUserCenterRequestType_DeleteOneAddress                      , // 删除一个收货地址(DELETE)
    
    //订单
    NetOrderRequestType_GetOrderList                               , // 获取订单列表（GET）
    NetOrderRequestType_GetOneOrder                                , // 获取单个订单详细信息（GET）
    NetOrderRequestType_GetOrderRead                               , // 订单填写获取地址、支付方式、发票、快递信息
    NetOrderRequestType_PostSubmitOrder                            , // 提交订单 (POST)
    
    // 优惠
    NetPreferentialRequestType_GetAllPreferentialData              , // 获取所有优惠列表(GET)
    
    // FAQ
    NetFAQRequestType_GetAllFAQData                                , // 获取所有FAQ列表(GET)
    
    // home
    NetHomeRequestType_GetPrograms                                 , // 获取主页面数据(GET)
    
    // 168小时
    Net168HourRequestType_GetAllPromotions                         , // 获取168小时的所有活动数据(GET)
    
    // 上传deviceToken
    NetUploadDeviceTokenRequestType_UploadDeviceToken              , // 上传deviceToken
    
} NetRequestType;

@interface BaseNetworkViewController (NetRequestManager)

// 根据请求类型获得地址
+ (NSString *)getRequestURLStr:(NetRequestType)requestType;

@end

