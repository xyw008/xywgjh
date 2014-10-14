//
//  NSString+TimeFormat.m
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.

#import "NSString+TimeFormat.h"
#import "NSDate-Utilities.h"

@implementation NSString (TimeFormat)

+ (NSString *)formatDate:(NSDate *)date
{
    NSString *timeStr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([date isToday])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeStr = [dateFormatter stringFromDate:date];
        
        /*
         if (date.hour >=0 && date.hour <= 12)
         {
         timeStr = [NSString stringWithFormat:@"上午 %@", [dateFormatter stringFromDate:date]];
         }
         else if (date.hour > 12 && date.hour < 14)
         {
         timeStr = [NSString stringWithFormat:@"中午 %@", [dateFormatter stringFromDate:date]];
         
         }
         else if (date.hour >= 14 && date.hour <= 18)
         {
         timeStr = [NSString stringWithFormat:@"下午 %@", [dateFormatter stringFromDate:date]];
         
         }
         else
         {
         timeStr = [NSString stringWithFormat:@"晚上 %@", [dateFormatter stringFromDate:date]];
         }*/
    }
    else if ([date isYesterday])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeStr = [[NSString alloc] initWithFormat:@"昨天 %@", [dateFormatter stringFromDate:date]];
    }
    else
    {
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        timeStr = [dateFormatter stringFromDate:date];
    }
    return timeStr;
}

+ (NSString *)formatTime:(NSDate *)date
{
    NSString *timeStr = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([date isToday])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
        timeStr = [dateFormatter stringFromDate:date];
    }
    else if ([date isYesterday])
    {
        timeStr = @"昨天";
    }
    else
    {
        //[dateFormatter setDateFormat:@"MM-dd HH:mm"]; // 新需要，不需要显示具体时间 2014/06/11 by qinwenzhou
        [dateFormatter setDateFormat:@"MM-dd"];
        timeStr = [dateFormatter stringFromDate:date];
    }
    
    return timeStr;
}

+ (NSString *)formatDuration:(NSTimeInterval)duration
{
    if (duration > 20 * 60.0)  // 20分钟
    {
        return @"超过20分钟";
    }
    else
    {
        NSString *timeStr = nil;
        NSInteger dur = (NSInteger)duration;
        NSInteger m = dur / 60;
        NSInteger s = dur % 60;
        timeStr = [NSString stringWithFormat:@"%d分%d秒", m, s];
        return timeStr;
    }
}

@end
