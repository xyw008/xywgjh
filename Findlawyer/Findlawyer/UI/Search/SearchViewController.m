//
//  SearchViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchDeatalViewController.h"
#import "SearchLawyerViewController.h"
#import "SearchSortView.h"

@interface SearchViewController ()<UISearchBarDelegate>


@property (nonatomic,strong )NSArray *searchResults;
@property (nonatomic,strong)NSArray * staticSearchList;
@property (nonatomic,strong)NSString *chooseditem;
@property (nonatomic) SearchType searchtype;
@property (nonatomic,strong) NSString *searchkey;
@property (strong,nonatomic)UIButton * btnNearLawFirm;
@property (strong,nonatomic)UIButton * btnNearLawyer;


@end

@implementation SearchViewController
{
    BMKCloudSearch* _search;  
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.staticSearchList = @[@{@"Item":@"     周边律所",@"ItemValue": @[]},
                              @{@"Item":@"     附近律师",@"ItemValue": @[]},
                              @{@"Item":@"     法院周边",@"ItemValue": @[@"xcode中级法院",@"福田区法院",@"罗湖区法院",@"南山区法院",@"宝安区法院",@"更多"]},
                              @{@"Item":@"     擅长领域",@"ItemValue":@[@"刑事",@"刑事辩护",@"公司",@"经济合同",@"民商经济",@"房地产",@"更多"]}];

//    self.searchDisplayController.searchBar.delegate = self;
//    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor clearColor];
    
    SearchSortView *view = [[SearchSortView alloc] initWithFrame:CGRectMake(15, 0, self.view.width - 15*2, 300) title:@"法院周边" sortNameArray:@[@"深圳市中级人民法院",@"福田区法院",@"罗湖区法院",@"南山区法院",@"宝安区法院",@"更多"]];
    [self.view addSubview:view];
    self.view.backgroundColor = [UIColor blueColor];
    
};

// 快速搜索周边律所 和附近律师
- (void)ChooseSearchDetail:(UIButton *)btn
{
    if (btn.tag == 0)
    {
        self.searchtype = SearchHouse;
        self.searchkey =@"";
        self.chooseditem = @"周边律所";
        [self pushToSeachDetailView];
    }
    else if(btn.tag == 1)
    {
        self.chooseditem = @"附近律师";
        self.searchtype = searchLawyer;
        self.searchkey =@"";
        [self pushToSeachDetailView];
    }
}
// 搜索具体搜索项
- (void)pushToSeachDetailView
{
    if (self.searchtype == SearchHouse)
    {
        [self performSegueWithIdentifier:@"toSearchDetailLawfirm" sender:self];//搜索律所
    }
    else
    {
        [self performSegueWithIdentifier:@"toSearchDetailLawyer" sender:self]; // 搜索律师
    }
}

#pragma mark - UITableViewDatasource And UITableViewDelegate


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return 1;
//    }
//    return self.staticSearchList.count;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return self.searchResults.count;
//    }
//    // Return the number of rows in the section.
//    NSDictionary * dic = [self.staticSearchList objectAtIndex:section];
//    NSArray * values = [dic valueForKey:@"ItemValue"];
//    return values.count;
//}
//
////- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
////{
////    NSDictionary * dic = [self.staticSearchList objectAtIndex:section];
////    return [dic valueForKey:@"Item"];
////}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    UITableViewCell *cell = nil;
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
//        if (!cell)
//        {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
//            cell.textLabel.font = [UIFont systemFontOfSize:16];
//        
//        }
//        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
//        cell.backgroundColor =[UIColor clearColor];
//      //  cell.textLabel.text = [self.searchResults objectAtIndex:0];
//    }
//    else
//    { //显示具体搜索项
//        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//        NSDictionary * dic = [self.staticSearchList objectAtIndex:indexPath.section];
//        NSArray * arCities = [dic valueForKey:@"ItemValue"];
//        cell.textLabel.text = [NSString stringWithFormat:@"   %@",[arCities objectAtIndex:indexPath.row]];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//
////        NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
////        
////        if (selectedScopeButtonIndex == 0)
////        {
////           self.searchtype = SearchHouse;
////        }
////        else
////        {
////            self.searchtype = searchLawyer;
////        }
//    }
//    else
//    {
//        NSDictionary * dic = [self.staticSearchList objectAtIndex:indexPath.section];
//        NSArray * arValues = [dic valueForKey:@"ItemValue"];
//        NSString * value= [arValues objectAtIndex:indexPath.row];
//        
//        self.searchkey = value;
//        if (indexPath.section == 2)
//        {
//            self.chooseditem = @"法院周边";
//            self.searchtype = SearchHouse;
//            [self pushToSeachDetailView];
//        }
//        else if (indexPath.section == 3)
//        {
//            self.chooseditem = @"擅长领域";
//            self.searchtype = searchLawyer;
//            [self pushToSeachDetailView];
//        }
//    }
//  
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return 0;
//    }
//    return 35;
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return nil;
//    }
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
//    [btn setFrame:CGRectMake(0, 0, 320, 35)];
//    
//    [btn addTarget:self action:@selector(ChooseSearchDetail:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTag:section];
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    [btn setTitleColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f] forState:UIControlStateNormal];
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//     NSDictionary * dic = [self.staticSearchList objectAtIndex:section];
//    NSString * titil = dic[@"Item"];
//    [btn setTitle:titil forState:UIControlStateNormal];
// 
//    return btn;
//}



#pragma mark - Search display controller delegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
     NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (selectedScopeButtonIndex == 0)
    {
        //  scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    }
    else
    {
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师";
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.placeholder = @"搜索";
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
//    NSString *searchString = [self.searchDisplayController.searchBar text];
//    NSString *scope;
    
   // NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (searchOption == 0)
    {
      //  scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    }
    else
    {
        self.searchDisplayController.searchBar.placeholder = @"请输入你要找的律师";

    }
   // [self.searchResults removeAllObjects];
    
     return NO;
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller;
{

   // [self performSegueWithIdentifier:@"toSearchDetail" sender:self];

}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    if (selectedScopeButtonIndex == 0)
    {
        self.searchResults = @[@"广东国晖律师事务所"];
        self.searchtype = SearchHouse;
        self.searchkey = self.searchDisplayController.searchBar.text;
        
    }
    else
    {
     
        self.searchResults = @[@"小强律师"];
        self.searchtype = searchLawyer;
        self.searchkey = self.searchkey = self.searchDisplayController.searchBar.text;

    }
  
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view]; // Hidden extra cell line.
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self pushToSeachDetailView];
    
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toSearchDetailLawfirm"])
    {
        SearchDeatalViewController * VC  = segue.destinationViewController;
        VC.strTitle = self.chooseditem;
        VC.searchKey = self.searchkey;
    }
    else if([segue.identifier isEqualToString:@"toSearchDetailLawyer"])
    {
       SearchLawyerViewController* VC  = segue.destinationViewController;
        VC.strTitle = self.chooseditem;
        VC.searchKey = self.searchkey;
    }
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
