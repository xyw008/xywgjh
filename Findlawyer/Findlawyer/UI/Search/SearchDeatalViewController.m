//
//  SearchDeatalViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-17.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SearchDeatalViewController.h"
#import "AppDelegate.h"
#import "LawfirmCell.h"
#import "LawyerCell.h"
#import "LBSLawfirm.h"
#import "LBSLawyer.h"
#import "LBSDataBase.h"
#import "LBSRequestManager.h"
#import "LBSRequest+LBSSearchRegion.h"
#import "LBSRequest+LBSSearchNearby.h"
#import "LBSDataCenter.h"
#import "LBSSharedData.h"
#import "UIImageView+WebCache.h"
#import "QSignalManager.h"
#import "DetailLocationViewController.h"
#import "DetailLawfirmViewController.h"
#import "UIViewController+loading.h"
#import "BMKLawfirmPaoPaoView.h"
#import "HUDManager.h"
#import "CustomBMKAnnotationView.h"
#import "GCDThread.h"

#define HUDTage 999
#define kRadius kTotalRadius
#define kHeardHeight 18


@interface SearchDeatalViewController () <LawFirmCellDelegate>
{
  	NSUInteger          currentIndex;
	NSUInteger          pageSize;
	NSUInteger          totalItemCount;
    
    BMKMapView          *_mapView;
    BMKLocationService  *_locService;
    
    BMKUserLocation     *_userLocation;//自己当前的位置
    
    BOOL                _isLocationSuccess;
}

@property (assign, atomic) BOOL loading;
@property (assign, atomic) BOOL noMoreResultsAvail;
@property (assign, atomic) BOOL isLocationBasedSearch;
@property (assign, atomic) BOOL isHaveResult;

@property (nonatomic,strong) NSMutableArray *allLawyerEntityArray;
@property (nonatomic,strong ) NSMutableArray *searchResults;
@property (nonatomic,strong ) NSMutableArray * listContend;         // 当前展示的数据(有可能是全部也有可能是搜索出得结果)

@property (strong,nonatomic ) LBSLawfirm  *seletedlawfirm;

@end

@implementation SearchDeatalViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isShowMapView = YES;
        _searchLocation = CLLocationCoordinate2DMake(0, 0);
    }
    return self;
}

- (void)dealloc
{
    [self removeSignalObserver];
    
    [_locService stopUserLocationService];
    _locService.delegate = nil;
}

- (void)initialize
{
//    [super initialize];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentIndex = 0;
    pageSize = 30;
   
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, 44)];
    self.searchBar.placeholder = @"请输入您要找的律师事务所名";
    if ([_searchKey isAbsoluteValid])
    {
        self.searchBar.text = _searchKey;
    }
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"sousuo_2"] forState:UIControlStateNormal];
    [_searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    self.allLawyerEntityArray = [NSMutableArray array];
    self.searchResults =[[NSMutableArray alloc]init];
    self.listContend  = [[NSMutableArray alloc]init];
    
    CGRect subviewframe = CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.viewBoundsWidth, self.viewBoundsHeight - CGRectGetMaxY(_searchBar.frame));
    self.bgSearchView = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgSearchView.frame = subviewframe;
    _bgSearchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    _tableView = [[UITableView alloc]initWithFrame:subviewframe];
   //先注册自定义的LawfirmCell以便重用
   [_tableView registerNib:[UINib nibWithNibName:@"LawfirmCell" bundle:nil] forCellReuseIdentifier:@"LawfirmCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView keepAutoresizingInFull];
    [self.view addSubview:_tableView];

    // 开始时先加上地图，但先让地图隐藏，列表显示
    _mapView = [[BMKMapView alloc] initWithFrame:subviewframe];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [_mapView keepAutoresizingInFull];
    [self.view addSubview:_mapView];
    
    // 开启地图定位
    [self startUserLocationService];
    
    //判断是显示地图还是列表
    _mapView.hidden = !_isShowMapView;
    _tableView.hidden = _isShowMapView;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:_isShowMapView?@"列表":@"地图" action:@selector(sceneChange:)];
    
    self.searchBar.placeholder = @"请输入你要找的律师事务所名称";
   
    if ([_searchKey isAbsoluteValid])
    {
        [self loadmoreDataSearStatus:YES];
    }
    else
    {
        [self loadmoreDataSearStatus:NO];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    [self addSignalObserver];
//    [self showMapnode];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    
   [self removeSignalObserver];
   
    [HUDManager hideHUD];
    [self removeProgressHUD];
    [super viewWillDisappear:animated];
}

