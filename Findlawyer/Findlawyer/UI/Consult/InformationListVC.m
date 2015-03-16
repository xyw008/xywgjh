//
//  InfomationListVC.m
//  Find lawyer
//
//  Created by leo on 15/3/11.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "InformationListVC.h"
#import "InformationListCell.h"

static NSString * const informationCellIdentifier = @"informationCellIdentifier";


@interface InformationListVC ()

@end

@implementation InformationListVC

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
                  registerNibName:NSStringFromClass([InformationListCell class])
                  reuseIdentifier:informationCellIdentifier];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:informationCellIdentifier];
    
    if (indexPath.row % 3 == 0)
    {
        [cell testLoadDescription:@"左边的观众，右边的观众，中间的观众，有没有观众。让我看到你们的双手好吗"];
    }
    else
    {
        [cell testLoadDescription:@"is't my life she in my sin"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
