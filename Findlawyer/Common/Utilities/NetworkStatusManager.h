//
//  NetworkStatusManager.h
//  offlineTemplate
//
//  Created by admin on 13-12-04.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

/*
typedef enum
{
	/// 无网络连接
	NetworkStatus_NotReachable,
    /// wifi连接
	NetworkStatus_ReachableViaWiFi,
    /// 移动网络连接
	NetworkStatus_ReachableViaWWAN
	
}NetworkStatus;
*/

@interface NetworkStatusManager : NSObject

/**
 * 方法描述: 开启网络状态监听
 * 输入参数: 无
 * 返回值: BOOL
 * 创建人: 龚俊慧
 * 创建时间: 2013-12-04
 */
+ (BOOL)startNetworkStatusNotifier;

/**
 * 方法描述: 获得当前的网络状态
 * 输入参数: 无
 * 返回值: NetworkStatus
 * 创建人: 龚俊慧
 * 创建时间: 2013-12-04
 */
+ (NetworkStatus)getNetworkStatus;

/**
 @ 方法描述    是否链接网络
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      龚俊慧
 @ 创建时间    2014-06-07
 */
+ (BOOL)isConnectNetwork;

/**
 @ 方法描述    是否3G/2G
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      龚俊慧
 @ 创建时间    2014-06-07
 */
+ (BOOL)isEnableWWAN;

/**
 @ 方法描述    是否WIFI
 @ 输入参数    无
 @ 返回值      BOOL
 @ 创建人      龚俊慧
 @ 创建时间    2014-06-07
 */
+ (BOOL)isEnableWIFI;

@end