- (void)setPageLocalizableText
{
    [self setNavigationItemTitle:_strTitle];
}

// 开启地图定位
- (void)startUserLocationService
{
//    _locService = [[BMKLocationService alloc]init];
//    _locService.delegate = self;
//    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;                        // 先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;    // 设置定位的状态
    _mapView.showsUserLocation = YES;                       // 显示定位图层
}

// 设置地图中心位置，加载地图标注
- (void) showMapnode
{
    if ([_mapView.annotations isAbsoluteValid])
    {
        NSArray * array = [NSArray arrayWithArray:[_mapView annotations]];
        [_mapView removeAnnotations:array];
    }
    
    // 地图定位到用户当前的坐标位置,不用搜索到的数据设置地图中心
    /*
    if (self.listContend.count >0) {
        
        LBSLawfirm *lawyerfirm = [self.listContend objectAtIndex:0];
        CLLocationCoordinate2D coor = lawyerfirm.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(kMapShowSpan,kMapShowSpan));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    
        [self loadAnnotationWithArray:self.listContend];
    }
     */
    
    if (_searchLocation.latitude)
    {
        BMKCoordinateRegion mapRegion = BMKCoordinateRegionMake(_searchLocation, BMKCoordinateSpanMake(kMapShowSpan, kMapShowSpan));
        [_mapView setRegion:mapRegion animated:YES];
    }
    
    [self loadAnnotationWithArray:_listContend];
}

//根据地图数据 配置地图标注

- (void)loadAnnotationWithArray:(NSArray *)information
{
    /*
	if (![information isAbsoluteValid]) return;
     */
    
	NSArray *retainedInforation = information;
    
	[GCDThread enqueueForeground:^{
        
        NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[retainedInforation count]];
        
        for (LBSLawfirm *lawyerfirm in retainedInforation)
        {
            LBSLocationAnnotation *locationAnnotation = [[LBSLocationAnnotation alloc] initWithLawfirm:lawyerfirm];
            [annotations addObject:locationAnnotation];
        }
        
        /**
         @ 修改描述     添加 标注律所的图标
         @ 修改人       leo
         @ 修改时间     2015-03-31
         @ 修改开始
         */
        
        if (_searchLocation.latitude)
        {
            LBSLawfirm *lawfirm = [[LBSLawfirm alloc] init];
            lawfirm.coordinate = _searchLocation;
            
            LBSLocationAnnotation *locationAnnotation = [[LBSLocationAnnotation alloc] init];
            locationAnnotation.lawfirm = lawfirm;
            [annotations addObject:locationAnnotation];
        }
        // 修改结束
        
        
        if ([annotations isAbsoluteValid])
        {
            [_mapView addAnnotations:annotations];
        }
    }];
}
// 列表和地图模式切换
- (IBAction)sceneChange:(id)sender {
    
    _isShowMapView = !_isShowMapView;
//    if (!_isShowMapView) {
//       
//        _mapView.hidden = YES;
//        self.tableView.hidden = NO;
//        [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:@"地图" action:@selector(sceneChange:)];
//        
//    }
//    else
//    {
//        if (self.tableView) {
//            self.tableView.hidden = YES;
//            _mapView.hidden = NO;
//            [self showMapnode];
//        }
//        [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:@"列表" action:@selector(sceneChange:)];
//    }
    
    [UIView transitionWithView:self.view duration:.45 options:!_isShowMapView ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight animations:^{
        if (!_isShowMapView)
        {
            _mapView.hidden = YES;
            _tableView.hidden = NO;
        }
        else
        {
            if (_tableView)
            {
                _tableView.hidden = YES;
                _mapView.hidden = NO;
                
                [self showMapnode];
            }
        }
    } completion:^(BOOL finished) {
        
        if (!_isShowMapView)
        {
            [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:@"地图" action:@selector(sceneChange:)];
        }
        else
        {
            [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:@"列表" action:@selector(sceneChange:)];
        }
    }];
    
}

// 处理cell 中各种BUtton 发出的通知

