//
//  UrlManager.m
//  offlineTemplate
//
//  Created by admin on 13-4-15.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "UrlManager.h"

@interface UrlManager ()

@end

@implementation UrlManager

+ (NSString *)getRequestNameSpace
{
    // 服务器选择的类型(0:政府外网 1:公司外网)
    NSNumber *serviceSeletedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    
    NSString *nameSpace = nil;
    
//    nameSpace = Request_NameSpace;
    nameSpace = Request_NameSpace_company_internal;
    
//    if (0 == serviceSeletedValue.intValue)
//        nameSpace = Request_NameSpace_gov;
//    else if (1 == serviceSeletedValue.intValue)
//        nameSpace = Request_NameSpace_company_external;
//    else if (2 == serviceSeletedValue.intValue)
//        nameSpace = Request_NameSpace_company_internal;
//    else if (3 == serviceSeletedValue.intValue)
//        nameSpace = Request_NameSpace_company_external_test;
    
    if (nameSpace && 0 != nameSpace.length)
    {
        if (![nameSpace hasSuffix:@"/"])
        {
            return nameSpace;
        }
        else
        {
            return [nameSpace stringByReplacingCharactersInRange:NSMakeRange(nameSpace.length - 1, 1) withString:@""];
        }
    }
    return nil;
}

+ (NSString *)getImageNameSpace
{
    // 服务器选择的类型(0:政府外网 1:公司外网)
    NSNumber *serviceSeletedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    
    NSString *nameSpace = nil;
    
//    nameSpace = Img_NameSpace;
//    nameSpace = Img_NameSpace_company_internal;
    
//    if (0 == serviceSeletedValue.intValue)
//        nameSpace = Img_NameSpace_gov;
//    else if (1 == serviceSeletedValue.intValue)
//        nameSpace = Img_NameSpace_company_external;
//    else if (2 == serviceSeletedValue.intValue)
//        nameSpace = Img_NameSpace_company_internal;
//    else if (3 == serviceSeletedValue.intValue)
//        nameSpace = Img_NameSpace_company_external_test;
    
    if (nameSpace && 0 != nameSpace.length)
    {
        if (![nameSpace hasSuffix:@"/"])
        {
            return nameSpace;
        }
        else
        {
            return [nameSpace stringByReplacingCharactersInRange:NSMakeRange(nameSpace.length - 1, 1) withString:@""];
        }
    }
    return nil;
}

+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName
{
    return [self getRequestUrlByMethodName:methodName andArgsDic:nil];
}

+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDic:(NSDictionary *)dic
{
    NSString *nameSpaceStr = [self getRequestNameSpace];
    
    NSURL *url = nil;
    
    if (nameSpaceStr && 0 != nameSpaceStr.length)
    {
        // 不用stringByAppendingPathComponent:,这个会自动把http://中的一个/去掉
        NSString *urlStr = [nameSpaceStr stringByAppendingFormat:@"/%@",methodName];
        
        if (dic && 0 != dic.count)
        {
            urlStr = [urlStr stringByAppendingFormat:@"?%@",[NSString urlArgsStringFromDictionary:dic]];
        }
        url = [NSURL URLWithString:urlStr];
    }
    return url;
}

@end
