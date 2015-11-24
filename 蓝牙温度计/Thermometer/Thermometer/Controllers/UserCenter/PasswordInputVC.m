//
//  PasswordInputVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/20.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "PasswordInputVC.h"
#import "NITextField.h"
#import "PRPAlertView.h"
#import "LoginBC.h"

@interface PasswordInputVC ()
{
    LoginBC     *_loginBC;
}
@property (nonatomic, weak) IBOutlet NITextField *passwordTF;
@property (nonatomic, weak) IBOutlet UIButton *commitBtn;

@end

@implementation PasswordInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:_isModifyPassword ? @"修改密码" : @"设置密码"];
}

- (void)backViewController
{
    [PRPAlertView showWithTitle:nil
                        message:@"您确定要退出密码设置吗?"
                    cancelTitle:Cancel
                    cancelBlock:nil
                     otherTitle:Confirm
                     otherBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)configureViewsProperties
{
    _passwordTF.backgroundColor = HEXCOLOR(0XEAEAEA);
    [_passwordTF addBorderToViewWitBorderColor:CellSeparatorColor
                                   borderWidth:LineWidth];
    [_passwordTF setRadius:_passwordTF.frameHeight / 2];
    [_passwordTF setTextColor:Common_BlackColor];
    [_passwordTF setPlaceholder:_isModifyPassword ? @"请输入新密码" : @"设置密码"];
    _passwordTF.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _passwordTF.textAlignment = NSTextAlignmentCenter;
    _passwordTF.secureTextEntry = YES;
    
    _commitBtn.backgroundColor = Common_GreenColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickCommitBtn:(UIButton *)sender
{
    _loginBC = [[LoginBC alloc] init];
    
    /*
     userName ：用户名
     userPassword  ：密码
     */
//    WEAKSELF
//    [_loginBC loginWithUserName:_userNameLabel.text
//                       password:_passwordLabel.text
//                      autoLogin:YES
//                        showHUD:YES
//                  successHandle:^(id successInfoObj) {
//                      
//                      [UserInfoModel setUserDefaultLoginName:_userNameLabel.text];
//                      [UserInfoModel setUserDefaultPassword:_passwordLabel.text];
//                      
//                      [weakSelf backViewController];
//                      
//                  } failedHandle:^(NSError *error) {
//                      
//                  }];
    
}

@end
