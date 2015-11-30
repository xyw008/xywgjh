//
//  AlarmSettingVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/11.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AlarmSettingVC.h"
#import "AccountStautsManager.h"
#import "YSBLEManager.h"
#import "SelectAlarmTempView.h"
#import "PopupController.h"
#import "AlarmBellSelectVC.h"

@interface AlarmSettingVC ()
{
    NSArray    *_tabSectionTitleArray;
    NSArray    *_tabRowTitleArray;
    
    SelectAlarmTempView     *_selectTempView;
    PopupController         *_popView;
}

@end

@implementation AlarmSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItemTitle:@"报警设置"];
    [self loadLocalData];
    [self initialization];
    
    //选择铃声通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectNewBell:)
                                                 name:kSelectBellNotificationKey
                                               object:nil];
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
            
            aSwitch.on = indexPath.row == 0 ? [AccountStautsManager sharedInstance].highAndLowAlarm : [AccountStautsManager sharedInstance].disconnectAlarm;
            
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
                
                aSwitch.on = indexPath.row == 0 ? [AccountStautsManager sharedInstance].bellAlarm : [AccountStautsManager sharedInstance].shakeAlarm;
                
                accessoryView = aSwitch;
            }
            else if (2 == indexPath.row)
            {
                NSString *bell = [AccountStautsManager sharedInstance].bellMp3Name;
                accessoryView = InsertLabel(nil,
                                            CGRectZero,
                                            NSTextAlignmentLeft,
                                            bell,
                                            kSystemFont_Size(16),
                                            Common_BlackColor,
                                            YES);
            }
        }
            break;
        case 2:
        {
            CGFloat temp = indexPath.row == 0 ? [AccountStautsManager sharedInstance].highTemp : [AccountStautsManager sharedInstance].lowTemp;
            if ([YSBLEManager sharedInstance].isFUnit) {
                temp = [BLEManager getFTemperatureWithC:temp];
            }
            
            NSString *unitStr = [YSBLEManager sharedInstance].isFUnit ? @"°F" : @"°C";
            NSString *tempStr = [NSString stringWithFormat:@"%.1lf%@",temp,unitStr];
            
            accessoryView = InsertImageButtonWithTitle(nil,
                                                       CGRectZero,
                                                       [self viewTagWithIndexPath:indexPath],
                                                       nil,
                                                       nil,
                                                       tempStr,
                                                       UIEdgeInsetsMake(0, 0, 0, 5),
                                                       kSystemFont_Size(16),
                                                       Common_BlackColor,
                                                       self,
                                                       @selector(clickSelectTemperatureBtn:));
            // accessoryView.backgroundColor = [UIColor redColor];
            [accessoryView sizeToFit];
            accessoryView.frameWidth += 15;
            accessoryView.userInteractionEnabled = NO;
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dropdown"]];
            arrowImageView.frameSize = CGSizeMake(10, 10);
            arrowImageView.frameOrigin = CGPointMake(accessoryView.frameWidth - arrowImageView.frameWidth, accessoryView.center.y + 16 / 2 - arrowImageView.frameHeight - 3);
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
            if (0 == indexPath.row)
            {
                [AccountStautsManager sharedInstance].highAndLowAlarm = sender.on;
            }
            else if (1 == indexPath.row)
            {
                [AccountStautsManager sharedInstance].disconnectAlarm = sender.on;
            }
        }
            break;
        case 1:
        {
            if (0 == indexPath.row)
            {
                [AccountStautsManager sharedInstance].bellAlarm = sender.on;
            }
            else if (1 == indexPath.row)
            {
                [AccountStautsManager sharedInstance].shakeAlarm = sender.on;
            }
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
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize headerSize = [tableView rectForSection:section].size;
    UILabel *headerLabel = InsertLabel(nil,
                                       CGRectMake(0, 0, headerSize.width, headerSize.height),
                                       NSTextAlignmentLeft,
                                       _tabSectionTitleArray[section],
                                       kSystemFont_Size(12),
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
        cell.textLabel.font = kSystemFont_Size(16);
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
    
    if (indexPath.section == 1)
    {
        if (2 == indexPath.row) {
            AlarmBellSelectVC *vc = [AlarmBellSelectVC new];
            [self pushViewController:vc];
        }
    }
    else if (indexPath.section == 2)
    {
        if (0 == indexPath.row)
        {
            [self showAlarmTempValueSelectView:YES];
        }
        else if (1 == indexPath.row)
        {
            [self showAlarmTempValueSelectView:NO];
        }
    }
    
}

- (void)showAlarmTempValueSelectView:(BOOL)isHigh
{
    if (_selectTempView == nil)
    {
        _selectTempView = [[SelectAlarmTempView alloc] initWithFrame:CGRectMake(20, 150, IPHONE_WIDTH - 20*2, 220)];
        
        [_selectTempView nowSelectTemp:isHigh ? [AccountStautsManager sharedInstance].highTemp : [AccountStautsManager sharedInstance].lowTemp];
        
        WEAKSELF
        [_selectTempView setBtnCallBack:^(BOOL isSubmit,CGFloat tempValue){
            STRONGSELF
            if (isSubmit)
            {
                if (isHigh)
                    [AccountStautsManager sharedInstance].highTemp = tempValue;
                else
                    [AccountStautsManager sharedInstance].lowTemp = tempValue;
                
                [strongSelf->_tableView reloadData];
            }
            
            [strongSelf->_popView hide];
        }];
        
        _popView = [[PopupController alloc] initWithContentView:_selectTempView];
        _popView.delegate = self;
        _popView.behavior = PopupBehavior_MessageBox;
        UIView *superView = [UIApplication sharedApplication].keyWindow;
        
        [_popView showInView:superView animatedType:PopAnimatedType_MiddleFlyIn];
        
    }
}

- (void)PopupControllerDidHidden:(PopupController *)aController
{
    [_selectTempView removeFromSuperview];
    _selectTempView = nil;
    _popView = nil;
}

#pragma mark - notification
- (void)selectNewBell:(NSNotification*)notification
{
    [_tableView reloadData];
}

@end
