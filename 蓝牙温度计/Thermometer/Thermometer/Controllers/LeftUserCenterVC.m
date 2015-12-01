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

#import "BaseNetworkViewController+NetRequestManager.h"
#import "AddUserVC.h"

static NSString *cellIdentifier_Title = @"cellIdentifier_Title";
static NSString *cellIdentifier_User = @"cellIdentifier_User";

@interface LeftUserCenterVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray      *_userItemArray;
}
@end

@implementation LeftUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgIV.image = [UIImage imageNamed:@"leftmenu_bg"];
    [self.view addSubview:bgIV];
    
    [self initTableView];
    
    
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
    UIImageView *headIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headHeight, headHeight)];
    headIV.image = [UIImage imageNamed:@"icon_userhead"];
    headIV.backgroundColor = [UIColor redColor];
    [headBgView addSubview:headIV];
    headIV.center = CGPointMake(headBgView.center.x - 22, headBgView.center.y);
    ViewRadius(headIV, headHeight/2);
    
    _tableView.tableHeaderView = headBgView;
    
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
                        }
                        strongSelf->_userItemArray = tempArray;
                        [strongSelf->_tableView reloadData];
                        
                        //如果是添加的第一个成员
                        if (![AccountStautsManager sharedInstance].nowUserItem)
                        {
                            [AccountStautsManager sharedInstance].nowUserItem = [tempArray firstObject];
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
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        
        switch (request.tag)
        {
                
        }
    }];
}

- (void)getNetworkData
{
    [self sendRequest:[[self class] getRequestURLStr:NetUserRequestType_GetAllUserInfo]
         parameterDic:@{@"phone":[UserInfoModel getUserDefaultLoginName]}
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetUserRequestType_GetAllUserInfo];
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
    CGFloat leftSpace = DpToPx(12);
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
            make.left.equalTo(DpToPx(24));
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
    }
    UIImageView *headIV = [cell.contentView viewWithTag:3000];
    headIV.image = [UIImage imageNamed:imageStr];
    
    UILabel *titleLB = [cell.contentView viewWithTag:1000];
    titleLB.text = nickname;
    
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
                [AccountStautsManager sharedInstance].nowUserItem = (UserItem*)[_userItemArray objectAtIndex:indexPath.row - 1];
            }
        }
    }
    else if (1 == indexPath.section)
    {
        LeftMenuTouchType type = 0 == indexPath.row ? LeftMenuTouchType_Setting : LeftMenuTouchType_About;
        [self touchDelegateCall:type];
    }
}

- (void)touchDelegateCall:(LeftMenuTouchType)type
{
    if ([_delegate respondsToSelector:@selector(LeftUserCenterVC:touchType:)]) {
        [_delegate LeftUserCenterVC:self touchType:type];
    }
}


#pragma mark - notification
- (void)loginSuccess:(NSNotification*)notification
{
    [self getNetworkData];
}

- (void)addUserSuccess:(NSNotification*)notification
{
    [self getNetworkData];
}

@end
