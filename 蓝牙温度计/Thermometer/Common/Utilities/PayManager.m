//
//  PayManager.m
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "PayManager.h"
#import "InterfaceHUDManager.h"

#define kWXPayRequestTag_GetToken       1000 // 获取access_toke
#define kWXPayRequestTag_GetProductArgs 1001 // 从自己的服务器获取生成预支付订单时的必要参数
#define kWXPayRequestTag_GenPrepay      1002 // 生成预支付订单

@implementation Product

@end

@interface PayManager ()
{
    PayPlatform _platform;
    Product     *_toPayProduct;
}

@property (nonatomic, copy) CompleteHandle completeHandle;

// 微信支付参数
/*
 由于微信支付有部分工作需要服务器来做故这里只是放一个示例,以助大家了解整个过程,实际开发中不能这么做
 微信支付过程
 1.获取accessToken
 2.获取prepayId
 3.构造支付请求(PayReq)，支付
 4.支付结束回调
 */
@property (nonatomic, copy) NSString *traceId;     // 商家对用户的唯一标识,如果用微信 SSO,此处建议填写 授权用户的 openid
@property (nonatomic, copy) NSString *timeStamp;   // 时间戳,为 1970 年 1 月 1 日 00:00 到请求发起时间的秒数
@property (nonatomic, copy) NSString *nonceStr;    // 32位内的随机串,防重发
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NSDictionary *productArgs;

@end

@implementation PayManager

DEF_SINGLETON(PayManager);

