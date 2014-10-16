//
//  CommonEntity.m
//  Find lawyer
//
//  Created by 龚 俊慧 on 14-10-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "CommonEntity.h"

@implementation HomePageNewsEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.newsId = [[dict objectForKey:@"Id"] integerValue];
        self.newsTitleStr = [dict objectForKey:@"Title"];
        self.newsDescStr = [dict objectForKey:@"Resume"];
    }
    return self;
}

@end
