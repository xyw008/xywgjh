//
//  ATBLibs+NSString.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(ATBLibsAddtions)

//按照制定格式NSDate转字符串
+ (NSString *)stringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;

+ (NSString *)timeIntervalStringSinceNowWithCompareTime:(NSTimeInterval)toCompareTime;

@end


