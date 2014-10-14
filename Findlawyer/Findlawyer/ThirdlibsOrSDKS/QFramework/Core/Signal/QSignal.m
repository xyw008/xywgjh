//
//  ECSignal.m
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import "QSignal.h"

@implementation QSignal

+ (QSignal *)signalWithName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
    QSignal *signal = [[QSignal alloc] init];
    signal.name = name;
    signal.userInfo = userInfo;
    return signal;
}

@end
