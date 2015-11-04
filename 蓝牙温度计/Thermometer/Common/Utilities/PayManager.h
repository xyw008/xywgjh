//
//  PayManager.h
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>

// 支付宝头文件
/*
 #import "AlixLibService.h"
 #import "DataSigner.h"
 #import "AlixPayResult.h"
 #import "DataVerifier.h"
 #import "AlixPayOrder.h"
 */

// 微信支付头文件
#import "WXApi.h"
#import "WXApiObject.h"

#import "CommonUtil.h"
#import "UrlManager.h"
#import "ASIFormDataRequest.h"

//////////////////////////////////////--支付宝支付配置相关--//////////////////////////////////////////

// 合作身份者id,以2088开头的16位纯数字
#define PartnerID       @""
// 收款支付宝账号
#define SellerID        @""
/*
 // 安全校验码（MD5）密钥,以数字和字母组成的32位字符
 #define MD5_KEY         @""
 */
// 商户私钥,自助生成
#define PartnerPrivKey  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOEoOCAtSR8L7DVaRUdmMtoCgY4JchBFymXatEnQAZk4lGAXEDs3/lfgY9UAgURhbITo9GSr8GCckCxJG7Ozleb6diuqiJPkqwJq2rl4A7YbrgQRRjUdxkpUyynFiB6WuIRe7Bs3B+DqH/NdlG+uvbf9qnktmUjqCN1IePxd3GvlAgMBAAECgYAH9O/m0zLeUgGK8SG5oDbz1VrWtia9xHmel9f/M8aar5EuxCHitdvbJybgBCCNVhQLrl/Unu7juyStK/g6pYIKkpxNR6feeyydXgaMxc7+tzVnnmJKumOTJZdY56M1S8eP7BK4TiFK2rStj6WFRTpwiA8SdCa6HGIWG2xFpC3akQJBAPkuOzcxJ3NwzLMvtV+iYBtZkbfEUoLIN5O1gBtM5NkM1iSxw56S0go0ZRn/ishkvuBFxarf9e24ZkAV2JS/0+8CQQDnUa2xHURQKqzNyMW2sU49xjTqUZGeRmorXXS4Xg0yTRhhuoV7+81wHClredJ32B2JUdqBRFlGIVKcPeHbS5lrAkEA1Z6EtXQ2VglF8/fajfouWkQXYGu2MNhkjQT0pnLtXgZbL2oWQkOsPYNdiURCPjngSXSHWU5XD00em6Ie4qbxkQJAUz/ABPgFd9yD6GOTVFanU/AbZyEICTBKUWUG9rtSgIHifnmERMSwgOKBvZ5QMrVim+MLgm44utaPRo+20xd4FQJBAK6JkWU3AYHYLg81l7QI0DGgwy7zpzp10UOMyuR0bf/VMPG0nvCp4gvxXF6wtzCnEc1qoYF3KVuYcf0Rni/R8SY="
// 支付宝公钥
#define AlipayPubKey    @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

//////////////////////////////////////--微信支付配置相关--//////////////////////////////////////////

/*
 微信支付参数:
 注意: 参数需要你自己提供
 */
#define kWXAppID        @"wxd752190116b2cdd0"
#define kWXAppSecret    @"f3506b49851b7ada4378eaa20029b36d"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意: 不能hardcode在客户端,建议genSign这个过程由服务器端完成
 */
#define kWXPartnerKey   @"f17b19f78f33cb1d7b6537eedcb21cbd"

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意: 不能hardcode在客户端,建议genSign这个过程由服务器端完成
 */
#define kWXAppKey @"ouyzPBVtlJi1iAlwIG75za9uXiKs0bkLEPfgMH3myU9kwLaIRo8MTymgrwPhF18hryL99IGi6smO2g7IEAjsrMpxTvClXXSQ0si1fAERVJeMRb1KaHC9WCo75gHieMNr"

/**
 *  微信公众平台商户模块生成的ID
 */
#define kWXPartnerId    @"1227214201"

typedef NS_ENUM(NSInteger, PayPlatform)
{
    /// 支付宝
    PayPlatform_Alipay = 0,
    /// 微信
    PayPlatform_WeChat,
    /*
    /// 银联
    PayPlatform_ChinaUnionPay
     */
};

typedef NS_ENUM(NSInteger, PayResultStatusCode)
{
    /// 支付成功
    PayResultStatusCode_Success = 0,
    /// 支付失败
    PayResultStatusCode_Failed,
    /// 用户中途取消
    PayResultStatusCode_UserCancel,
    /// 网络连接出错
    PayResultStatusCode_NetworkConnectionError
};

typedef void (^CompleteHandle) (PayResultStatusCode statusCode);

////////////////////////////////////////////////////////////////////////////////

@interface Product : NSObject

@property (nonatomic, assign) double   price;           // 商品价格(单位: 元)
@property (nonatomic, copy)   NSString *productName;    // 商品名称
@property (nonatomic, copy)   NSString *productDesc;    // 商品描述
@property (nonatomic, copy)   NSString *orderId;        // 订单ID

@end

////////////////////////////////////////////////////////////////////////////////

@interface PayManager : NSObject <WXApiDelegate, ASIHTTPRequestDelegate>

AS_SINGLETON(PayManager);

/// 支付
- (void)payOrderWithProduct:(Product *)product payPlatform:(PayPlatform)platform completeHandle:(CompleteHandle)handle;

/// 独立客户端支付结果检验
- (BOOL)verifyPayResultWithHandleOpenURL:(NSURL *)url;

@end
