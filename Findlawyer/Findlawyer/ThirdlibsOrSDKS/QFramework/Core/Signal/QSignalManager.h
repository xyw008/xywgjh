//
//  QSignalManager.h
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSignal.h"
#import "NSObject+QFramework.h"

#define Q_SIGNAL_SYSTEM        @"Q_SIGNAL_SYSTEM"  

@interface QSignalManager : NSObject

+ (QSignalManager *)defaultManager;

- (void)send:(QSignal *)signal;
- (void)receive:(QSignal *)signal;

@end
