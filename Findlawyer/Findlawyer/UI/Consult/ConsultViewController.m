//
//  ConsultViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ConsultViewController.h"
#import "SearchDeatalViewController.h"
#import "SearchLawyerViewController.h"
#import "AppDelegate.h"

@interface ConsultViewController ()

@end

@implementation ConsultViewController

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
    self.tableView.tableFooterView = [[UIView alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

// 根据类型进入相应搜索类型界面

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        /*
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        SearchLawyerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawyer"];
         */
        SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
        vc.strTitle = @"附近律师";
        vc.searchKey = @"";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.section == 1)
    {
        /*
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        SearchLawyerViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SearchDetailLawyer"];
        vc.strTitle =@"擅长领域";
        [self.navigationController pushViewController:vc animated:YES];
        */
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate chooseMaintabIndex:1 andType:NSNotFound];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
