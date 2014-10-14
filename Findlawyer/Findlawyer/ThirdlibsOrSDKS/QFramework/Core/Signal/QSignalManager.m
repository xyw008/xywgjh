//
//  QSignalManager.m
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import "QSignalManager.h"
#import "QConstant.h"

@implementation QSignalManager

+ (QSignalManager *)defaultManager
{
    static QSignalManager *defaultManager = nil;
    if (!defaultManager)
    {
        defaultManager = [[self alloc] init];
    }
    return defaultManager;
}

- (void)send:(QSignal *)signal
{
    [[NSNotificationCenter defaultCenter] postNotificationName:Q_SIGNAL_SYSTEM object:nil userInfo:@{@"signal": signal}];
}

- (void)receive:(QSignal *)signal
{
    
}

@end
