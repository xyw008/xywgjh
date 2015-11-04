//
//  UrlManager.h
//  offlineTemplate
//
//  Created by admin on 13-4-15.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlManager : NSObject

/**
 * 方法描述: 获得服务器请求域名
 * 输入参数: 无
 * 返回值: NSString
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (NSString *)getRequestNameSpace;

/**
 * 方法描述: 获得服务器图片域名
 * 输入参数: 无
 * 返回值: NSString
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (NSString *)getImageNameSpace;

/**
 * 方法描述: 获得服务器请求URL地址
 * 输入参数: 请求方法
 * 返回值: NSURL
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName;

/**
 @ 方法描述    获得GET方式请求的URL地址
 @ 输入参数    methodName: 请求方法名 argsDic: 拼装在URL里的参数(以键值对方式传入)
 @ 返回值      NSURL
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-24
 */
+ (NSURL *)getRequestUrlByMethodName:(NSString *)methodName andArgsDic:(NSDictionary *)dic;

/**
 @ 方法描述    组装image请求的URL
 @ 输入参数    nameSpace: 请求域名 urlComponent: URL组成部分
 @ 返回值      NSString
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-20
 */
+ (NSString *)getImageRequestUrlStrByUrlComponent:(NSString *)urlComponent;
+ (NSString *)getImageRequestUrlStrByNameSpace:(NSString *)nameSpace urlComponent:(NSString *)urlComponent;

@end
