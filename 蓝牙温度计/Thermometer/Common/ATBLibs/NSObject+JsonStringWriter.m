//
//  UrlJudgeManager.m
//  offlineTemplate
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "NSObject+JsonStringWriter.h"

@implementation NSObject (JsonStringWriter)

- (NSString *)jsonStringByError:(NSError *__autoreleasing *)error
{
    NSData  *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:error];
    
    if (error)
        return nil;
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
