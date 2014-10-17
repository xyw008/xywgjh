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

#define HUDTage 999
#define kRadius 200000
#define kHeardHeight 18


@interface SearchDeatalViewController ()
{
  	NSUInteger currentIndex;
	NSUInteger pageSize;
	NSUInteger totalItemCount;
    
    BMKMapView *_mapView;
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
    }
    return self;
}

- (void)initialize
{
    [super initialize];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentIndex = 0;
    pageSize = 30;
   
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Search_topBar_bg"] forState:UIControlStateNormal];
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"searchBG"]];
    self.searchBar.delegate = self;
    
    self.allLawyerEntityArray = [NSMutableArray array];
    self.searchResults =[[NSMutableArray alloc]init];
    self.listContend  = [[NSMutableArray alloc]init];
    
    CGRect subviewframe = CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.viewBoundsWidth, self.viewBoundsHeight - CGRectGetMaxY(_searchBar.frame));
    self.bgSearchView = [[UIView alloc]initWithFrame:subviewframe];
    
    self.bgSearchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.tableView = [[UITableView alloc]initWithFrame:subviewframe];
   //先注册自定义的LawfirmCell以便重用
   [self.tableView registerNib:[UINib nibWithNibName:@"LawfirmCell" bundle:nil] forCellReuseIdentifier:@"LawfirmCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView keepAutoresizingInFull];
    [self.view addSubview:self.tableView];

    // 开始时先加上地图，但先让地图隐藏，列表显示
    _mapView = [[BMKMapView alloc] initWithFrame:subviewframe];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [_mapView keepAutoresizingInFull];
    [self.view addSubview:_mapView];
    
    //判断是显示地图还是列表
    _mapView.hidden = !_isShowMapView;
    self.tableView.hidden = _isShowMapView;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:_isShowMapView?@"列表":@"地图" action:@selector(sceneChange:)];
    
    self.title = self.strTitle;;
    self.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    
    [self loadmoreDataSearStatus:NO];
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
// 设置地图中心位置，加载地图标注
- (void) showMapnode
{
    NSArray * array = [NSArray arrayWithArray:[_mapView annotations]];
    if (array.count >0) {
        [_mapView removeAnnotations:array];
    }
    
    if (self.listContend.count >0) {
        
        LBSLawfirm *lawyerfirm = [self.listContend objectAtIndex:0];
        CLLocationCoordinate2D coor = lawyerfirm.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    
        [self loadAnnotationWithArray:self.listContend];
    }
    else
    {
        /*
        AppDelegate *delegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
        CLLocationCoordinate2D coor;
        coor.latitude = delegate.userlocation.coordinate.latitude;
        coor.longitude= delegate.userlocation.coordinate.longitude;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
         */
    }
}

//根据地图数据 配置地图标注

- (void)loadAnnotationWithArray:(NSArray *)information
{
	if (information.count == 0) return;
	NSArray *retainedInforation = information;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[retainedInforation count]];
		for (LBSLawfirm *lawyerfirm in retainedInforation) {
			LBSLocationAnnotation *locationAnnotation = [[LBSLocationAnnotation alloc] initWithLawfirm:lawyerfirm];
			[annotations addObject:locationAnnotation];
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			[_mapView addAnnotations:annotations];
		});
	});
	
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
            self.tableView.hidden = NO;
        }
        else
        {
            if (self.tableView)
            {
                self.tableView.hidden = YES;
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
        //        DLog("space is %f - %@",theAnnotation.lawyer.distance, theAnnotation.lawyer.lawfirmName);
        
        // 生成重用标示identifier
        NSString *AnnotationViewID = @"renameMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:theAnnotation reuseIdentifier:AnnotationViewID];
        }
        
        newAnnotationView.image = [self getMapAnnotationPointImageWithIndex:[self.listContend indexOfObject:theAnnotation.lawfirm] + 1];
        
        // paopao视图
        BMKLawfirmPaoPaoView *paopaoView = [BMKLawfirmPaoPaoView loadFromNib];
        
        // 加载paopao视图的数据
        [paopaoView loadViewData:theAnnotation.lawfirm];
        newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        
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
    LBSLocationAnnotation *locationAnnotation = view.annotation;
    DetailLawfirmViewController * vc = [[DetailLawfirmViewController alloc] init];
    vc.lawfirmid = [locationAnnotation.lawfirm.lfid integerValue];
    vc.lawfirm = locationAnnotation.lawfirm;
    [self pushViewController:vc];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}


