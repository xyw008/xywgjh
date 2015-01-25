//
//  SettingViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
{
    NSArray                     *_tabShowDataCellTitleArray;
    NSArray                     *_tabShowDataCellImageArray;
}

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:@"更多"];
}

- (void)setTabShowData
{
    NSArray *section_OneTitleArray = [NSArray arrayWithObjects:@"扫码二维码,下载律寻APP", nil];
    NSArray *section_OneImageArray = [NSArray arrayWithObjects:@"saoyisao", nil];
    
    NSArray *section_TwoTitleArray = [NSArray arrayWithObjects:@"喜欢律寻?打分鼓励下吧", nil];
    NSArray *section_TwoImageArray = [NSArray arrayWithObjects:@"xihuan", nil];
    
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:section_OneTitleArray, section_TwoTitleArray, nil];
    _tabShowDataCellImageArray = [NSArray arrayWithObjects:section_OneImageArray, section_TwoImageArray, nil];
}

- (void)initialization
{
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
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

#pragma mark - UITableViewDelegate&UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _tabShowDataCellTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *titleArray = _tabShowDataCellTitleArray[section];
    
    return titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellSeparatorSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addLineWithPosition:ViewDrawLinePostionType_Top
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
        [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                        lineColor:CellSeparatorColor
                        lineWidth:LineWidth];
        
        cell.textLabel.font = SP15Font;
        cell.textLabel.textColor = Common_BlackColor;
    }
    
    NSString *imageNameStr = [self getOneCellImageNameWithIndexPath:indexPath];
    NSString *titleStr = [self getOneCellTitleWithIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:imageNameStr];
    cell.textLabel.text = titleStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
