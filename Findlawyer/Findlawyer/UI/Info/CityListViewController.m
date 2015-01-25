//
//  CityListViewController.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "CityListViewController.h"
#import "AppDelegate.h"
#import "QSignalManager.h"
#import "FileManager.h"

@interface CityListViewController ()

@property (nonatomic,strong)NSArray * arCityList;


@end

@implementation CityListViewController

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
    
    self.arCityList = @[@{@"Item":@"当前定位城市",@"ItemValue": @[@"深圳"]}, @{@"Item":@"热门城市",@"ItemValue":@[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"重庆",@"成都",@"长沙",@"南京",@"天津",@"苏州",@"西安",@"青岛",@"沈阳",@"杭州",@"东莞"]}];

    [self setupTableViewWithFrame:self.view.bounds
                            style:UITableViewStylePlain
                  registerNibName:nil
                  reuseIdentifier:nil];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


- (IBAction)returntolastview:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDatasource And UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arCityList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dic = [self.arCityList objectAtIndex:section];
    NSArray * arCities = [dic valueForKey:@"ItemValue"];
    return arCities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSDictionary * dic = [self.arCityList objectAtIndex:section];
    return [dic valueForKey:@"Item"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString *cellIdentifier = @"CityCell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell)
     {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         
         cell.textLabel.font = SP14Font;
         cell.textLabel.textColor = Common_BlackColor;
     }
     
     NSDictionary * dic = [self.arCityList objectAtIndex:indexPath.section];
     NSArray * arCities = [dic valueForKey:@"ItemValue"];
     cell.textLabel.text = [arCities objectAtIndex:indexPath.row];
    return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = [self.arCityList objectAtIndex:indexPath.section];
    NSArray * arCities = [dic valueForKey:@"ItemValue"];
    NSString * city= [arCities objectAtIndex:indexPath.row];
    
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appdelegate.currentCity = city;
    [FileManager saveCurrentCity:city];
    [self sendSignal:[QSignal signalWithName:ChangeCitySignal userInfo:@{@"city": city}]];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
   // [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    
}


@end
