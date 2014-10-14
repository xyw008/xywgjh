//
//  NSObject+QFramework.h
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QConstant.h"
#import "QSignalManager.h"

@interface NSObject (QFramework)

- (void)addSignalObserver;
- (void)removeSignalObserver;

- (void)sendSignal:(QSignal *)signal;
- (void)receiveSignal:(QSignal *)signal;

@end
