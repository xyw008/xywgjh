//
//  KeepLoginSessionConnection.m
//  financialCommunity
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 fanyixing. All rights reserved.
//

#import "KeepLoginSessionConnection.h"
#import "NetRequestManager.h"
#import "UrlManager.h"
#import <AVFoundation/AVFoundation.h>

#define TimerRunTimeInterval 60 * 5 * 0.5       // timer的运行间隔时间

@interface KeepLoginSessionConnection ()<NetRequestDelegate>
{
    BOOL _free;
    BOOL _holding;
    
    NSTimer *backgroundTimer;
    NSTimer *foregroundTimer;
    
    UIBackgroundTaskIdentifier background_task;
}

@end

@implementation KeepLoginSessionConnection

DEF_SINGLETON(KeepLoginSessionConnection);

- (BOOL)isMultitaskingSupported
{
    BOOL result = NO;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
    {
        result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    
    return result;
}

- (void)hold
{
    _holding = YES;
    
    while (_holding)
    {
        [NSThread sleepForTimeInterval:1];
        /** clean the runloop for other source */
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
    }
}

- (void)stopInBackground
{
    _holding = NO;
    
    if (background_task != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:background_task];
        background_task = UIBackgroundTaskInvalid;
    }
    
    if (backgroundTimer)
    {
        [backgroundTimer invalidate];
        backgroundTimer = nil;
    }
}

- (void)runInBackground
{
    UIApplication *application = [UIApplication sharedApplication];
    
    // Create a task object
    background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
        
        /*
        [self hold];
         */
        
        if (background_task != UIBackgroundTaskInvalid)
        {
            [application endBackgroundTask:background_task];
            background_task = UIBackgroundTaskInvalid;
        }
        
        // 递归
        [self runInBackground];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
 
        if (backgroundTimer && [backgroundTimer isValid])
        {
            [backgroundTimer invalidate];
            backgroundTimer = nil;
        }
        
        // 运用timer开始后台任务
        backgroundTimer = [NSTimer scheduledTimerWithTimeInterval:TimerRunTimeInterval target:self selector:@selector(sendTheUniqueRequest) userInfo:nil repeats:YES];
        [backgroundTimer fire];
        
        [[NSRunLoop currentRunLoop] addTimer:backgroundTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
        
        // Do the work associated with the task.
        if (background_task != UIBackgroundTaskInvalid)
        {
            [application endBackgroundTask:background_task];
            background_task = UIBackgroundTaskInvalid;
        }
    });
}

// 开始前台运行
- (void)runInForeground
{
    if (!foregroundTimer)
    {
        foregroundTimer = [NSTimer scheduledTimerWithTimeInterval:TimerRunTimeInterval target:self selector:@selector(sendTheUniqueRequest) userInfo:nil repeats:YES];
        
        [foregroundTimer fire];
        
//        [[NSRunLoop currentRunLoop] addTimer:foregroundTimer forMode:NSRunLoopCommonModes];
//        [[NSRunLoop currentRunLoop] run];
    }
}

// 停止前台运行
- (void)stopInForeground
{
    if (foregroundTimer)
    {
        [foregroundTimer invalidate];
        foregroundTimer = nil;
    }
}

- (void)keepLoginSessionConnectionWithType:(KeepLoginSessionConnectionType)type
{
    if (KeepLoginSessionConnectionType_Background == type)
    {
        if ([self isMultitaskingSupported])
        {
            [self stopInForeground];
            [self runInBackground];
        }
        else
        {
            return;
        }
    }
    else
    {
        [self stopInBackground];
        [self runInForeground];
    }
}

// 运用轮询请求方式保持会话不过期
- (void)sendTheUniqueRequest
{
    /*
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:1]; //触发通知的时间
        notification.repeatInterval = 0; //循环次数，kCFCalendarUnitWeekday一周一次
        
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody=@"轮询一次";
        
        notification.alertAction = @"打开";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失
        
        // 下面设置本地通知发送的消息，这个消息可以接受
        NSDictionary* infoDic = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
        notification.userInfo = infoDic;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    */
 
    NSURL *url = [UrlManager getRequestUrlByMethodName:@"user/connectionSys"];
    
    [[NetRequestManager sharedInstance] sendRequest:url parameterDic:[NSDictionary dictionary] requestTag:1000 delegate:self userInfo:nil];
}

#pragma mark - NetRequestDelegate methods

- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    
}

- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    
}

/*
- (void)loging
{
    [self sendTheUniqueRequest];
}

- (void)login2
{
   [self sendTheUniqueRequest];
}
 */

@end
