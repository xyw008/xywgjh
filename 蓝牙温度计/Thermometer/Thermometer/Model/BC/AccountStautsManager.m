//
//  AccountAndUserStautsManager.m
//  Thermometer
//
//  Created by leo on 15/11/29.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AccountStautsManager.h"

@implementation AccountStautsManager

DEF_SINGLETON(AccountStautsManager);


- (void)setNowUserItem:(UserItem *)nowUserItem
{
    _nowUserItem = nowUserItem;
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeNowUserNotificationKey object:nil];
}

@end
