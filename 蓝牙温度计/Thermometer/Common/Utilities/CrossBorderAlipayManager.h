//
//  CrossBorderAlipayManager.h
//  Sephome
//
//  Created by swift on 15/1/7.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AlipayResultStatusCode)
{
    /// 支付成功
    AlipayResultStatusCode_Success = 0,
    /// 支付失败
    AlipayResultStatusCode_Failed,
    /// 用户中途取消
    AlipayResultStatusCode_UserCancel,
    /// 网络连接出错
    AlipayResultStatusCode_NetworkConnectionError
};

typedef void (^AlipayCompleteHandle) (AlipayResultStatusCode statusCode);

@interface CrossBorderAlipayProduct : NSObject

@property (nonatomic, assign) double   price;           // 商品价格(单位: 元)
@property (nonatomic, copy)   NSString *productName;    // 商品名称
@property (nonatomic, copy)   NSString *productDesc;    // 商品描述
@property (nonatomic, copy)   NSString *orderId;        // 订单ID

@end

@interface CrossBorderAlipayManager : NSObject

AS_SINGLETON(CrossBorderAlipayManager);

/// 支付
- (void)payOrderWithProduct:(CrossBorderAlipayProduct *)product completeHandle:(AlipayCompleteHandle)handle;

/// 独立客户端支付结果检验
- (void)verifyPayResultWithHandleOpenURL:(NSURL *)url;

@end
