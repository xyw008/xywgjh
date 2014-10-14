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

@interface CityListViewController ()<UITableViewDataSource,UITableViewDelegate>

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
    self.view.backgroundColor = [UIColor clearColor];
    self.arCityList = @[@{@"Item":@"当前定位城市",@"ItemValue": @[@"深圳"]}, @{@"Item":@"热门城市",@"ItemValue":@[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"重庆",@"成都",@"长沙",@"南京",@"天津",@"苏州",@"西安",@"青岛",@"沈阳",@"杭州",@"东莞"]}];
    // Do any additional setup after loading the view.
}


- (IBAction)returntolastview:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDatasource And UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return self.arCityList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary * dic = [self.arCityList objectAtIndex:section];
    NSArray * arCities = [dic valueForKey:@"ItemValue"];
    return arCities.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSDictionary * dic = [self.arCityList objectAtIndex:section];
    return [dic valueForKey:@"Item"];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
