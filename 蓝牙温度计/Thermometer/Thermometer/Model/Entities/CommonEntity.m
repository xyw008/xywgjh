//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"
#import "SystemConvert.h"
#import "BabyToy.h"

@implementation UserItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.memberId = [[dict safeObjectForKey:@"id"] integerValue];
        self.userName = [dict safeObjectForKey:@"name"];
        self.gender = [[dict safeObjectForKey:@"gender"] integerValue];
        self.age = [[dict safeObjectForKey:@"age"] integerValue];
        self.role = [[dict safeObjectForKey:@"role"] integerValue];
        NSString *str = [dict safeObjectForKey:@"image"];
        if (str)
        {
            //NSString *dataStr = [NSString stringWithFormat:@"%@",str];
            //NSString *dataStr = [SystemConvert hexToBinary:str];
            //NSData* data= [BabyToy ConvertHexStringToData:str];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            self.image = [UIImage imageWithData:data];
        }
    }
    return self;
}


@end



@implementation RemoteTempItem

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.temp = [[dict objectForKey:@"temp"] floatValue];
        self.time = [dict objectForKey:@"date"];
        
    }
    return self;
}


@end