- (void)payOrderWithProduct:(Product *)product payPlatform:(PayPlatform)platform completeHandle:(CompleteHandle)handle
{
    if (!product) return;
    
    self.completeHandle = handle;
    _platform = platform;
    _toPayProduct = product;
    
    switch (platform)
    {
        case PayPlatform_Alipay:
        {
            /*
            NSString *appScheme = @"o2o";
            NSString *orderInfo = [self getOrderInfoWithProduct:product];
            
            NSString *signedStr = [self doRsa:orderInfo];
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderInfo, signedStr, @"RSA"];
            
            [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
             */
        }
            break;
            
        case PayPlatform_WeChat:
        {
            [self wxPayAction];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 支付宝相关方法 /////////////////////////////////////////////////////////
/*
// 校验支付结果
- (void)verifyPayResultWithResultStr:(NSString *)str
{
    // 结果处理
    AlixPayResult *result = [[AlixPayResult alloc] initWithString:str];
    
    if (result)
    {
        // 成功
        if (result.statusCode == 9000)
        {
            // 用公钥验证签名 严格验证请使用result.resultString与result.signString验签
            
            // 交易成功
            NSString* key = AlipayPubKey;   // 签约帐户后获取到的支付宝公钥
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
            
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                // 验证签名成功,交易结果无篡改
                if (_completeHandle) _completeHandle(PayResultStatusCode_Success);
            }
        }
        // 用户中途取消
        else if (result.statusCode == 6001)
        {
            if (_completeHandle) _completeHandle(PayResultStatusCode_UserCancel);
        }
        // 网络连接出错
        else if (result.statusCode == 6002)
        {
            if (_completeHandle) _completeHandle(PayResultStatusCode_NetworkConnectionError);
        }
        // 交易失败
        else if (result.statusCode == 4000)
        {
            if (_completeHandle) _completeHandle(PayResultStatusCode_Failed);
        }
    }
    else
    {
        // 失败
        if (_completeHandle) _completeHandle(PayResultStatusCode_Failed);
    }
}
*/
// 独立客户端支付结果检验
- (BOOL)verifyPayResultWithHandleOpenURL:(NSURL *)url
{
    switch (_platform)
    {
        case PayPlatform_Alipay:
        {
            /*
            NSString *query = nil;
            
            if (url != nil && [[url host] compare:@"safepay"] == 0)
            {
                query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
            [self verifyPayResultWithResultStr:query];
             */
        }
            break;
            
        case PayPlatform_WeChat:
        {
            return [WXApi handleOpenURL:url delegate:self];
        }
            break;
            
        default:
            break;
    }
    return YES;
}
/*
// wap网页版回调函数
- (void)paymentResult:(NSString *)resultd
{
    [self verifyPayResultWithResultStr:resultd];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 生成订单
- (NSString*)getOrderInfoWithProduct:(Product *)product
{
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    // order.tradeNO = [self generateTradeNO];                          // 生成订单ID(由商家自行制定)
     
    order.tradeNO = product.orderId;
    order.productName = product.productName;                            // 商品名称
    order.productDescription = product.productDesc;                     // 商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",product.price];   // 商品价格
    order.notifyURL = @"http%3A%2F%2F125.89.8.15:9999/pay/notify";      // 回调URL
    
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
*/

#pragma mark - 微信支付相关方法 /////////////////////////////////////////////////////////

- (void)sendRequestWithUrl:(NSURL *)url parameterDic:(NSDictionary *)parameterDic methodType:(NSString *)methodType tag:(NSInteger)tag
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.tag = tag;
    request.delegate = self;
    [request setRequestMethod:methodType];
    
    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding([request stringEncoding]));
    
    if ([methodType isEqualToString:RequestMethodType_GET])
    {
        [request addRequestHeader:@"Content-Type"
                            value:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@",charset]];
    }
    else
    {
        [request addRequestHeader:@"Content-Type"
                            value:[NSString stringWithFormat:@"application/json; charset=%@",charset]];
        
        // 以对象方式设置请求消息体
        if ([parameterDic isAbsoluteValid])
        {
            NSString *postBodyStr = [parameterDic jsonStringByError:NULL];
            NSData *postBodyData = [postBodyStr dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setPostBody:[NSMutableData dataWithData:postBodyData]];
        }
    }
    [request startAsynchronous];
}

- (void)wxPayAction
{
    NSString *strUrl = @"https://api.weixin.qq.com/cgi-bin/token";
    
    NSDictionary *param = @{@"appid": kWXAppID,
                            @"secret": kWXAppSecret,
                            @"grant_type": @"client_credential"};
    NSString *urlStr = [strUrl stringByAppendingFormat:@"?%@",[NSString urlArgsStringFromDictionary:param]];
    
    [self sendRequestWithUrl:[NSURL URLWithString:urlStr]
                parameterDic:nil
                  methodType:RequestMethodType_GET
                         tag:kWXPayRequestTag_GetToken];
}

//- (void)getProductArgs
//{
//    // http://mp.sephome.cn/openapi/wcpay/getWCPayRequestData
//    // orderNo,body,totalFee
//    
//    NSMutableDictionary *postDataDic = [NSMutableDictionary dictionary];
//    [postDataDic setObject:_toPayProduct.orderId forKey:@"orderNo"];
//    [postDataDic setObject:_toPayProduct.productName forKey:@"body"];
//    [postDataDic setObject:[NSString stringWithFormat:@"%.0lf", _toPayProduct.price * 100] forKey:@"totalFee"];
//    [postDataDic setObject:[self genMD5Sign:postDataDic] forKey:@"sign"];
//    
//    [self sendRequestWithUrl:[NSURL URLWithString:@"http://appmp.vmei.com/openapi/wcpay/getWCPayRequestData"]
//                parameterDic:postDataDic
//                  methodType:RequestMethodType_POST
//                         tag:kWXPayRequestTag_GetProductArgs];
//    /*
//    [self sendRequestWithUrl:[NSURL URLWithString:@"http://mp.sephome.cn/openapi/wcpay/getWCPayRequestData"]
//                parameterDic:postDataDic
//                  methodType:RequestMethodType_POST
//                         tag:kWXPayRequestTag_GetProductArgs];
//     */
//}

- (void)prepay
{
    // https://api.weixin.qq.com/pay/genprepay?access_token=ACCESS_TOKEN
    
    NSDictionary *postDataDic = [self getProductArgs];
     
    NSString *strUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?&access_token=%@",_accessToken];
    
    [self sendRequestWithUrl:[NSURL URLWithString:strUrl]
                parameterDic:postDataDic
                  methodType:RequestMethodType_POST
                         tag:kWXPayRequestTag_GenPrepay];
}
/*
 app_signature 生成方法:  [self genSign:params]
 A)参与签名的字段包括:appid、appkey、noncer、package、timestamp 以及 traceid
 B)对所有待签名参数按照字段名的 ASCII 码从小到大排序(字典序)后,使用 URL 键值对的 格式(即 key1=value1&key2=value2...)拼接成字符串 string1。 注意:所有参数名均为小写字符
 C)对 string1 作签名算法,字段名和字段值都采用原始值,不进行 URL 转义。具体签名算法 为 SHA1
 */

- (NSDictionary *)getProductArgs
{
    self.timeStamp = [self genTimeStamp];
    self.nonceStr = [self genNonceStr];
    // traceId 由开发者自定义，可用于订单的查询与跟踪，建议根据支付用户信息生成此id
    self.traceId = [self genTraceId];
    self.package = [self genPackage];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kWXAppID forKey:@"appid"];
    [params setObject:kWXAppKey forKey:@"appkey"];
    [params setObject:self.nonceStr forKey:@"noncestr"];
    [params setObject:self.timeStamp forKey:@"timestamp"];
    [params setObject:self.traceId forKey:@"traceid"];
    [params setObject:self.package forKey:@"package"];
    [params setObject:[self genSign:params] forKey:@"app_signature"];
    [params setObject:@"sha1" forKey:@"sign_method"];
    
 
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: &error];
//    NSLog(@"--- ProductArgs: %@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    return [NSMutableData dataWithData:jsonData];
 
    return params;
}


