//
//  MyMagic.m
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "MyMagic.h"
#import "UserCenter_TabHeaderView.h"
#import "MyMagicCell.h"
#import "LoginVC.h"
#import "MyConsultListVC.h"
#import "InformationListVC.h"
#import "UserInfoModel.h"

static NSString * const cellIdentifier_userInfoHeader   = @"cellIdentifier_userInfoHeader";
static NSString * const cellIdentifier_MyMagicCell      = @"cellIdentifier_MyMagicCell";

@interface MyMagic ()
{
    NSArray                     *_tabShowDataCellTitleArray;
    NSArray                     *_tabShowDataCellImageArray;
    
    UserCenter_TabHeaderView    *_headerView;
}

@end

@implementation MyMagic

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    
    if (_headerView)
    {
        [self setHeadViewType];
        [_tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:nil
                            highlightedImg:nil
                                    action:NULL];
    
    [self setTabShowData];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods

- (void)setTabShowData
{
    NSArray *section_OneTitleArray = [NSArray arrayWithObjects:@"资讯推送", nil];
    NSArray *section_OneImageArray = [NSArray arrayWithObjects:@"zixuntuisong", nil];
    
    NSArray *section_TwoTitleArray = [NSArray arrayWithObjects:@"我的咨询", nil];
    NSArray *section_TwoImageArray = [NSArray arrayWithObjects:@"wodezixun", nil];
    
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:section_OneTitleArray, section_TwoTitleArray, nil];
    _tabShowDataCellImageArray = [NSArray arrayWithObjects:section_OneImageArray, section_TwoImageArray, nil];
}

- (NSString *)getOneCellTitleWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray = _tabShowDataCellTitleArray[indexPath.section];
    NSString *titleStr = titleArray[indexPath.row];
    
    return titleStr;
}

- (NSString *)getOneCellImageNameWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *imageNameArray = _tabShowDataCellImageArray[indexPath.section];
    NSString *imageNameStr = imageNameArray[indexPath.row];
    
    return imageNameStr;
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"我的法宝"];
}

- (void)setNetworkRequestStatusBlocks
{
    /*
     WEAKSELF
     [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
     STRONGSELF
     if (NetBusRequestType_GetAllBusList == request.tag)
     {
     
     }
     }];
     */
}

- (void)getNetworkData
{
    /*
     [self sendRequest:[[self class] getRequestURLStr:NetBusRequestType_GetAllBusList]
     parameterDic:nil
     requestTag:NetBusRequestType_GetAllBusList];
     */
}

- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([MyMagicCell class])
                  reuseIdentifier:cellIdentifier_MyMagicCell];
    
    // tab header view
    _headerView = [UserCenter_TabHeaderView loadFromNib];
    //_headerView.viewType = UserCenterHeaderViewType_NotLogin;
    [self setHeadViewType];
    _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    WEAKSELF
    [_headerView setOperationHandle:^(UserCenter_TabHeaderView *view, UserCenterTabHeaderViewOperationType type, id sender) {
        
        if (type == UserCenterTabHeaderViewOperationType_UserHeaderImageBtn)
        {
            
        }
        else if (type == UserCenterTabHeaderViewOperationType_LoginAndRegister)
        {
            LoginVC *login = [LoginVC loadFromNib];
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
            [weakSelf presentViewController:loginNav modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:nil];
        }
    }];
    _tableView.tableHeaderView = _headerView;
}

- (void)setHeadViewType
{
    NSString *password = [UserInfoModel getUserDefaultPassword];
    if ([password isAbsoluteValid])
    {
        _headerView.viewType = UserCenterHeaderViewType_Logined;
        [_headerView loadDataUserName:[UserInfoModel getUserDefaultUserName] phoneNum:[UserInfoModel getUserDefaultEmail]];
    }
    else
    {
        _headerView.viewType = UserCenterHeaderViewType_NotLogin;
    }
}

- (void)curIndexTabCellShowData:(NSInteger)index
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSString *password = [UserInfoModel getUserDefaultPassword];
    if ([password isAbsoluteValid]) {
        return _tabShowDataCellTitleArray.count + 1;
    }
    return _tabShowDataCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tabShowDataCellTitleArray.count != section)
    {
        NSArray *titleArray = _tabShowDataCellTitleArray[section];
        
        return titleArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyMagicCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellSeparatorSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tabShowDataCellTitleArray.count != indexPath.section)
    {
        MyMagicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_MyMagicCell];
        
        NSString *imageNameStr = [self getOneCellImageNameWithIndexPath:indexPath];
        NSString *titleStr = [self getOneCellTitleWithIndexPath:indexPath];
        
        cell.theImageView.image = [UIImage imageNamed:imageNameStr];
        cell.titleLabel.text = titleStr;
        
        if (indexPath.section == 0)
        {
            [cell setBadgeOneValue:@"288"];
            [cell setBadgeTwoValue:@"36"];
        }
        else
        {
            [cell setBadgeOneValue:@"1"];
            [cell setBadgeTwoValue:@"4"];
        }
        
        return cell;
    }
    else
    {
        static NSString *cellIdentifier_logout = @"cellIdentifier_logout";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_logout];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_logout];
            
            CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
            [cell addLineWithPosition:ViewDrawLinePostionType_Top
                            lineColor:CellSeparatorColor
                            lineWidth:LineWidth];
            [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                            lineColor:CellSeparatorColor
                            lineWidth:LineWidth];
            
            InsertLabel(cell,
                        CGRectMake(0, 0, cellSize.width, cellSize.height),
                        NSTextAlignmentCenter,
                        @"退出登录",
                        SP15Font,
                        Common_ThemeColor,
                        NO);
        }
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_tabShowDataCellTitleArray.count != indexPath.section)
    {
        if (indexPath.section == 0)
        {
            InformationListVC *vc = [[InformationListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushViewController:vc];
        }
        else
        {
            MyConsultListVC *vc = [[MyConsultListVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushViewController:vc];
        }
    }
    else
    {
        [UserInfoModel setUserDefaultPassword:@""];
        [self setHeadViewType];
        [tableView reloadData];
    }
}

@end
