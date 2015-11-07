//
//  BalanceBC.m
//  Sephome
//
//  Created by swift on 14/12/24.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "CommonBC.h"

@implementation CommonBC

+ (NSMutableArray *)parseDataFromSourceDic:(NSDictionary *)dic
{
    // 子类实现
    return nil;
}

@end

@implementation BalanceBC

+ (NSMutableArray *)parseDataFromSourceDic:(NSDictionary *)dic
{
    NSArray *entityList = [dic objectForKey:@"balanceRecords"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:entityList.count];
    
    for (NSDictionary *dataDic in entityList)
    {
        
    }
    return array;
}

@end
