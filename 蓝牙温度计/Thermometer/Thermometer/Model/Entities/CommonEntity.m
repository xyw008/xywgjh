//
//  CommonEntity.m
//  o2o
//
//  Created by swift on 14-9-23.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CommonEntity.h"

@implementation FAQEntity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.questionStr = [dict objectForKey:@"question"];
        self.answerStr = [dict objectForKey:@"answer"];
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////

@implementation _168Entity

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        self.ID = [[dict objectForKey:@"id"] integerValue];
        self.productId = [[dict objectForKey:@"productId"] integerValue];
        self.tag = [[dict objectForKey:@"tag"] integerValue];
        self.productPictureUrlStr = [dict objectForKey:@"picture"];
        self.productNameStr = [dict objectForKey:@"productName"];
        self.productDescStr = [dict objectForKey:@"productDesc1"];
        self.marketPrice = [[dict objectForKey:@"price"] doubleValue];;
        self.promotionPrice = [[dict objectForKey:@"promotionPrice"] doubleValue];
        self.saleStatus = [[dict objectForKey:@"saleStatus"] integerValue];
        self.saleNum = [[dict objectForKey:@"saleNum"] integerValue];
    }
    return self;
}

@end
