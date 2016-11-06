//
//  LoginVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "LoginVC.h"
#import "FlatUIKit.h"
#import "LoginBC.h"
#import "UserInfoModel.h"
#import "NITextField.h"
#import "AppPropertiesInitialize.h"
#import "RegViewController.h"

#define kAlpha 0.7

@interface LoginVC ()
{
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet NITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet NITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _loginBC = [[LoginBC alloc] init];
        self.isShowCloseBtn = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:[UIColor clearColor]];
    [AppPropertiesInitialize setKeyboardManagerEnable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:Common_ThemeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:LocalizedStr(login)];
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *whiteColor = HEXCOLORAL(0XFFFFFF, kAlpha);
    
    [_userNameLabel addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:whiteColor
                              lineWidth:LineWidth];
    [_passwordLabel addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:whiteColor
                              lineWidth:LineWidth];
    
    _userNameLabel.backgroundColor = [UIColor clearColor];
    _userNameLabel.textColor = whiteColor;
    _userNameLabel.placeholderTextColor = whiteColor;
    _userNameLabel.placeholder = LocalizedStr(mobile_phone_no);
    // _userNameLabel.text = [UserInfoModel getUserDefaultLoginName];
    
    _passwordLabel.backgroundColor = [UIColor clearColor];
    _passwordLabel.textColor = whiteColor;
    _passwordLabel.placeholderTextColor = whiteColor;
    _passwordLabel.placeholder = LocalizedStr(password);
    // _passwordLabel.text = [UserInfoModel getUserDefaultPassword];
    
    _loginBtn.backgroundColor = Common_GreenColor;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitle:LocalizedStr(login) forState:UIControlStateNormal];
    
    _registerBtn.backgroundColor = [UIColor clearColor];
    [_registerBtn setTitleColor:whiteColor forState:UIControlStateNormal];
    [_registerBtn setTitle:LocalizedStr(create_an_account) forState:UIControlStateNormal];
    [_registerBtn addLineWithPosition:ViewDrawLinePostionType_Top
                            lineColor:whiteColor
                            lineWidth:LineWidth];
    
//    _userNameLabel.text = @"18688897808";
//    _passwordLabel.text = @"123456";
    
    [_forgetPasswordBtn setTitle:LocalizedStr(forgot_password) forState:UIControlStateNormal];
    
    _closeBtn.hidden = !_isShowCloseBtn;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (IBAction)clickLoginBtn:(UIButton *)sender
{
    /*
     userName ：用户名
     userPassword  ：密码
     */
    WEAKSELF
    [_loginBC loginWithUserName:_userNameLabel.text
                       password:_passwordLabel.text
                      autoLogin:YES
                        showHUD:YES
                  successHandle:^(id successInfoObj) {
                    
                      [weakSelf backViewController];
                      
                  } failedHandle:^(NSError *error) {
                      
                  }];
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    RegViewController *reg = [[RegViewController alloc] init];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:reg] animated:YES completion:^{
        
    }];
}

- (IBAction)clickForgetPasswordBtn:(UIButton *)btn
{
    RegViewController *reg = [[RegViewController alloc] init];
    reg.isModifyPassword = YES;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:reg] animated:YES completion:^{
        
    }];
}

- (IBAction)clickCloseBtn:(UIButton *)btn
{
    if (_isFromSMSVC) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
        [self backViewController];
    
    
}

@end
