//
//  AccountAndUserStautsManager.h
//  Thermometer
//
//  Created by leo on 15/11/29.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonEntity.h"

//更换当前用户成功
static NSString * const kChangeNowUserNotificationKey = @"kChangeNowUserNotificationKey";


@interface AccountStautsManager : NSObject


@property (nonatomic,assign)BOOL    isLogin;//登陆状态

@property (nonatomic,strong)UserItem    *nowUserItem;//现在选择的成员，如果为空则有可能没登陆，或则登陆后账号没有成员

@property (nonatomic,assign)BOOL    uploadTempData;//是否同步数据

AS_SINGLETON(AccountStautsManager);


@end
