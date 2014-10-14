//
//  NSString+TimeFormat.h
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormat)

+ (NSString *)formatDate:(NSDate *)date;
+ (NSString *)formatTime:(NSDate *)date;
+ (NSString *)formatDuration:(NSTimeInterval)duration;

@end