- (void)receiveSignal:(QSignal *)signal
{
    if ([signal.name isEqualToString:SignalCellShowMap] && [self isViewLoaded])
    {
       NSDictionary * userinfo = signal.userInfo;
       NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
       self.seletedlawfirm = [self.listContend objectAtIndex:cellindexpath.row];
//       [self showMap];
        
        // 切换视图
        [self sceneChange:nil];
        
        // 设置地图annotation-paopao视图的弹出
        [self clearLawyersShowMapPaopaoViewStatus];
        self.seletedlawfirm.isShowMapLawfirmAnnotationPaopaoView = YES;
        
        [self showMapnode];
        
    }
    else if ([signal.name isEqualToString:SignalCellopenUrl] && [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawfirm = [self.listContend objectAtIndex:cellindexpath.row];
        [self openUrl];
    }
    else if ([signal.name isEqualToString:SignalCellCall] && [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawfirm = [self.listContend objectAtIndex:cellindexpath.row];
        [self callNumber];
    }
}

// 显示地图
- (void)showMap
{
    NSLog(@"CellShowMap");
    [self performSegueWithIdentifier:@"toDetailLawfirmLocation" sender:self];
}
// 打开网址
- (void)openUrl
{
    NSLog(@"CellOpenUrl");
}
// 打电话
- (void)callNumber
{
    NSLog(@"CellCallNumber");
}

//地图的一些代理方法，根据需要添加
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[LBSLocationAnnotation class]])
    {
        LBSLocationAnnotation *theAnnotation = (LBSLocationAnnotation *)annotation;
        // DLog("space is %f - %@",theAnnotation.lawyer.distance, theAnnotation.lawyer.lawfirmName);
        
        // 生成重用标示identifier
        NSString *AnnotationViewID = @"renameMark";
        
        // 检查是否有重用的缓存
        CustomBMKAnnotationView *newAnnotationView = (CustomBMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[CustomBMKAnnotationView alloc] initWithAnnotation:theAnnotation reuseIdentifier:AnnotationViewID];
        }
        
        /**
         @ 修改描述     加多 标注律所的图标
         @ 修改人       leo
         @ 修改时间     2015-03-31
         @ 修改开始
         */
        
        //开始修改
        if (_searchLocation.latitude && theAnnotation.coordinate.latitude == _searchLocation.latitude && theAnnotation.coordinate.longitude == _searchLocation.longitude)
        {
            newAnnotationView.image = [UIImage imageNamed:@"court"];
        }
        else
        {
            newAnnotationView.annotation = theAnnotation;
            
            // newAnnotationView.image = [self getMapAnnotationPointImageWithIndex:[self.listContend indexOfObject:theAnnotation.lawfirm] + 1];
            newAnnotationView.title = [NSString stringWithFormat:@"%d", [_listContend indexOfObject:theAnnotation.lawfirm] + 1];
            
            // paopao视图
            BMKLawfirmPaoPaoView *paopaoView = [BMKLawfirmPaoPaoView loadFromNib];
            
            // 加载paopao视图的数据
            [paopaoView loadViewData:theAnnotation.lawfirm];
            newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        }
        
        
        /*
        newAnnotationView.annotation = theAnnotation;
        
        // newAnnotationView.image = [self getMapAnnotationPointImageWithIndex:[self.listContend indexOfObject:theAnnotation.lawfirm] + 1];
        newAnnotationView.title = [NSString stringWithFormat:@"%d", [_listContend indexOfObject:theAnnotation.lawfirm] + 1];
        
        // paopao视图
        BMKLawfirmPaoPaoView *paopaoView = [BMKLawfirmPaoPaoView loadFromNib];
        
        // 加载paopao视图的数据
        [paopaoView loadViewData:theAnnotation.lawfirm];
        newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        */
        
        
        //修改结束
        
        
        
        /*
         // 设置颜色
         ((BMKPinAnnotationView*)newAnnotationView).pinColor = BMKPinAnnotationColorPurple;
         // 从天上掉下效果
         ((BMKPinAnnotationView*)newAnnotationView).animatesDrop = NO;
         */
        
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (BMKAnnotationView *annotationView in views)
    {
        LBSLocationAnnotation *locationAnnotation = annotationView.annotation;
        
        if ([locationAnnotation isKindOfClass:[LBSLocationAnnotation class]] && locationAnnotation.lawfirm.isShowMapLawfirmAnnotationPaopaoView)
        {
            [mapView selectAnnotation:locationAnnotation animated:YES];
            [mapView setCenterCoordinate:locationAnnotation.coordinate animated:YES];
            
            // 清除lawyer paopao视图的弹出状态
            [self clearLawyersShowMapPaopaoViewStatus];
        }
    }
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    LBSLocationAnnotation *annotation = view.annotation;
    
    // 过滤掉用户当前位置泡泡视图的点击
    if ([annotation isKindOfClass:[LBSLocationAnnotation class]])
    {
        DetailLawfirmViewController * vc = [[DetailLawfirmViewController alloc] init];
        vc.lawfirmid = [annotation.lawfirm.lfid integerValue];
        vc.lawfirm = annotation.lawfirm;
        [self pushViewController:vc];
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    [self setMapCenterWithLocation:userLocation];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"定位失败");
}

