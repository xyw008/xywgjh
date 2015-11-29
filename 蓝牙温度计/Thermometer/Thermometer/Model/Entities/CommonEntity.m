//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"


@implementation UserItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.memberId = [[dict objectForKey:@"id"] integerValue];
        self.userName = [dict objectForKey:@"name"];
        self.gender = [[dict safeObjectForKey:@"gender"] integerValue];
        self.age = [[dict safeObjectForKey:@"age"] integerValue];
        self.role = [[dict safeObjectForKey:@"role"] integerValue];
    }
    return self;
}


@end


