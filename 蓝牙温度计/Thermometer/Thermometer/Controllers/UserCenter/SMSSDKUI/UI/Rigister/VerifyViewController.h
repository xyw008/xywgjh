//
//  VerifyViewController.h
//  SMS_SDKDemo
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegViewController.h"
#import <SMS_SDK/Extend/SMSSDKResultHanderDef.h>

#import "NITextField.h"

@interface VerifyViewController : UIViewController <UIAlertViewDelegate>

@property(nonatomic,strong)  NITextField* verifyCodeField;
@property(nonatomic,strong)  UILabel* timeLabel;
@property(nonatomic,strong)  UIButton* repeatSMSBtn;

@property (nonatomic, strong) UILabel *voiceCallMsgLabel;
@property (nonatomic, strong) UIButton *voiceCallButton;
@property (nonatomic) SMSGetCodeMethod getCodeMethod;

@property (nonatomic, strong) SMSUIVerificationCodeResultHandler verificationCodeResult;

@property (nonatomic, assign) BOOL isModifyPassword;  // 是否为修改密码,不是则为设置新密码

-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode;
-(void)submit;
-(void)CannotGetSMS;

@end
