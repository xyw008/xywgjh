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
    
    [self setTabShowData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)setTabShowData
{
    NSArray *section_OneTitleArray = [NSArray arrayWithObjects:@"扫码二维码,下载律寻APP", @"喜欢律寻?打分鼓励下吧", nil];
    NSArray *section_OneImageArray = [NSArray arrayWithObjects:@"saoyisao", @"xihuan", nil];
    
    _tabShowDataCellTitleArray = [NSArray arrayWithObjects:section_OneTitleArray, nil];
    _tabShowDataCellImageArray = [NSArray arrayWithObjects:section_OneImageArray, nil];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
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
