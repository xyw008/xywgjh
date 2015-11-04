//
//  GCDThread.h
//  o2o
//
//  Created by swift on 14-7-16.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDThread : NSObject

+ (dispatch_queue_t)foreQueue;
+ (dispatch_queue_t)backQueue;

+ (void)enqueueForeground:(dispatch_block_t)block;
+ (void)enqueueBackground:(dispatch_block_t)block;
+ (void)enqueueForegroundWithDelay:(int64_t)delaySencond block:(dispatch_block_t)block;
+ (void)enqueueBackgroundWithDelay:(int64_t)delaySencond block:(dispatch_block_t)block;

@end
