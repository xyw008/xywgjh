//
//  LoginVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "LoginVC.h"
#import "FlatUIKit.h"
#import "RegisterVC.h"
#import "LoginBC.h"
#import "UserInfoModel.h"

@interface LoginVC ()
{
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet FUITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet FUITextField *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;

@end

@implementation LoginVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"back_login"]
                            highlightedImg:nil
                                    action:@selector(backViewController)];
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right
                            barButtonTitle:@"忘记密码"
                                    action:@selector(clickForgetPasswordBtn:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"登录"];
    [self setup];
}

- (void)configureViewsProperties
{
    [_userNameLabel addLineWithPosition:ViewDrawLinePostionType_Top
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_userNameLabel addLineWithPosition:ViewDrawLinePostionType_Bottom
                       startPointOffset:10
                         endPointOffset:0
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_passwordLabel addLineWithPosition:ViewDrawLinePostionType_Bottom
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    
    _userNameLabel.leftViewMode = UITextFieldViewModeAlways;
    _userNameLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    _userNameLabel.backgroundColor = [UIColor whiteColor];
    _userNameLabel.text = [UserInfoModel getUserDefaultLoginName];
    
    _passwordLabel.leftViewMode = UITextFieldViewModeAlways;
    _passwordLabel.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    _passwordLabel.backgroundColor = [UIColor whiteColor];
    _passwordLabel.text = [UserInfoModel getUserDefaultPassword];
    
    _loginBtn.backgroundColor = Common_ThemeColor;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setRadius:5];
    
    _registerBtn.backgroundColor = [UIColor whiteColor];
    [_registerBtn setTitleColor:Common_GrayColor forState:UIControlStateNormal];
    [_registerBtn setRadius:5];
    
    _browseBtn.backgroundColor = [UIColor whiteColor];
    [_browseBtn setTitleColor:Common_GrayColor forState:UIControlStateNormal];
    [_browseBtn setRadius:5];
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
                  successHandle:^(id successInfoObj) {
                      
                      [UserInfoModel setUserDefaultLoginName:_userNameLabel.text];
                      [UserInfoModel setUserDefaultPassword:_passwordLabel.text];
                      
                      [weakSelf backViewController];
                      
                  } failedHandle:^(NSError *error) {
                      
                  }];
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    RegisterVC *registerVC = [RegisterVC loadFromNib];
    [self pushViewController:registerVC];
}

- (IBAction)clickBrowseBtn:(UIButton *)sender
{
    
}

- (void)clickForgetPasswordBtn:(UIButton *)btn
{
    
}

@end
