//
//  NetAction.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-11.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetAction : NSObject

@property (strong, nonatomic) id key;
@property (strong, nonatomic) id action;

+ (NetAction *)netWithAction:(id)action forKey:(id)key;

- (id)initWithAction:(id)action forKey:(id)key;


@end
