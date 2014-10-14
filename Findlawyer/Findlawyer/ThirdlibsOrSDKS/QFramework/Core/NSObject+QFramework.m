//
//  NSObject+QFramework.m
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import "NSObject+QFramework.h"

@implementation NSObject (QFramework)

- (void)addSignalObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSignal:) name:Q_SIGNAL_SYSTEM object:nil];
}

- (void)removeSignalObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Q_SIGNAL_SYSTEM object:nil];
}

- (void)handleSignal:(NSNotification *)notification
{
    QSignal *signal = notification.userInfo[@"signal"];
    [self receiveSignal:signal];
}

- (void)sendSignal:(QSignal *)signal
{
    [[QSignalManager defaultManager] send:signal];
}

- (void)receiveSignal:(QSignal *)signal
{
    [[QSignalManager defaultManager] receive:signal];
}

@end
