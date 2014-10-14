//
//  SearchLawyerViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-20.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "FLBaseViewController.h"

@interface SearchLawyerViewController : FLBaseViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) BMKMapView * mapView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString * strTitle;//VC titile
@property (nonatomic,strong) NSString * searchKey; //搜索关键字
@property (nonatomic,strong) UIView *bgSearchView;

- (IBAction)sceneChange:(id)sender;


@end
