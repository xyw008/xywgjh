//
//  AlarmSettingVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/11.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AlarmSettingVC.h"

@interface AlarmSettingVC ()
{
    NSArray    *_tabSectionTitleArray;
    NSArray    *_tabRowTitleArray;
}

@end

@implementation AlarmSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadLocalData];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    [self setupTableViewWithFrame:CGRectInset(self.view.frame, 15, 0)
                            style:UITableViewStyleGrouped
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.showsVerticalScrollIndicator = NO;
}

- (void)loadLocalData
{
    _tabSectionTitleArray = @[@"报警选项", @"报警方式", @"报警温度设置"];
    _tabRowTitleArray = @[@[@"高低温报警", @"断线报警"],
                          @[@"报警铃声", @"报警震动", @"报警铃声设置"],
                          @[@"高温", @"低温(防踢被)"]];
}

- (UIView *)cellAccessoryViewWithIndexPath:(NSIndexPath *)indexPath
{
    UIView *accessoryView = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            UISwitch *aSwitch = [[UISwitch alloc] init];
            [aSwitch addTarget:self
                        action:@selector(switchActionHandle:)
              forControlEvents:UIControlEventValueChanged];
            aSwitch.tag = [self viewTagWithIndexPath:indexPath];
            
            accessoryView = aSwitch;
        }
            break;
        case 1:
        {
            if (0 == indexPath.row || 1 == indexPath.row)
            {
                UISwitch *aSwitch = [[UISwitch alloc] init];
                [aSwitch addTarget:self
                            action:@selector(switchActionHandle:)
                  forControlEvents:UIControlEventValueChanged];
                aSwitch.tag = [self viewTagWithIndexPath:indexPath];
                
                accessoryView = aSwitch;
            }
            else if (2 == indexPath.row)
            {
                accessoryView = InsertLabel(nil,
                                            CGRectZero,
                                            NSTextAlignmentLeft,
                                            @"测试铃声",
                                            kSystemFont16,
                                            Common_BlackColor,
                                            YES);
            }
        }
            break;
        case 2:
        {
            accessoryView = InsertImageButtonWithTitle(nil,
                                                       CGRectZero,
                                                       [self viewTagWithIndexPath:indexPath],
                                                       nil,
                                                       nil,
                                                       @"88.8°C",
                                                       UIEdgeInsetsMake(0, 0, 0, 5),
                                                       kSystemFont16,
                                                       Common_BlackColor,
                                                       self,
                                                       @selector(clickSelectTemperatureBtn:));
            // accessoryView.backgroundColor = [UIColor redColor];
            [accessoryView sizeToFit];
            accessoryView.frameWidth += 15;
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown"]];
            arrowImageView.frameSize = CGSizeMake(10, 10);
            arrowImageView.frameOrigin = CGPointMake(accessoryView.frameWidth - arrowImageView.frameWidth, accessoryView.center.y + kGetScaleValueBaseIP6(16) / 2 - arrowImageView.frameHeight - 3);
            [accessoryView addSubview:arrowImageView];
        }
            break;
            
        default:
            break;
    }
    
    return accessoryView;
}

- (void)switchActionHandle:(UISwitch *)sender
{
    NSIndexPath *indexPath = [self indexPathWithTag:sender.tag];
    
    switch (indexPath.section) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (void)clickSelectTemperatureBtn:(UIButton *)sender
{
    NSIndexPath *indexPath = [self indexPathWithTag:sender.tag];
    
    switch (indexPath.row) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (NSInteger)viewTagWithIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section * 10 + indexPath.row;
}

- (NSIndexPath *)indexPathWithTag:(NSInteger)tag
{
    return [NSIndexPath indexPathForRow:tag % 10 inSection:tag / 10];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tabSectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *aRowTitleArray = _tabRowTitleArray[section];
    
    return aRowTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kGetScaleValueBaseIP6(35);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kGetScaleValueBaseIP6(46);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = [tableView rectForSection:section].size;
    UILabel *headerLabel = InsertLabel(nil,
                                       CGRectMake(0, 0, headerSize.width, headerSize.height),
                                       NSTextAlignmentLeft,
                                       _tabSectionTitleArray[section],
                                       kSystemFont12,
                                       Common_BlackColor,
                                       NO);
    return headerLabel;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.textLabel.font = kSystemFont16;
        cell.textLabel.textColor = Common_BlackColor;
        [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                        lineColor:PageBackgroundColor
                        lineWidth:ThinLineWidth];
    }
    
    NSArray *rowTitleArray = _tabRowTitleArray[indexPath.section];
    
    cell.accessoryView = [self cellAccessoryViewWithIndexPath:indexPath];
    cell.textLabel.text = rowTitleArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
