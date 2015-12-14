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
#define kNewUserName @"newUserName"//如果有包含这个key表示需要切换到这个新用户

//添加用户成功通知
static NSString * const kAddUserSuccessNotificationKey = @"kAddUserSuccessNotificationKey";


#define kUserItemKey @"userItemKey"
//修改用户成功
static NSString * const kChangeUserSuccessNotificationKey = @"kChangeUserSuccessNotificationKey";



@interface AddUserVC : BaseNetworkViewController

@property (nonatomic,strong)UserItem    *userItem;


@end
