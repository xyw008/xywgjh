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
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStyleGrouped
                  registerNibName:nil
                  reuseIdentifier:nil];
}

- (void)loadLocalData
{
    _tabSectionTitleArray = @[@"报警选项", @"报警方式", @"报警温度设置"];
    _tabRowTitleArray = @[@[@"高低温报警", @"断线报警"],
                          @[@"报警铃声", @"报警震动", @"报警铃声设置"],
                          @[@"高温", @"低温(防踢被)"]];
}

- (UITableViewCell *)cellWithType:(NSInteger)type
{
    return nil;
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
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
