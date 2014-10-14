//
//  ATBLibs+NSString.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+NSDate.h"

@implementation  NSDate(ATBLibsAddtions)

+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString *)formatter
{
    if (!date || !formatter || 0 == formatter.length) return nil;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formatter];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)timeIntervalStringSinceNowWithCompareTime:(NSTimeInterval)toCompareTime
{
    if (0 == toCompareTime) return nil;
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    
    //以分钟显示
    if ((time - toCompareTime) >= 0 && (time - toCompareTime) < 60 * 1)
    {
        return @"刚刚";
    }
    //大于1分钟小于一个小时
    else if ((time - toCompareTime) >= 60 * 1 && (time - toCompareTime) < 60 * 60)
    {
        int mimuteNum = (time - toCompareTime) / 60;
        
        return [NSString stringWithFormat:@"%d分钟前",mimuteNum];
    }
    //以小时钟显示(大于1个小时小于24个小时)
    else if ((time - toCompareTime) >= 60 * 60 && (time - toCompareTime) < 60 * 60 * 24)
    {
        int hourNum = (time - toCompareTime) / (60 * 60);
        
        return [NSString stringWithFormat:@"%d小时前",hourNum];
    }
    //以日期格式显示(大于24个小时)
    else
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:toCompareTime];
        return [self stringFromDate:date withFormatter:@"yyyy-MM-dd"];
    }
}

@end







