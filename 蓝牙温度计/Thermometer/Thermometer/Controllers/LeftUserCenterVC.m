//
//  LeftUserCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/5.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "LeftUserCenterVC.h"
#import "CommonEntity.h"
#import "LoginBC.h"
#import "AccountStautsManager.h"
#import "InterfaceHUDManager.h"

#import "BaseNetworkViewController+NetRequestManager.h"
#import "AddUserVC.h"
#import "AppDelegate.h"
#import "PRPAlertView.h"

static NSString *cellIdentifier_Title = @"cellIdentifier_Title";
static NSString *cellIdentifier_User = @"cellIdentifier_User";

@interface LeftUserCenterVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_userItemArray;
    UIImageView         *_headIV;
    
    UserItem            *_willDeleteUserItem;

    NSString            *_needChnageUserName;//需要切换到新用户的名字（如果有）
}
@end

@implementation LeftUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgIV.image = [UIImage imageNamed:@"leftmenu_bg"];
    [self.view addSubview:bgIV];
    
    [self initTableView];
    
    if ([AccountStautsManager sharedInstance].isLogin) {
        [self getNetworkData];
    }
    
    
    //登陆成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kLoginSuccessNotificationKey
                                               object:nil];
    
    //登陆成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addUserSuccess:)
                                                 name:kAddUserSuccessNotificationKey
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    

    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, DpDynamicWidthValue640(48 + 72 + 58) + 20)];
    headBgView.backgroundColor = [UIColor clearColor];
    
    CGFloat headHeight = 72;
    _headIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
    _headIV.image = [UIImage imageNamed:@"icon_userhead"];
    [headBgView addSubview:_headIV];
    _headIV.center = CGPointMake((IPHONE_WIDTH - IIDeckViewLeftSize)/2, headBgView.center.y);
    ViewRadius(_headIV, headHeight/2);
    [_headIV addTarget:self action:@selector(goUserVC)];
    _tableView.tableHeaderView = headBgView;
    
}

#pragma mark - touch
- (void)goUserVC
{
    if ([_delegate respondsToSelector:@selector(LeftUserCenterVC:didTouchUserItem:)]) {
        [_delegate LeftUserCenterVC:self didTouchUserItem:[AccountStautsManager sharedInstance].nowUserItem];
    }
}

#pragma mark - request

