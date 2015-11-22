//
//  LeftUserCenterVC.h
//  Thermometer
//
//  Created by leo on 15/11/5.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "BaseNetworkViewController.h"

typedef enum
{
    LeftMenuTouchType_AddUser,//添加用户
    LeftMenuTouchType_Setting,//设置
    LeftMenuTouchType_About,//关于
}LeftMenuTouchType;

@class LeftUserCenterVC;
@class UserItem;

@protocol LeftUserCenterVCDelegate <NSObject>

@optional
- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc didTouchUserItem:(UserItem*)item;

- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc touchType:(LeftMenuTouchType)type;


@end


@interface LeftUserCenterVC : BaseNetworkViewController
{
    __weak id<LeftUserCenterVCDelegate>     _delegate;
}
@property (nonatomic,weak)id                delegate;

@end
