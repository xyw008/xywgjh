//
//  CrossBorderAlipayManager.m
//  Sephome
//
//  Created by swift on 15/1/7.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "CrossBorderAlipayManager.h"

// 支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

// 支付宝
// 合作身份者id，以2088开头的16位纯数字
#define PartnerID       @"2088111476503055"
// 收款支付宝账号
#define SellerID        @"sephome_tmall@yahoo.com.hk"
/*
 // 安全校验码（MD5）密钥，以数字和字母组成的32位字符
 #define MD5_KEY         @""
 */
// 商户私钥，自助生成
#define PartnerPrivKey  @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOEoOCAtSR8L7DVaRUdmMtoCgY4JchBFymXatEnQAZk4lGAXEDs3/lfgY9UAgURhbITo9GSr8GCckCxJG7Ozleb6diuqiJPkqwJq2rl4A7YbrgQRRjUdxkpUyynFiB6WuIRe7Bs3B+DqH/NdlG+uvbf9qnktmUjqCN1IePxd3GvlAgMBAAECgYAH9O/m0zLeUgGK8SG5oDbz1VrWtia9xHmel9f/M8aar5EuxCHitdvbJybgBCCNVhQLrl/Unu7juyStK/g6pYIKkpxNR6feeyydXgaMxc7+tzVnnmJKumOTJZdY56M1S8eP7BK4TiFK2rStj6WFRTpwiA8SdCa6HGIWG2xFpC3akQJBAPkuOzcxJ3NwzLMvtV+iYBtZkbfEUoLIN5O1gBtM5NkM1iSxw56S0go0ZRn/ishkvuBFxarf9e24ZkAV2JS/0+8CQQDnUa2xHURQKqzNyMW2sU49xjTqUZGeRmorXXS4Xg0yTRhhuoV7+81wHClredJ32B2JUdqBRFlGIVKcPeHbS5lrAkEA1Z6EtXQ2VglF8/fajfouWkQXYGu2MNhkjQT0pnLtXgZbL2oWQkOsPYNdiURCPjngSXSHWU5XD00em6Ie4qbxkQJAUz/ABPgFd9yD6GOTVFanU/AbZyEICTBKUWUG9rtSgIHifnmERMSwgOKBvZ5QMrVim+MLgm44utaPRo+20xd4FQJBAK6JkWU3AYHYLg81l7QI0DGgwy7zpzp10UOMyuR0bf/VMPG0nvCp4gvxXF6wtzCnEc1qoYF3KVuYcf0Rni/R8SY="
// 支付宝公钥
#define AlipayPubKey    @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

@implementation CrossBorderAlipayProduct

@end

@interface CrossBorderAlipayManager ()
{
    
}

@property (nonatomic, copy) AlipayCompleteHandle completeHandle;

@end

@implementation CrossBorderAlipayManager

DEF_SINGLETON(CrossBorderAlipayManager);

- (void)payOrderWithProduct:(CrossBorderAlipayProduct *)product completeHandle:(AlipayCompleteHandle)handle;
{
    if (product)
    {
        self.completeHandle = handle;

        NSString *appScheme = @"Sephome";
        NSString *orderInfo = [self getOrderInfoWithProduct:product];
        
        NSString *signedStr = [self doRsa:orderInfo];
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                 orderInfo, signedStr, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString
                                  fromScheme:appScheme
                                    callback:^(NSDictionary *resultDic) {
            
            [self verifyPayResultWithResultDic:resultDic];
        }];
    }
}

#pragma mark - 支付宝相关方法

// 校验支付结果
- (void)verifyPayResultWithResultDic:(NSDictionary *)resultDic
{
    // 结果处理
    NSInteger resultStatusCode = [[resultDic safeObjectForKey:@"resultStatus"] integerValue];
    
    // 成功
    if (resultStatusCode == 9000)
    {
        if (_completeHandle) _completeHandle(AlipayResultStatusCode_Success);
    }
    // 用户中途取消
    else if (resultStatusCode == 6001)
    {
        if (_completeHandle) _completeHandle(AlipayResultStatusCode_UserCancel);
    }
    // 网络连接出错
    else if (resultStatusCode == 6002)
    {
        if (_completeHandle) _completeHandle(AlipayResultStatusCode_NetworkConnectionError);
    }
    // 交易失败
    else if (resultStatusCode == 4000)
    {
        if (_completeHandle) _completeHandle(AlipayResultStatusCode_Failed);
    }
}

// 独立客户端支付结果检验
- (void)verifyPayResultWithHandleOpenURL:(NSURL *)url
{
    // 跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
            
            [self verifyPayResultWithResultDic:resultDic];
        }];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 生成订单
- (NSString*)getOrderInfoWithProduct:(CrossBorderAlipayProduct *)product
{
    
    // 将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    /*
     order.tradeNO = [self generateTradeNO];                             // 生成订单ID(由商家自行制定)
     */
    order.tradeNO = product.orderId;
    order.productName = product.productName;                            // 商品名称
    order.productDescription = product.productDesc;                     // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price];   // 商品价格
    order.notifyURL = @"http%3A%2F%2F125.89.8.15:9999/pay/notify";      // 回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    order.forexBiz = @"FP";
    order.currency = @"HKD";
    
    return [order description];
}

// 加密订单
- (NSString*)doRsa:(NSString *)orderInfo
{
    id<DataSigner> signer;
    signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderInfo];
    return signedString;
}

// 生成订单ID(由商家自行制定)
- (NSString *)generateTradeNO
{
    const int N = 15;
    
    NSString *sourceString = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}

@end
