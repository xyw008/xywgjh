//
//  ATBLibs+NSString.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const DataFormatter_DateAndTime   = @"yyyy-MM-dd HH:mm:ss";
static NSString * const DataFormatter_Date          = @"yyyy-MM-dd";
static NSString * const DataFormatter_DateNoYear    = @"MM-dd";
static NSString * const DataFormatter_Time          = @"HH:mm:ss";
static NSString * const DataFormatter_TimeNoSecond  = @"HH:mm";

@interface NSDate(ATBLibsAddtions)

/*
 /// 获取本地当前时间(已转化GMT格林时间差)
 + (NSDate *)nowLocalDate;
 */

/// 按照指定格式将NSDate转字符串
+ (NSString *)stringFromDate:(NSDate *)date
               withFormatter:(NSString *)formatter;

/// 传入到1970之间的秒,按照指定格式转换成日期字符串
+ (NSString *)stringFromTimeIntervalSeconds:(NSTimeInterval)seconds
                              withFormatter:(NSString *)formatter;


/// 计算过去的某个时间点离现在时间的长短文字描述(如:刚刚、多少分钟前、多少小时前等)
+ (NSString *)timeIntervalStringSinceNowWithCompareTime:(NSTimeInterval)toCompareTime;

/// 计算现在时间距离某个时间点之间的天、时、分、秒数据
+ (void)getTimeIntervalSinceNowWithCompareTime:(NSTimeInterval)toCompareTime
                                     daysCount:(NSInteger *)days
                                 andHoursCount:(NSInteger *)hours
                                  minutesCount:(NSInteger *)minutes
                                  secondsCount:(NSInteger *)seconds;

/// 计算2个时间点之间的天、时、分、秒数据
+ (void)getTimeIntervalWithBeginCompareTime:(NSTimeInterval)beginTime
                             endCompareTime:(NSTimeInterval)endTime
                                  daysCount:(NSInteger *)days
                              andHoursCount:(NSInteger *)hours
                               minutesCount:(NSInteger *)minutes
                               secondsCount:(NSInteger *)seconds;

@end


