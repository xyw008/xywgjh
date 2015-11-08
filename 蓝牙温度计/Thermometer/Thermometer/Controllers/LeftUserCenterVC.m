//
//  LeftUserCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/5.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "LeftUserCenterVC.h"

static NSString *cellIdentifier_Title = @"cellIdentifier_Title";
static NSString *cellIdentifier_User = @"cellIdentifier_User";

@interface LeftUserCenterVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgIV.image = [UIImage imageNamed:@"leftmenu_bg"];
    [self.view addSubview:bgIV];
    
    
    [self initTableView];
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
    headIV.backgroundColor = [UIColor redColor];
    [headBgView addSubview:headIV];
    headIV.center = CGPointMake(headBgView.center.x - 22, headBgView.center.y);
    ViewRadius(headIV, headHeight/2);
    
    _tableView.tableHeaderView = headBgView;
    
}

#pragma mark - get cell
- (UITableViewCell*)getTitleCellForRowAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier_Title];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_Title];
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
    
    return cell;
}

- (UITableViewCell*)getUserCellForRowAtIndexPath:(NSIndexPath *)indexPath nickname:(NSString*)nickname image:(NSString*)imageStr
{
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier_Title];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_Title];
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
        return 1 + 1;
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
            return [self getTitleCellForRowAtIndexPath:indexPath title:@"成员管理"];
        }
        else
        {
            return [self getUserCellForRowAtIndexPath:indexPath nickname:@"熊爸爸" image:@"leftmenu_icon_father"];
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
    
}

@end
