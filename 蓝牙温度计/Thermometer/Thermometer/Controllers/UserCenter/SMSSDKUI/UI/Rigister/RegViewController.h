//
//  RegViewController.h
//  SMS_SDKDemo
//
//  Created by 掌淘科技 on 14-6-4.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"
//#import "SMSSDKUI.h"
#import <SMS_SDK/Extend/SMSSDKResultHanderDef.h>

#import "SMSUIVerificationCodeViewResultDef.h"

//#import "BaseViewController.h"

@protocol SecondViewControllerDelegate;

@interface RegViewController : UIViewController
<
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
SecondViewControllerDelegate,
UITextFieldDelegate
>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) UITextField* areaCodeField;
@property (nonatomic,strong) UITextField* telField;
@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@property (nonatomic, strong) SMSUIVerificationCodeResultHandler verificationCodeResult;

@property (nonatomic, assign) BOOL isModifyPassword;  // 是否为修改密码,不是则为设置新密码

-(void)nextStep;

@end