- (void)setNetworkRequestStatusBlocks
{
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        if (successInfoObj && [successInfoObj isKindOfClass:[NSDictionary class]])
        {
            STRONGSELF
            switch (request.tag)
            {
                case NetUserRequestType_GetAllUserInfo:
                case NetUserRequestType_GetAllUserInfoNoImage:
                {
                    NSDictionary *userDic = [successInfoObj safeObjectForKey:@"user"];
                    
                    NSArray *memberList = [userDic safeObjectForKey:@"memberList"];
                    if ([memberList isAbsoluteValid])
                    {
                        NSMutableArray  *tempArray = [NSMutableArray new];
                        for (NSDictionary *obj in memberList)
                        {
                            UserItem *item = [UserItem initWithDict:obj];
                            [tempArray addObject:item];
                            
                            //如果需要切换新用户
                            if ([strongSelf->_needChnageUserName isAbsoluteValid]) {
                                if ([item.userName isEqualToString:strongSelf->_needChnageUserName]) {
                                    [AccountStautsManager sharedInstance].nowUserItem = item;
                                    strongSelf->_needChnageUserName = nil;
                                }
                            }
                        }
                        strongSelf->_userItemArray = tempArray;
                        [strongSelf->_tableView reloadData];
                        
                        //如果是添加的第一个成员
                        if (![AccountStautsManager sharedInstance].nowUserItem)
                        {
                            [AccountStautsManager sharedInstance].nowUserItem = [tempArray firstObject];
                        }
                        
                        if ([AccountStautsManager sharedInstance].nowUserItem.image)
                        {
                            strongSelf->_headIV.image = [AccountStautsManager sharedInstance].nowUserItem.image;
                        }
                        
                    }
                    else
                    {
                        //还没有成员
                        if ([strongSelf->_delegate respondsToSelector:@selector(LeftUserCenterVCNoMember:)]) {
                            [strongSelf->_delegate LeftUserCenterVCNoMember:strongSelf];
                        }
                    }
                }
                    break;
                case NetUserRequestType_DeleteUser:
                {
                    if ([strongSelf->_userItemArray containsObject:strongSelf->_willDeleteUserItem]) {
                        [strongSelf->_userItemArray removeObject:strongSelf->_willDeleteUserItem];
                        [strongSelf->_tableView reloadData];
                    }
                }
                    break;
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        switch (request.tag)
        {
            case NetUserRequestType_DeleteUser:
            {
                [weakSelf showHUDInfoByString:error.localizedDescription];
            }
                break;
            case NetUserRequestType_GetAllUserInfo:
            case NetUserRequestType_GetAllUserInfoNoImage:
            {
                if (error.code == 2) {
                    [UserInfoModel setUserDefaultLoginName:@""];
                    [UserInfoModel setUserDefaultPassword:@""];
                    [AccountStautsManager sharedInstance].isLogin = NO;
                }
            }
                break;
            default:
                break;
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetUserRequestType_GetAllUserInfoNoImage]
         parameterDic:@{@"phone":[UserInfoModel getUserDefaultLoginName]}
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetUserRequestType_GetAllUserInfoNoImage];
}

- (void)deleteUserRequest
{
    if (!_willDeleteUserItem) {
        return;
    }
    NSDictionary* memberDic = @{@"name":_willDeleteUserItem.userName,
                                @"gender":@(_willDeleteUserItem.gender),
                                @"age":@(_willDeleteUserItem.age),
                                @"role":@(_willDeleteUserItem.role),
                                @"image":_willDeleteUserItem.imageStr};
    
    NSArray *memberList = @[memberDic];
    
    [self sendRequest:[[self class] getRequestURLStr:NetUserRequestType_DeleteUser]
         parameterDic:@{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":memberList}
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetUserRequestType_DeleteUser];
}

#pragma mark - get cell
- (UITableViewCell*)getTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier_Title];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_Title];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.backgroundColor = [UIColor clearColor];
        titleLB.tag = 1000;
        titleLB.textColor = [UIColor whiteColor];
        titleLB.font = SP16Font;
        [cell.contentView addSubview:titleLB];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 2000;
        lineView.backgroundColor = HEXCOLOR(0X443A4F);
        [cell.contentView addSubview:lineView];
        
        [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(DpToPx(24));
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.equalTo(20);
        }];
        
        [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-LineWidth);
            make.height.equalTo(LineWidth);
            make.right.equalTo(cell.contentView.mas_right);
        }];
    }
    UILabel *titleLB = [cell.contentView viewWithTag:1000];
    titleLB.text = title;
    
    UIView *lineView = [cell.contentView viewWithTag:2000];
    CGFloat leftSpace = DpToPx(24);
    if (1 == indexPath.section)
        leftSpace = DpToPx(24);
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(leftSpace);
    }];
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:HEXCOLORAL(0XDADADA, 0.2)]];
    
    return cell;
}


- (UITableViewCell*)getUserCellForRowAtIndexPath:(NSIndexPath *)indexPath nickname:(NSString*)nickname image:(NSString*)imageStr
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier_User];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_User];
        // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *headIV = [[UIImageView alloc] init];
        headIV.backgroundColor = [UIColor clearColor];
        headIV.tag = 3000;
        [cell.contentView addSubview:headIV];
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.backgroundColor = [UIColor clearColor];
        titleLB.tag = 1000;
        titleLB.textColor = [UIColor whiteColor];
        titleLB.font = SP16Font;
        [cell.contentView addSubview:titleLB];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 2000;
        lineView.backgroundColor = HEXCOLOR(0X443A4F);
        [cell.contentView addSubview:lineView];
        
        [headIV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(32);
            make.width.equalTo(32);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.left.equalTo(DpToPx(20));
        }];
        
        [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headIV.mas_right).offset(DpToPx(6)/2);
            make.centerY.equalTo(cell.contentView.mas_centerY);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.equalTo(20);
        }];
        
        [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-LineWidth);
            make.height.equalTo(LineWidth);
            make.right.equalTo(cell.contentView.mas_right);
        }];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteUser:)];
        longGesture.minimumPressDuration = .7;
        [cell.contentView addGestureRecognizer:longGesture];
    }
    UIImageView *headIV = [cell.contentView viewWithTag:3000];
    headIV.image = [UIImage imageNamed:imageStr];
    
    UILabel *titleLB = [cell.contentView viewWithTag:1000];
    titleLB.text = nickname;
    
    UIView *lineView = [cell.contentView viewWithTag:2000];
    CGFloat leftSpace = DpToPx(46);
    if (1 == indexPath.section)
        leftSpace = DpToPx(46);
    
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(leftSpace);
    }];
    
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:HEXCOLORAL(0XDADADA, 0.2)]];
    
    return cell;
}


