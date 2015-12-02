//
//  AddUserVC.h
//  Thermometer
//
//  Created by leo on 15/11/22.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "CommonEntity.h"

#define kNewUserImageKey @"newUserImageKey"
//添加用户成功通知
static NSString * const kAddUserSuccessNotificationKey = @"kAddUserSuccessNotificationKey";


@interface AddUserVC : BaseNetworkViewController

@property (nonatomic,strong)UserItem    *userItem;


@end