#pragma mark  开始支付
- (void)pay
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        //构造支付请求
        PayReq *request = [[PayReq alloc]init];
        // request.openID = kWXAppID;
        request.partnerId = kWXPartnerId;
        request.prepayId = self.prepayid;
        request.package = @"Sign=WXPay";
        
        request.nonceStr = self.nonceStr;
        request.timeStamp = [self.timeStamp integerValue];
         
        /*
        request.nonceStr = [_productArgs safeObjectForKey:@"noncestr"];
        request.timeStamp = [[_productArgs safeObjectForKey:@"timestamp"] integerValue];
        */
        //构造参数列表
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:kWXAppID forKey:@"appid"];
        [params setObject:kWXAppKey forKey:@"appkey"];
        [params setObject:request.nonceStr forKey:@"noncestr"];
        [params setObject:request.package forKey:@"package"];
        [params setObject:request.partnerId forKey:@"partnerid"];
        [params setObject:request.prepayId forKey:@"prepayid"];
        [params setObject:[NSString stringWithFormat:@"%ld", request.timeStamp] forKey:@"timestamp"];
        request.sign = [self genSign:params];
        
        [WXApi sendReq:request];
    }
    else
    {
        if (_completeHandle) _completeHandle(PayResultStatusCode_Failed);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"亲,你还没有安装客户端,无法进行支付哦!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

//MARK: 注意:不能hardcode在客户端,建议genPackage这个过程都由服务器端完成
- (NSString *)genPackage
{
    // 构造参数列表
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"WX" forKey:@"bank_type"];
    [params setObject:_toPayProduct.productName forKey:@"body"];
    [params setObject:@"1" forKey:@"fee_type"];
    [params setObject:@"UTF-8" forKey:@"input_charset"];
    // [params setObject:@"http://appmp.vmei.com/wcpay/notify/app" forKey:@"notify_url"];
    [params setObject:@"http://mp.vmei.com/wcpay/notify/app" forKey:@"notify_url"];
    // [params setObject:[self genOutTradNo] forKey:@"out_trade_no"];
    [params setObject:_toPayProduct.orderId forKey:@"out_trade_no"];
    [params setObject:kWXPartnerId forKey:@"partner"];
    [params setObject:[CommonUtil getIPAddress:YES] forKey:@"spbill_create_ip"];
    [params setObject:[NSString stringWithFormat:@"%.0lf", _toPayProduct.price * 100] forKey:@"total_fee"]; // 微信支付单位是"分"
    
    NSArray *allKeys =nil;
    allKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        NSComparisonResult comRes = [str1 compare:str2 ];
        return comRes;
    }];
    
    // 生成 packageSign
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in allKeys)
    {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    [package appendString:@"key="];
    
    [package appendString:kWXPartnerKey];
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    package = nil;
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in allKeys)
    {
        [package appendString:key];
        [package appendString:@"="];
        value = [params objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)value, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    
    NSLog(@"--- Package: %@", result);
    return result;
}

//MARK: 时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

//MARK: 建议 traceid 字段包含用户信息及订单信息，方便后续对订单状态的查询和跟踪

- (NSString *)genTraceId
{
    return [NSString stringWithFormat:@"crestxu_%@", [self genTimeStamp]];
}

//MARK: sign
- (NSString *)genSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys)
    {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    NSString *result = [CommonUtil sha1:signString];
    NSLog(@"--- Gen sign: %@", result);
    return result;
}

//MARK: sign MD5
- (NSString *)genMD5Sign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys)
    {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    NSString *result = [[CommonUtil md5:signString] uppercaseString];
   
    return result;
}


/**
 * 注意: 商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)genOutTradNo
{
    return [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

#pragma mark - WXApiDelegate methods

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        
        switch (response.errCode)
        {
            // 成功
            case WXSuccess:
            {
                if (_completeHandle) _completeHandle(PayResultStatusCode_Success);
            }
                break;
            // 用户中途取消
            case WXErrCodeUserCancel:
            {
                if (_completeHandle) _completeHandle(PayResultStatusCode_UserCancel);
            }
                break;
            // 网络连接出错
            case WXErrCodeSentFail:
            {
                if (_completeHandle) _completeHandle(PayResultStatusCode_NetworkConnectionError);
            }
                break;
            // 失败
            default:
            {
                if (_completeHandle) _completeHandle(PayResultStatusCode_Failed);
            }
                break;
        }
    }
}

#pragma mark - NetRequestDelegate methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (200 == request.responseStatusCode)
    {
        id infoObj = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL];
        DLog(@"%@",infoObj);

        if (kWXPayRequestTag_GetToken == request.tag)
        {
            self.accessToken = [infoObj safeObjectForKey:@"access_token"];
            
            [self prepay];
             /*
            [self getProductArgs];
              */
        }
        else if (kWXPayRequestTag_GetProductArgs == request.tag)
        {
            self.productArgs = infoObj;
            
            [self prepay];
        }
        else if (kWXPayRequestTag_GenPrepay == request.tag)
        {
            NSInteger errorCode = [[infoObj safeObjectForKey:@"errcode"] intValue];
            
            if (0 == errorCode)
            {
                self.prepayid = [infoObj safeObjectForKey:@"prepayid"];
                
                [self pay];
            }
            else
            {
                DLog(@"%@",[infoObj safeObjectForKey:@"errmsg"]);
                
                if (_completeHandle) _completeHandle(PayResultStatusCode_Failed);
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    DLog(@"%@",request.error);
    
    if (_completeHandle) _completeHandle(PayResultStatusCode_NetworkConnectionError);
}

@end
