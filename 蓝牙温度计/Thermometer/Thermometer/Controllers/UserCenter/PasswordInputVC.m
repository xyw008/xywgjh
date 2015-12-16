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
#import "BaseNetworkViewController+NetRequestManager.h"

@interface PasswordInputVC ()
{
    LoginBC     *_loginBC;
}
@property (nonatomic, weak) IBOutlet NITextField *passwordTF;
@property (nonatomic, strong) NITextField *onceMorePasswordTF;

@property (nonatomic, weak) IBOutlet UIButton *commitBtn;

@end

@implementation PasswordInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [self setNavigationItemTitle:_isModifyPassword ? @"修改密码" : @"设置密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    
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
    
    
    if (_isModifyPassword) {
        _onceMorePasswordTF = [[NITextField alloc] init];
        _onceMorePasswordTF.backgroundColor = _passwordTF.backgroundColor;
        [_onceMorePasswordTF addBorderToViewWitBorderColor:CellSeparatorColor
                                       borderWidth:LineWidth];
        [_onceMorePasswordTF setRadius:40 / 2];
        [_onceMorePasswordTF setTextColor:_passwordTF.textColor];
        [_onceMorePasswordTF setPlaceholder:@"请再次输入新密码"];
        _onceMorePasswordTF.textInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _onceMorePasswordTF.textAlignment = NSTextAlignmentCenter;
        _onceMorePasswordTF.secureTextEntry = YES;
        _onceMorePasswordTF.font = _passwordTF.font;
        [self.view addSubview:_onceMorePasswordTF];
        
        [_onceMorePasswordTF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_passwordTF.mas_left);
            make.right.equalTo(_passwordTF.mas_right);
            make.height.equalTo(40);
            make.top.equalTo(_passwordTF.mas_bottom).offset(12);
            
        }];
        
        [_commitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_passwordTF.mas_left);
            make.right.equalTo(_passwordTF.mas_right);
            make.height.equalTo(40);
            make.top.equalTo(_onceMorePasswordTF.mas_bottom).offset(40);
        }];
        
        [_commitBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    else
    {
        [_commitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_passwordTF.mas_bottom).offset(40);
        }];
    }
    
    _commitBtn.backgroundColor = Common_GreenColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickCommitBtn:(UIButton *)sender
{
    [self getNetworkData];
}

#pragma mark - request

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        if (successInfoObj && [successInfoObj isKindOfClass:[NSDictionary class]])
        {
            switch (request.tag)
            {
                case NetUserCenterRequestType_Register:
                {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    
                    // [weakSelf loginRequest];
                }
                    break;
                case NetUserCenterRequestType_ModifyPossword:
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    break;
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        [weakSelf showHUDInfoByString:error.localizedDescription];
    }];
}

- (void)getNetworkData
{
    if (![_passwordTF.text isAbsoluteValid]) {
        [self showHUDInfoByString:@"请输入密码"];
        return;
    }
    
    if (_isModifyPassword)
    {
        if (![_onceMorePasswordTF.text isAbsoluteValid]) {
            [self showHUDInfoByString:@"请再次输入密码"];
            return;
        }
        
        if (![_passwordTF.text isEqualToString:_onceMorePasswordTF.text]) {
            [self showHUDInfoByString:@"两次输入密码不一致"];
            return;
        }
    }
    
    NSDictionary *dic = @{@"phone": _phoneNumStr,
                          @"password": _passwordTF.text};
    
    NetRequestType type = _isModifyPassword ? NetUserCenterRequestType_ModifyPossword : NetUserCenterRequestType_Register;
    
    [self sendRequest:[[self class] getRequestURLStr:type]
         parameterDic:dic
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:type];
    
}


- (void)loginRequest
{
    if (_loginBC == nil) {
        _loginBC = [[LoginBC alloc] init];
    }
        WEAKSELF
    [_loginBC loginWithUserName:_phoneNumStr
                       password:_passwordTF.text
                      autoLogin:YES
                        showHUD:YES
                  successHandle:^(id successInfoObj) {
                      
                      [weakSelf dismissViewControllerAnimated:YES completion:nil];
                      
                  } failedHandle:^(NSError *error) {
                      
                  }];

}

@end
