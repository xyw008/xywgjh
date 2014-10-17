//
//  SearchDeatalViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-7-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.

// 此VC用来搜索律所，对应的LBS律所的那个表

#import "BaseViewController.h"
#import "BMapKit.h"

@interface SearchDeatalViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
//@property (nonatomic,strong) BMKMapView * mapView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSString * strTitle; //VC Titile
@property (nonatomic,strong) NSString * searchKey; // 搜索关键字
@property (nonatomic,strong) UIView *bgSearchView;
@property (nonatomic,assign) BOOL isShowMapView;//判断是先显示地图还是列表

@property (nonatomic,assign) CLLocationCoordinate2D searchLocation;//搜索制定地址的坐标
@property (nonatomic,assign) BOOL isAddNearbySearch;//判断是否是地址附件搜索（如：福田区法院附件搜索律所）,默认:NO

- (IBAction)sceneChange:(id)sender;

@end



