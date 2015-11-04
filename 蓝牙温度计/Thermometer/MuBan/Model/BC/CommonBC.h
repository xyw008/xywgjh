//
//  BalanceBC.h
//  Sephome
//
//  Created by swift on 14/12/24.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonBC : NSObject

/// 解析数据
+ (NSMutableArray *)parseDataFromSourceDic:(NSDictionary *)dic;

@end

////////////////////////////////////////////////////////////////////////////////
/// 余额

@interface BalanceBC : CommonBC


@end
