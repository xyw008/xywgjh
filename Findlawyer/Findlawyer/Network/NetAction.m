//
//  NetAction.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-11.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "NetAction.h"

@implementation NetAction

+ (NetAction *)netWithAction:(id)action forKey:(id)key
{
    return [[NetAction alloc] initWithAction:action forKey:key];
}


- (id)initWithAction:(id)action forKey:(id)key
{
    self = [super init];
    if (self) {
        self.key = key;
        self.action = action;
    }
    return self;
}

@end
