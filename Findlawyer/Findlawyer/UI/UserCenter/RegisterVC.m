//
//  RegisterVC.m
//  JmrbNews
//
//  Created by 龚 俊慧 on 14/12/18.
//
//

#import "RegisterVC.h"
#import "FlatUIKit.h"
#import "RegisterBC.h"
#import "LoginBC.h"
#import "ATTimerManager.h"

#define kGetVerificationCodeFreezeSecond 30

@interface RegisterVC () <ATTimerManagerDelegate>
{
    RegisterBC  *_registerBC;
    LoginBC     *_loginBC;
}

@property (weak, nonatomic) IBOutlet FUITextField *userNameTF;
@property (weak, nonatomic) IBOutlet FUITextField *passwordTF;
@property (weak, nonatomic) IBOutlet FUITextField *passwordConfirmTF;
@property (weak, nonatomic) IBOutlet FUITextField *verificationCodeTF;

@property (weak, nonatomic) IBOutlet UIButton *getVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _registerBC = [[RegisterBC alloc] init];
        _loginBC = [[LoginBC alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [[ATTimerManager shardManager] stopTimerDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"注册新用户"];
    [self setup];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.view.subviews)
    {
        if ([subView isKindOfClass:[FUITextField class]])
        {
            FUITextField *textField = (FUITextField *)subView;
            
            textField.leftViewMode = UITextFieldViewModeAlways;
            textField.backgroundColor = [UIColor whiteColor];
        }
    }
    
    [_userNameTF addLineWithPosition:ViewDrawLinePostionType_Top
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_userNameTF addLineWithPosition:ViewDrawLinePostionType_Bottom
                       startPointOffset:10
                         endPointOffset:0
                              lineColor:CellSeparatorColor
                              lineWidth:LineWidth];
    [_passwordConfirmTF addLineWithPosition:ViewDrawLinePostionType_Top
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    [_passwordConfirmTF addLineWithPosition:ViewDrawLinePostionType_Bottom
                    startPointOffset:10
                      endPointOffset:0
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    
    _userNameTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user"]];
    _passwordTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    _passwordConfirmTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    _verificationCodeTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_mima"]];
    
    _getVerificationCodeBtn.backgroundColor = Common_ThemeColor;
    
    _registerBtn.backgroundColor = Common_ThemeColor;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setRadius:5];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)setGetVerificationCodeBtnTitleWithSecond:(NSInteger)second
{
    if (second > 0)
    {
        [_getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"获取验证码(%d)", second] forState:UIControlStateNormal];
    }
    else
    {
        [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (IBAction)clickGetVerificationCodeBtn:(UIButton *)sender
{
    WEAKSELF
    [_registerBC getVerificationCodeWithMobilePhoneNumber:_userNameTF.text successHandle:^(id successInfoObj) {
        
        [weakSelf setGetVerificationCodeBtnTitleWithSecond:kGetVerificationCodeFreezeSecond];
        weakSelf.getVerificationCodeBtn.backgroundColor = [UIColor grayColor];
        weakSelf.getVerificationCodeBtn.userInteractionEnabled = NO;
        [[ATTimerManager shardManager] addTimerDelegate:self interval:1];
        
    } failedHandle:^(NSError *error) {
        
    }];
}

- (IBAction)clickRegisterBtn:(UIButton *)sender
{
    /*
     Mobile   ：用户名
     Password    ：密码
     userPhone  ：  联系电话
     */
    WEAKSELF
    [_registerBC registerWithMobilePhoneUserName:_userNameTF.text
                                        password:_passwordTF.text
                                 passwordConfirm:_passwordConfirmTF.text
                                verificationCode:_verificationCodeTF.text
                                   successHandle:^(id successInfoObj) {
        
                                       [weakSelf loginWithUserName:_userNameTF.text password:_passwordTF.text];
                                       
    } failedHandle:^(NSError *error) {
        
    }];
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password
{
    /*
     userName ：用户名
     userPassword  ：密码
     */
    WEAKSELF
    [_loginBC loginWithUserName:userName
                       password:password
                      autoLogin:YES
                  successHandle:^(id successInfoObj) {
                      
                      [UserInfoModel setUserDefaultLoginName:userName];
                      [UserInfoModel setUserDefaultPassword:password];
                      
                      [weakSelf.navigationController dismissViewControllerAnimated:YES
                                                                        completion:nil];
        
    } failedHandle:^(NSError *error) {
        
    }];
}

#pragma mark - ATTimerManagerDelegate methods

- (void)timerManager:(ATTimerManager *)manager timerFireWithInfo:(ATTimerStepInfo)info
{
    if (info.totalTime < kGetVerificationCodeFreezeSecond)
    {
        [self setGetVerificationCodeBtnTitleWithSecond:kGetVerificationCodeFreezeSecond - info.totalTime];
    }
    else
    {
        [self setGetVerificationCodeBtnTitleWithSecond:0];
        _getVerificationCodeBtn.backgroundColor = Common_ThemeColor;
        _getVerificationCodeBtn.userInteractionEnabled = YES;
        
        [manager stopTimerDelegate:self];
    }
}

@end
