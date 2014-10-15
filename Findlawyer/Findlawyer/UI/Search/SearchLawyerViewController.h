//
//  SearchLawyerViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-20.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchLawyerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic)  UISearchBar *searchBar;
@property (nonatomic,strong) BMKMapView * mapView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString * strTitle;//VC titile
@property (nonatomic,strong) NSString * searchKey; //搜索关键字
@property (nonatomic,strong) UIView *bgSearchView;
@property (nonatomic,assign) BOOL isShowMapView;//判断是先显示地图还是列表

- (void)sceneChange:(id)sender;

@end
