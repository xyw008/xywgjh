//
//  168BC.h
//  o2o
//
//  Created by swift on 14-10-15.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEntity.h"

@interface _168BC : NSObject

/// 解析数据
+ (void)parseDataFromSourceDic:(NSDictionary *)dic prePromotionDataContainer:(NSMutableArray *__strong *)preContainer andCurContainer:(NSMutableArray *__strong *)curContainer nextContainer:(NSMutableArray *__strong *)nextContainer;

@end