// 设置地图中心
- (void)setMapCenterWithLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];

    if (!_isLocationSuccess && !_searchLocation.latitude)
    {
        LBSLawfirm *lastLawyer = [self.listContend lastObject];
        
        BMKCoordinateRegion viewRegion;
        if (lastLawyer)
        {
            CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
            
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lastLawyer.coordinate.latitude,userCoordinate.longitude));
            BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userCoordinate.latitude,lastLawyer.coordinate.longitude));
            
            BMKMapPoint point3 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(userCoordinate.latitude,userCoordinate.longitude));
            
            CLLocationDistance latitudeMeters = BMKMetersBetweenMapPoints(point1,point3);
            CLLocationDistance longitudeMeters = BMKMetersBetweenMapPoints(point2,point3);
            
            viewRegion = BMKCoordinateRegionMakeWithDistance(userCoordinate, latitudeMeters, longitudeMeters);
        }
        else
        {
            viewRegion = BMKCoordinateRegionMake(userLocation.location.coordinate, BMKCoordinateSpanMake(kMapShowSpan,kMapShowSpan));
        }
        [_mapView setRegion:viewRegion animated:YES];
        
        _isLocationSuccess = !_isLocationSuccess;
    }
}

// 搜索加载数据
#pragma mark - DataModle

- (void)loadmoreDataSearStatus:(BOOL)isSearch
{
//    [HUDManager showHUDWithToShowStr:@"搜索中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak SearchDeatalViewController *weakSelf = self;
    
    // 添加请求
    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestUpdateLocation]] locationUpdateComplete:^(BMKUserLocation *location) {
        if (location)
        {
            [[LBSSharedData sharedData] setCurrentCoordinate2D:location.location.coordinate];
            _userLocation = location;
            //[weakSelf setMapCenterWithLocation:location];
            
            CLLocationCoordinate2D coordinate = location.location.coordinate;
        
            // 如果法院坐标有值就用法院的坐标去搜索
            if (_searchLocation.latitude)
            {
                coordinate = _searchLocation;
            }
            [weakSelf loadDataWithLocation:coordinate radius:kRadius searchKey:self.searchKey IsSearStatus:isSearch];
        }
        else
        {    // 没有坐标则显示定位失败
            [HUDManager showAutoHideHUDWithToShowStr:LBSUILocationError HUDMode:MBProgressHUDModeText];
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [[LBSSharedData sharedData] setCurrentCoordinate2D:CLLocationCoordinate2DMake(0, 0)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");
           
            });
        }
    }];
    return;
}


 // 用地理坐标进行百度LBS云搜索
