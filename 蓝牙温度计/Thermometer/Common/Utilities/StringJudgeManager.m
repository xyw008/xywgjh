//
//  UrlJudgeManager.m
//  offlineTemplate
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "StringJudgeManager.h"

@implementation StringJudgeManager

#pragma mark (BOOL)利用谓词验证

+ (BOOL)isValidateStr:(NSString *)str regexStr:(NSString *)regexStr
{
    if (!str || 0 == str.length || !regexStr || 0 == regexStr) return NO;
    
    NSPredicate *strPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexStr];
    return [strPredicate evaluateWithObject:str];
}

@end