// 搜索加载数据
#pragma mark - DataModle

- (void)loadmoreDataSearStatus:(BOOL)isSearch
{
//    [self showHUDWithTitle:@"搜索中...."];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak SearchDeatalViewController *weakSelf = self;
    
    // 添加请求
    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestUpdateLocation]] locationUpdateComplete:^(CLLocation *location) {
        if (location)
        {
            [[LBSSharedData sharedData] setCurrentCoordinate2D:location.coordinate];
            // 得到地理坐标后，进行百度LBS云搜索
            [weakSelf loadDataWithLocation:location.coordinate radius:kRadius searchKey:self.searchKey IsSearStatus:isSearch];
        }
        else
        {    // 没有坐标则显示定位失败
//            [self hideHUDWithTitle:@"定位失败!" image:nil delay:HUDAutoHideTypeShowTime];
            [HUDManager showAutoHideHUDWithToShowStr:@"定位失败" HUDMode:MBProgressHUDModeText];
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
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
    [self showHUDWithTitle:@"搜索中...."];
//    [HUDManager showHUDWithToShowStr:@"搜索中..." HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0 userInteractionEnabled:YES];
    __weak  SearchDeatalViewController * weakSelf = self;
    
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
           self.navigationItem.rightBarButtonItem.enabled = YES;
            
            weakSelf.listContend = !isSearch ? weakSelf.allLawyerEntityArray : weakSelf.searchResults;
            
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
                    [self hideHUDWithTitle:LBSUINetWorkError image:nil delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINetWorkError HUDMode:MBProgressHUDModeText];
                
				else if (request.availableItemCount)
                    
                    [self removeProgressHUD];
//                    [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:HUDAutoHideTypeShowTime];
                     /*
                    [HUDManager hideHUD];
                      */
				else
                    /*
                     [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:HUDAutoHideTypeShowTime];
                     */
                    [HUDManager showAutoHideHUDWithToShowStr:LBSUINoMoreData HUDMode:MBProgressHUDModeText];
                
				[weakSelf.tableView reloadData];//从新加载列表
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
    
     __weak  SearchDeatalViewController * weakSelf = self;
    
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
                
				[weakSelf.tableView reloadData];

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



#pragma mark - UITableViewDatasource And UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listContend.count;
}


// 用自定义cell显示每个律所数据
- (void)configureLawfirmCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LawfirmCell *lfcell = (LawfirmCell *)cell;// 自定义LawfirmCell
    LBSLawfirm *lawfirm = [self.listContend objectAtIndex:indexPath.row];
    lfcell.lbName.text = lawfirm.name;
    lfcell.lbAddress.text = lawfirm.address;
    lfcell.lbMembercount.text = [NSString stringWithFormat:@"%@",lawfirm.memberCount];
    [lfcell.imgIntroduct setImageWithURL:lawfirm.mainImageURL placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];
    lfcell.cellindexPath = indexPath;
    lfcell.lineView.hidden = NO;
    if (indexPath.row + 1 == self.listContend.count) {
        lfcell.lineView.hidden = YES;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LawfirmCell"];
    [cell addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:HEXCOLOR(0XE7E6E5) lineWidth:1];
    
    [self configureLawfirmCell:cell atIndexPath:indexPath];
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


- (void)dealloc
{
    [self removeSignalObserver];
}
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



@end