- (void)loadDataWithLocation:(CLLocationCoordinate2D)location radius:(NSUInteger)radius searchKey:(NSString*)searchKey IsSearStatus:(BOOL)isSearch
{
    
    [_mapView setCenterCoordinate:location animated:YES];
    
    [HUDManager showHUDWithToShowStr:@"搜索中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
//    [HUDManager showHUDWithToShowStr:@"搜索中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
   
    WEAKSELF
    [[LBSDataCenter defaultCenter] loadDataWithNearby:location radius:radius searchtype:SearchHouse searchKye:searchKey index:currentIndex     pageSize:pageSize pieceComplete:^(LBSRequest *request, NSDictionary *dataModel) {
        if (dataModel)
		{
            // 将得到的数据初始化律所这个数据
            LBSLawfirm *lawfirm = [[LBSLawfirm alloc]initWithDataModel:dataModel];
            /*
            [weakSelf.listContend addObject:lawfirm];// 将取到的数据放在数组里
             */
            if (!isSearch)
            {
                [weakSelf.allLawyerEntityArray addObject:lawfirm];
            }
            else
            {
                [weakSelf.searchResults addObject:lawfirm];
            }
        }
		else
		{
            STRONGSELF
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            weakSelf.listContend = !isSearch ? weakSelf.allLawyerEntityArray : weakSelf.searchResults;
            
            // 排序
            [weakSelf.listContend sortUsingComparator:^NSComparisonResult(LBSLawyer *obj1, LBSLawyer *obj2) {
                return obj1.distance < obj2.distance ? NSOrderedAscending : NSOrderedDescending;
            }];
            
            [weakSelf setMapCenterWithLocation:_userLocation];
            
            dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.listContend count]);
				NSUInteger curCnt = [weakSelf.listContend count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
                
				if (request.error)
                    /*
                    [self hideHUDWithTitle:LBSUINetWorkError image:nil delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];
                
				else if (request.availableItemCount)
                    
//                    [self removeProgressHUD];
//                    [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:HUDAutoHideTypeShowTime];
                
                    [HUDManager hideHUD];
                
				else
                {
                    /*
                     [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINoMoreData HUDMode:MBProgressHUDModeText];
                }
                
                
				[strongSelf->_tableView reloadData];//从新加载列表
                [self showMapnode];// 从新加载地图地图
            
            });
        }
	
    }];
}

// 以城市为单位进行搜索
- (void)loadLocalData
{
//    [self showHUDWithTitle:@"搜索中...."];
    [HUDManager showHUDWithToShowStr:@"搜索中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
    
     WEAKSELF
    [[LBSDataCenter defaultCenter] loadDataWithRegionSearchkey:self.searchKey searchtype:SearchHouse index:currentIndex pageSize:pageSize pieceComplete:^(LBSRequest *request, id dataModel) {
        if (dataModel)
		{
            LBSLawfirm *lawfirm = [[LBSLawfirm alloc]initWithDataModel:dataModel];
            if (lawfirm.distance <= kRadius)
            {
                /*
                [weakSelf.listContend addObject:lawfirm];
                 */
                [weakSelf.searchResults addObject:lawfirm];
            }
            
//            [[LBSSharedData sharedData] setCurrentCoordinate2D:lawfirm.coordinate];
//            // 得到地理坐标后，进行百度LBS云搜索
//            [weakSelf loadDataWithLocation:lawfirm.coordinate radius:200000 searchKey:@""];
        }
		else
		{
            STRONGSELF
            weakSelf.listContend = weakSelf.searchResults;
            
            // 排序
            [weakSelf.listContend sortUsingComparator:^NSComparisonResult(LBSLawyer *obj1, LBSLawyer *obj2) {
                return obj1.distance < obj2.distance ? NSOrderedAscending : NSOrderedDescending;
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.listContend count]);
				NSUInteger curCnt = [weakSelf.listContend count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
                
				if (request.error)
                    /*
                    [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];
				else if (request.availableItemCount)
                    /*
                    [UIView hideHUDWithTitle:LBSUIDataComplete image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager hideHUD];
                
				else
                    /*
                    [UIView hideHUDWithTitle:LBSUINoMoreData image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINoMoreData HUDMode:MBProgressHUDModeText];
                
				[strongSelf->_tableView reloadData];
                [self showMapnode];// 从新加载地图地图

            });
        }
    }];
    currentIndex++;
	[[LBSSharedData sharedData] setCurrentIndex:currentIndex];


    
//    [[LBSDataCenter defaultCenter] loadDataWithRegionName:[[[LBSDataBase sharedInstance] placeNames] objectAtIndex:self.pickerRegionIndex] priceRange:priceRange rentalType:self.pickerRentalIndex index:_currentIndex pageSize:_pageSize pieceComplete:^(LBSRequest *request, id dataModel) {
//		if (dataModel)
//		{
//            LBSRental *rental = [[LBSRental alloc] initWithDataModel:dataModel];
//            if (rental)
//            {
//                [self.listContent addObject:rental];
//            }
//		}
//		else
//		{
//			dispatch_async(dispatch_get_main_queue(), ^{
//				NSLog(@"reload data now.");
//				_totalItemCount = request.availableItemCount;
//				NSLog(@"total:%d, loaded:%d", _totalItemCount, [self.listContent count]);
//				NSUInteger curCnt = [self.listContent count];
//				if (curCnt >= _totalItemCount)
//					_noMoreResultsAvail = YES;
//				_loading = NO;
//				if (request.error)
//					[iToast make:LBSUINetWorkError duration:750];
//				else if (request.availableItemCount)
//					[iToast make:LBSUIDataComplete duration:750];
//				else
//					[iToast make:LBSUINoMoreData duration:750];
//				[self.tableView reloadData];
//				[self performSelector:@selector(stopLoading) withObject:nil afterDelay:0.5];
//			});
//		}
//	}];
//	currentIndex++;
//	[[LBSSharedData sharedData] setCurrentIndex:currentIndex];

}

- (LBSLawfirm *)curDataWithIndex:(NSInteger)index
{
    return index < _listContend.count ? _listContend[index] : nil;
}

#pragma mark - UITableViewDatasource And UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listContend.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LawfirmCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LawfirmCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LawfirmCell"];
    cell.delegate = self;
    
    [cell loadCellShowDataWithItemEntity:[self curDataWithIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.seletedlawfirm = [self.listContend objectAtIndex:indexPath.row];
    
    /*
    [self performSegueWithIdentifier:@"SearchtoDetailLawfirm" sender:self];
     */
    DetailLawfirmViewController *detailLawfirmVC = [[DetailLawfirmViewController alloc] init];
    detailLawfirmVC.lawfirm = _seletedlawfirm;
    detailLawfirmVC.lawfirmid = _seletedlawfirm.lfid.integerValue;
    [self pushViewController:detailLawfirmVC];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kHeardHeight;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, kHeardHeight)];
//    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    view.backgroundColor = HEXCOLOR(0XF0F0F0);
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, kHeardHeight)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont boldSystemFontOfSize:12];
    lable.textColor = HEXCOLOR(0XB6B6B6);
    // lable.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255.0/255.0 alpha:1];
    [view addSubview:lable];
    lable.text = [NSString stringWithFormat:@" 附近共%d家律所",self.listContend.count];
    return view;
}                  

