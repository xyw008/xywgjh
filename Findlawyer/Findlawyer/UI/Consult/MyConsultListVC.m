//
//  MyConsultListVC.m
//  Find lawyer
//
//  Created by leo on 15/3/4.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "MyConsultListVC.h"
#import "ConsultListCell.h"

static NSString * const consultCellIdentifier = @"consultCellIdentifier";


@interface MyConsultListVC ()

@end

@implementation MyConsultListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initialization
{
    // tab
    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:NSStringFromClass([ConsultListCell class])
                  reuseIdentifier:consultCellIdentifier];
    
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsultListCell *cell = [tableView dequeueReusableCellWithIdentifier:consultCellIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [UIView new];
    sectionView.backgroundColor = Common_LiteWhiteGrayColor;
    return sectionView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