#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
        return _userItemArray.count + 2;
    if (1 == section)
        return 2;
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            UITableViewCell *cell = [self getTitleCellForRowAtIndexPath:indexPath title:@"成员管理"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else if (_userItemArray.count + 1 == indexPath.row)
        {
            return [self getUserCellForRowAtIndexPath:indexPath nickname:@"新增成员" image:@"leftmenu_icon_adduser"];
        }
        else
        {
            UserItem *item = [_userItemArray objectAtIndex:indexPath.row - 1];
            NSString *imageSting = @"leftmenu_icon_baby";
            if (2 == item.role)
                imageSting = @"leftmenu_icon_mother";
            else if (3 == item.role)
                imageSting = @"leftmenu_icon_father";
            else if (4 == item.role)
                imageSting = @"leftmenu_icon_grandm";
            else if (5 == item.role)
                imageSting = @"leftmenu_icon_grandf";
            
            return [self getUserCellForRowAtIndexPath:indexPath nickname:item.userName image:imageSting];
        }
    }
    else if (1 == indexPath.section)
    {
        return [self getTitleCellForRowAtIndexPath:indexPath title:0 == indexPath.row ? @"设置" : @"关于"];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section)
    {
        if (_userItemArray.count + 1 == indexPath.row)
        {
            [self touchDelegateCall:LeftMenuTouchType_AddUser];
        }
        else
        {
            if (0 != indexPath.row)
            {
                UserItem *item = (UserItem*)[_userItemArray objectAtIndex:indexPath.row - 1];
                if (item.memberId == [AccountStautsManager sharedInstance].nowUserItem.memberId) {
                    return;
                }
                
                WEAKSELF
                [PRPAlertView showWithTitle:nil message:@"是否切换成员" cancelTitle:Cancel cancelBlock:nil otherTitle:Confirm otherBlock:^{
                    STRONGSELF
                    
                    [AccountStautsManager sharedInstance].nowUserItem = item;
                    if (item.image)
                    {
                        strongSelf->_headIV.image = item.image;
                    }
                    else
                        strongSelf->_headIV.image = [UIImage imageNamed:@"icon_userhead"];
                    
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC toggleLeftView];
                }];
                
                /*
                [[InterfaceHUDManager sharedInstance] showAlertWithTitle:nil message: alertShowType:AlertShowType_Informative cancelTitle:@"取消" cancelBlock:^(GJHAlertView *alertView, NSInteger index) {
                    
                } otherTitle:@"确定" otherBlock:^(GJHAlertView *alertView, NSInteger index) {
                    
                }];
                 */
            }
        }
    }
    else if (1 == indexPath.section)
    {
        LeftMenuTouchType type = 0 == indexPath.row ? LeftMenuTouchType_Setting : LeftMenuTouchType_About;
        [self touchDelegateCall:type];
    }
}

- (void)deleteUser:(UILongPressGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell*)[gesture.view superview];
        if ([cell isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
            if (indexPath.section == 0)
            {
                
                if (0 != indexPath.row || _userItemArray.count + 1 != indexPath.row)
                {
                    UserItem *item = (UserItem*)[_userItemArray objectAtIndex:indexPath.row - 1];
                    if ([item.userName isEqualToString:[AccountStautsManager sharedInstance].nowUserItem.userName])
                    {
                        WEAKSELF
                        [PRPAlertView showWithTitle:nil message:@"不能删除当前选择账号" cancelTitle:Confirm cancelBlock:nil otherTitle:nil otherBlock:nil];
                    }
                    else
                    {
                        WEAKSELF
                        [PRPAlertView showWithTitle:nil message:@"是否删除次用户" cancelTitle:Cancel cancelBlock:nil otherTitle:Confirm otherBlock:^{
                            STRONGSELF
                            
                            strongSelf->_willDeleteUserItem = item;
                            [strongSelf deleteUserRequest];
                        }];
                    }
                    
                    
                }
            }
        }
    }
}

- (void)touchDelegateCall:(LeftMenuTouchType)type
{
    // [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC toggleLeftView];
    
    if ([_delegate respondsToSelector:@selector(LeftUserCenterVC:touchType:)]) {
        [_delegate LeftUserCenterVC:self touchType:type];
    }
}


#pragma mark - notification
- (void)loginSuccess:(NSNotification*)notification
{
    _needChnageUserName = nil;
    [self getNetworkData];
}

- (void)addUserSuccess:(NSNotification*)notification
{
    if (notification.userInfo && [notification.userInfo.allKeys containsObject:kNewUserName]) {
        _needChnageUserName = [notification.userInfo safeObjectForKey:kNewUserName];
    }
    [self getNetworkData];
}

@end