#pragma mark -UISearchBarDelagat

- (void)searchBarTextDidBeginEditing:(UISearchBar *)hsearchBar
{
    [self.view addSubview:self.bgSearchView];
    self.searchBar.showsCancelButton = YES;
    for(id cc in [self.searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    searchBar.text = nil;
    [self.bgSearchView removeFromSuperview];
    [self.searchBar resignFirstResponder];
    
    self.listContend = _allLawyerEntityArray;
    [_tableView reloadData]; // 从新加载列表
    [self showMapnode];      // 从新加载地图
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchResults removeAllObjects];
    if (!_mapView.hidden)
    {
        [self sceneChange:nil];
    }
    
    [self.bgSearchView removeFromSuperview];
    [self.searchBar resignFirstResponder];
    self.searchKey = searchBar.text;
    
    [self loadmoreDataSearStatus:YES];
}

#pragma mark - other method
- (void)clearLawyersShowMapPaopaoViewStatus
{
    for (LBSLawfirm *lawfirm in _listContend)
    {
        lawfirm.isShowMapLawfirmAnnotationPaopaoView = NO;
    }
}

- (UIImage *)getMapAnnotationPointImageWithIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",index]];
    
    return image;
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.listContend removeAllObjects];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 进入具体地图页面
    if ([segue.identifier isEqualToString:@"toDetailLawfirmLocation"]) {
        
        UINavigationController * navVC = segue.destinationViewController;
        DetailLocationViewController *vc = (DetailLocationViewController *)[navVC.viewControllers lastObject];
        vc.locationType = SearchHouse;
        vc.LBSLocation = self.seletedlawfirm;
    }
    else if ([segue.identifier isEqualToString:@"SearchtoDetailLawfirm"])// 进入律所具体详情界面
    {
        DetailLawfirmViewController * vc =(DetailLawfirmViewController *) segue.destinationViewController;
        vc.lawfirmid = [self.seletedlawfirm.lfid integerValue];
        vc.lawfirm = self.seletedlawfirm;
    }
}

#pragma mark - LawFirmCellDelegate methods

- (void)LawFirmCell:(LawfirmCell *)cell didClickOperationBtnWithType:(LawFirmCellOperationType)type sender:(id)sender
{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    LBSLawfirm *lawFirm = [self curDataWithIndex:indexPath.row];;
    
    switch (type)
    {
        case LawFirmCellOperationType_MapLocation:
        {
            // 切换视图
            [self sceneChange:nil];
            
            // 设置地图annotation-paopao视图的弹出
            [self clearLawyersShowMapPaopaoViewStatus];
            lawFirm.isShowMapLawfirmAnnotationPaopaoView = YES;
            
            [self showMapnode];
        }
            break;
        case LawFirmCellOperationType_OpenUrl:
        {
            
        }
            break;
        case LawFirmCellOperationType_PhoneCall:
        {
           
        }
            break;
       
        default:
            break;
    }
}

@end
