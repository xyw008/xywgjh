//
//  UserCenter_TabHeaderView.m
//  BaoChe
//
//  Created by 龚 俊慧 on 14/12/20.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "UserCenter_TabHeaderView.h"

@interface UserCenter_TabHeaderView ()

// 登录后相关
@property (weak, nonatomic) IBOutlet UIView *userInfoBGView;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobilePhoneNumLabel;
/*
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
 */

// 未登录相关
@property (weak, nonatomic) IBOutlet UIView *notLoginBGView;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginAndRegisterBtn;

@end

@implementation UserCenter_TabHeaderView

static CGFloat defaultViewHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    UIColor *blackColor = Common_BlackColor;
    UIColor *grayColor = Common_GrayColor;
    
    // 分割线
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    [_userInfoBGView addLineWithPosition:ViewDrawLinePostionType_Bottom
                           lineColor:CellSeparatorColor
                           lineWidth:LineWidth];
    
    _userInfoBGView.backgroundColor = HEXCOLOR(0XF5FAFD);
    _userNameLabel.textColor = blackColor;
    _mobilePhoneNumLabel.textColor = Common_ThemeColor;
    // _addressLabel.textColor = HEXCOLOR(0X4F5256);
    
    _notLoginBGView.backgroundColor = HEXCOLOR(0XF5FAFD);
    _notLoginBGView.alpha = 1;
    [_loginAndRegisterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginAndRegisterBtn.backgroundColor = Common_ThemeColor;
    [_loginAndRegisterBtn setRadius:4];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    self.viewType = UserCenterHeaderViewType_Logined;
}

- (void)setViewType:(UserCenterHeaderViewType)viewType
{
    if (UserCenterHeaderViewType_Logined == viewType)
    {
        _userInfoBGView.hidden = NO;
        _notLoginBGView.hidden = YES;
    }
    else
    {
        _userInfoBGView.hidden = YES;
        _notLoginBGView.hidden = NO;
    }
}

- (IBAction)clickUserHeaderImageBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, UserCenterTabHeaderViewOperationType_UserHeaderImageBtn, sender);
}

- (IBAction)clickLoginAndRegisterBtn:(UIButton *)sender
{
    if (_operationHandle) _operationHandle(self, UserCenterTabHeaderViewOperationType_LoginAndRegister, sender);
}


- (void)loadDataUserName:(NSString *)userName phoneNum:(NSString *)phoneNumString
{
    _userNameLabel.text = userName;
    _mobilePhoneNumLabel.text = phoneNumString;
}

///////////////////////////////////////////////////////////////////

+ (CGFloat)getViewHeight
{
    if (0 == defaultViewHeight)
    {
        UserCenter_TabHeaderView *view = [self loadFromNib];
        defaultViewHeight= view.boundsHeight;
    }
    return defaultViewHeight;
}
@end
