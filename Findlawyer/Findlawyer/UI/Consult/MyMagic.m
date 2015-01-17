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

static NSString * const cellIdentifier_userInfoHeader   = @"cellIdentifier_userInfoHeader";
static NSString * const cellIdentifier_MyMagicCell      = @"cellIdentifier_MyMagicCell";

@interface MyMagic ()
{
    
}

@end

@implementation MyMagic

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:nil
                            highlightedImg:nil
                                    action:NULL];
    
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods

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
    UserCenter_TabHeaderView *headerView = [UserCenter_TabHeaderView loadFromNib];
    headerView.viewType = UserCenterHeaderViewType_Logined;
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    WEAKSELF
    [headerView setOperationHandle:^(UserCenter_TabHeaderView *view, UserCenterTabHeaderViewOperationType type, id sender) {
        
        if (type == UserCenterTabHeaderViewOperationType_CheckAllOrder)
        {
            
        }
        else if (type == UserCenterTabHeaderViewOperationType_UserHeaderImageBtn)
        {
            
        }
        else if (type == UserCenterTabHeaderViewOperationType_LoginAndRegister)
        {
            
        }
    }];
    _tableView.tableHeaderView = headerView;
}

- (void)curIndexTabCellShowData:(NSInteger)index
{
    
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    if (0 == indexPath.section)
    {
        MyMagicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_MyMagicCell];
        
        return cell;
    }
    else if (1 == indexPath.section)
    {
        MyMagicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_MyMagicCell];
        
        return cell;
    }
    else if (2 == indexPath.section)
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
}

@end
