//
//  168BC.m
//  o2o
//
//  Created by swift on 14-10-15.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "168BC.h"

@implementation _168BC

+ (void)parseDataFromSourceDic:(NSDictionary *)dic prePromotionDataContainer:(NSMutableArray *__strong *)preContainer andCurContainer:(NSMutableArray *__strong *)curContainer nextContainer:(NSMutableArray *__strong *)nextContainer
{
    if (!*preContainer)
    {
        *preContainer = [NSMutableArray array];
    }
    if (!*curContainer)
    {
        *curContainer = [NSMutableArray array];
    }
    if (!*nextContainer)
    {
        *nextContainer = [NSMutableArray array];
    }
    
    NSDictionary *promotionDic = [dic objectForKey:@"promotionTopicMap"];
    
    // 上一期
    NSDictionary *preDic = [promotionDic objectForKey:@"pre"];
    if ([preDic isSafeObject] && [preDic isAbsoluteValid])
    {
        NSArray *prePromotionList = [preDic objectForKey:@"promotionList"];
        if ([prePromotionList isAbsoluteValid])
        {
            for (NSDictionary *dic in prePromotionList)
            {
                _168Entity *preEntity = [_168Entity initWithDict:dic];
                
                [*preContainer addObject:preEntity];
            }
        }
    }
    
    // 本期
    NSDictionary *curDic = [promotionDic objectForKey:@"cur"];
    if ([curDic isSafeObject] && [curDic isAbsoluteValid])
    {
        NSArray *curPromotionList = [curDic objectForKey:@"promotionList"];
        if ([curPromotionList isAbsoluteValid])
        {
            for (NSDictionary *dic in curPromotionList)
            {
                _168Entity *curEntity = [_168Entity initWithDict:dic];
                
                [*curContainer addObject:curEntity];
            }
        }
    }
    
    // 下一期
    NSDictionary *nextDic = [promotionDic objectForKey:@"next"];
    if ([nextDic isSafeObject] && [nextDic isAbsoluteValid])
    {
        NSArray *nextPromotionList = [nextDic objectForKey:@"promotionList"];
        if ([nextPromotionList isAbsoluteValid])
        {
            for (NSDictionary *dic in nextPromotionList)
            {
                _168Entity *nextEntity = [_168Entity initWithDict:dic];
                
                [*nextContainer addObject:nextEntity];
            }
        }
    }
    
    [self sortArrayDataWithPrePromotionArray:*preContainer andCurPromotionArray:*curContainer nextPromotionArray:*nextContainer];
}

// 数据排序,把主打的产品(每一期只有一个主推产品)放到数组的第一位
+ (void)sortArrayDataWithPrePromotionArray:(NSMutableArray *)preArray andCurPromotionArray:(NSMutableArray *)curArray nextPromotionArray:(NSMutableArray *)nextArray
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.tag == %d",3];
    
    if ([preArray isAbsoluteValid])
    {
        NSArray *preFilterArray = [preArray filteredArrayUsingPredicate:predicate];
        if ([preFilterArray isAbsoluteValid])
        {
            _168Entity *theMainProductEntity = preFilterArray[0];
            [preArray moveObjectAtIndex:[preArray indexOfObject:theMainProductEntity] toIndex:0];
        }
    }
    
    if ([curArray isAbsoluteValid])
    {
        NSArray *curFilterArray = [curArray filteredArrayUsingPredicate:predicate];
        if ([curFilterArray isAbsoluteValid])
        {
            _168Entity *theMainProductEntity = curFilterArray[0];
            [curArray moveObjectAtIndex:[curArray indexOfObject:theMainProductEntity] toIndex:0];
        }
    }
    
    if ([nextArray isAbsoluteValid])
    {
        NSArray *nextFilterArray = [nextArray filteredArrayUsingPredicate:predicate];
        if ([nextFilterArray isAbsoluteValid])
        {
            _168Entity *theMainProductEntity = nextFilterArray[0];
            [nextArray moveObjectAtIndex:[nextArray indexOfObject:theMainProductEntity] toIndex:0];
        }
    }
}


@end
