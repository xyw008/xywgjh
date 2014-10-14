//
//  NetworkStatusManager.m
//  offlineTemplate
//
//  Created by admin on 13-12-04.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "NetworkStatusManager.h"

static NetworkStatus staticCurrentNetworkStatus; // 当前网络连接
static Reachability *hostReachbility;            // 检测网络实例需要强引用

@interface NetworkStatusManager ()

@end

@implementation NetworkStatusManager

+ (BOOL)startNetworkStatusNotifier
{
    // 检测设备网络状态
    hostReachbility = [Reachability reachabilityWithHostName:@"www.baidu.com"]; // 可以以多种形式初始化
    
    // 获得设备现在的网络状态
    staticCurrentNetworkStatus = [hostReachbility currentReachabilityStatus];
    
    // 开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    return [hostReachbility startNotifier];  // 开始监听,会启动一个run loop
}

// 处理连接改变后的情况
+ (void)updateInterfaceWithReachability:(Reachability *)curReach
{
    staticCurrentNetworkStatus = [curReach currentReachabilityStatus];
}

// 连接改变
+ (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}

+ (NetworkStatus)getNetworkStatus
{
    return staticCurrentNetworkStatus;
}

+ (BOOL)isConnectNetwork
{
    return staticCurrentNetworkStatus != kNotReachable;
}

+ (BOOL)isEnableWWAN
{
    return staticCurrentNetworkStatus == kReachableViaWWAN;
}

+ (BOOL)isEnableWIFI
{
    return staticCurrentNetworkStatus == kReachableViaWiFi;
}

@end
