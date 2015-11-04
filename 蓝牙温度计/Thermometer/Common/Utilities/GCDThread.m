//
//  GCDThread.m
//  o2o
//
//  Created by swift on 14-7-16.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "GCDThread.h"

#define _foreQueue dispatch_get_main_queue()
#define _backQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation GCDThread

+ (dispatch_queue_t)foreQueue
{
	return _foreQueue;
}

+ (dispatch_queue_t)backQueue
{
	return _backQueue;
}


+ (void)enqueueForeground:(dispatch_block_t)block
{
	dispatch_async( _foreQueue, block );
}

+ (void)enqueueBackground:(dispatch_block_t)block
{
	dispatch_async( _backQueue, block );
}

+ (void)enqueueForegroundWithDelay:(int64_t)delaySencond block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delaySencond * NSEC_PER_SEC);
	dispatch_after( time, _foreQueue, block );
}

+ (void)enqueueBackgroundWithDelay:(int64_t)delaySencond block:(dispatch_block_t)block
{
	dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delaySencond * NSEC_PER_SEC);
	dispatch_after( time, _backQueue, block );
}

@end
