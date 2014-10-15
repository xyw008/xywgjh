//
//  SearchLawyerViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-20.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SearchLawyerViewController.h"

#import "AppDelegate.h"
#import "LawfirmCell.h"
#import "LawyerCell.h"
#import "LBSLawyer.h"
#import "LBSLawfirm.h"
#import "LBSLawyer.h"
#import "LBSDataBase.h"
#import "LBSRequestManager.h"
#import "LBSRequest+LBSSearchRegion.h"
#import "LBSRequest+LBSSearchNearby.h"
#import "LBSDataCenter.h"
#import "LBSSharedData.h"
#import  "UIView+ProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "QSignalManager.h"
#import "DetailLocationViewController.h"
#import "DetailLawyerViewController.h"
#import <MessageUI/MessageUI.h>
#import "ACETelPrompt.h"
#import "Network.h"
#import "BMKLawyerPaoPaoView.h"
#import "UIFactory.h"

#define HUDTage 999


@interface SearchLawyerViewController ()<MFMessageComposeViewControllerDelegate, LawyerCellDelegate>

{
  	NSUInteger currentIndex;
	NSUInteger pageSize;
	NSUInteger totalItemCount;
    
}

@property (assign, atomic) BOOL loading;
@property (assign, atomic) BOOL noMoreResultsAvail;
@property (assign, atomic) BOOL isLocationBasedSearch;
@property (assign, atomic) BOOL isHaveResult;

@property (nonatomic,strong) NSMutableArray *allLawyerEntityArray;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) NSMutableArray * listContend;          // 当前展示的数据(有可能是全部也有可能是搜索出得结果)

@property (strong,nonatomic) LBSLawyer * seletedlawyer;

@end

@implementation SearchLawyerViewController

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
    
    currentIndex = 0;
    pageSize = 30;
    
    self.title = self.strTitle;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, 44)];
    self.searchBar.placeholder = @"请输入你要找的律师";
    if (self.searchKey.length >0) {
        self.searchBar.text = self.searchKey;
    }
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Search_topBar_bg"] forState:UIControlStateNormal];
    self.searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    self.allLawyerEntityArray = [NSMutableArray array];
    self.searchResults =[[NSMutableArray alloc]init];
    self.listContend  = [[NSMutableArray alloc]init];
    
    CGRect subviewframe = CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.viewBoundsWidth, self.viewBoundsHeight - CGRectGetMaxY(_searchBar.frame));
    self.bgSearchView = [[UIView alloc]initWithFrame:subviewframe];
    self.bgSearchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    
    self.tableView = [[UITableView alloc]initWithFrame:subviewframe];
    [_tableView keepAutoresizingInFull];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = HEXCOLOR(0XF0F0F0);
    
    //先注册自定义的LawyerCell以便重用
    [self.tableView registerNib:[UINib nibWithNibName:@"LawyerCell" bundle:nil] forCellReuseIdentifier:@"LawyerCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15)];
    [self.view addSubview:self.tableView];
    
    //开始时先加上地图，但先让地图隐藏，列表显示
    self.mapView = [[BMKMapView alloc]initWithFrame:subviewframe];
    [_mapView keepAutoresizingInFull];
    [self.view addSubview:self.mapView];
    
    //判断是显示地图还是列表
    self.mapView.hidden = !_isShowMapView;
    self.tableView.hidden = _isShowMapView;
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Right barButtonTitle:_isShowMapView?@"列表":@"地图" action:@selector(sceneChange:)];
   
    [self loadmoreDataIsSearStatus:NO];
    // [self loadLocalData];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     [self addSignalObserver];
    // [self showMapnode];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    [self removeSignalObserver];
}

// 设置地图中心位置，加载地图标注
- (void) showMapnode
{
    if ([_mapView.annotations isAbsoluteValid])
    {
        NSArray * array = [NSArray arrayWithArray:[_mapView annotations]];
        [self.mapView removeAnnotations:array];
    }
    
    if (self.listContend.count > 0)
    {
        LBSLawyer *lawyer = [self.listContend objectAtIndex:0];
        CLLocationCoordinate2D coor = lawyer.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
      //  [self.mapView setCenterCoordinate:coor];
        
        [self loadAnnotationWithArray:self.listContend];
    }
    else
    {
        /*
        AppDelegate *delegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
        CLLocationCoordinate2D coor;
        coor.latitude = delegate.userlocation.coordinate.latitude;
        coor.longitude = delegate.userlocation.coordinate.longitude;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        
        [self.mapView setRegion:adjustedRegion animated:YES];
         */
    }
}

//根据地图数据 配置地图标注
- (void)loadAnnotationWithArray:(NSArray *)information
{
	if (information == nil) return;
    
	NSArray *retainedInforation = information;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[retainedInforation count]];
        
		for (LBSLawyer *lawyer in retainedInforation) {
			LBSLawyerLocationAnnotation *locationAnnotation = [[LBSLawyerLocationAnnotation alloc] initWithLawyer:lawyer];
			[annotations addObject:locationAnnotation];
		}
        
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.mapView addAnnotations:annotations];
		});
	});
	
}

// 列表和地图模式切换
- (void)sceneChange:(id)sender
{
    _isShowMapView = !_isShowMapView;

    [UIView transitionWithView:self.view duration:.45 options:!_isShowMapView ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight animations:^{
        if (!_isShowMapView)
        {
            self.mapView.hidden = YES;
            self.tableView.hidden = NO;
        }
        else
        {
            if (self.tableView)
            {
                self.tableView.hidden = YES;
                self.mapView.hidden = NO;
                
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
    if ([signal.name isEqualToString:SignalCellShowMap]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.listContend objectAtIndex:cellindexpath.row];
        [self showMap];
    }
    else if ([signal.name isEqualToString:SignalCellCall]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.listContend objectAtIndex:cellindexpath.row];
        [self callNumber];
    }
    else if ([signal.name isEqualToString:SignalCellSendSms]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.listContend objectAtIndex:cellindexpath.row];
        [self senSms];
    }
    else if ([signal.name isEqualToString:SignalCellConSult]&& [self isViewLoaded])
    {
        NSDictionary * userinfo = signal.userInfo;
        NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
        self.seletedlawyer = [self.listContend objectAtIndex:cellindexpath.row];
        [self consult];
    }
}

// 显示地图
- (void)showMap
{
    NSLog(@"CellShowMap");
    [self performSegueWithIdentifier:@"toDettailLawyerLocaion" sender:self];
}
//发送短信
- (void)senSms
{
    [self presentMessageComposeViewControllerWithNumber:self.seletedlawyer.mobile];
}
// 拨打电话
- (void)callNumber
{
    NSLog(@"CellCallNumber");
    [self callNumber:self.seletedlawyer.mobile];
}

// 咨询
- (void)consult
{
     NSLog(@"Cellconsult");
}
#pragma mark - callNumber And consult

- (void)callNumber:(NSString *)number
{
    if (number.length > 0)
    {
        if ([[Network sharedNetwork]isRightMobile:number]) {
            BOOL success = [ACETelPrompt callPhoneNumber:number
                                                    call:^(NSTimeInterval duration) {
                                                    }
                            
                                                  cancel:^{
                                                      
                                                  }];
            if (!success)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码无效，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法手机号" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)conusult
{
    
}

//发送短信

#pragma mark - Present message compose view controller

- (void)presentMessageComposeViewControllerWithNumber:(NSString *)number
{
    if (number.length > 0) {
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil)
        {
            if ([MFMessageComposeViewController canSendText])
            {
                
                MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
                vc.messageComposeDelegate = self;
                NSArray * array = @[number];
                vc.recipients = array;
                // vc.body =@"";
                [self.parentViewController presentViewController:vc animated:YES completion:nil];
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉！该设备不支持发送短信的功能" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (UIImage *)getMapAnnotationPointImageWithIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",index]];
    
    return image;
}

#pragma mark - Message compose view controller delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    if (result == MessageComposeResultCancelled)
    {
    }
    else if (result == MessageComposeResultSent)
    {
    }
    else
    {
    }
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

// 地图的一些代理方法，根据需要添加
#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[LBSLawyerLocationAnnotation class]])
    {
        LBSLawyerLocationAnnotation *theAnnotation = (LBSLawyerLocationAnnotation *)annotation;
//        DLog("space is %f - %@",theAnnotation.lawyer.distance, theAnnotation.lawyer.lawfirmName);
        
        // 生成重用标示identifier
        NSString *AnnotationViewID = @"renameMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:theAnnotation reuseIdentifier:AnnotationViewID];
        }
        
        newAnnotationView.image = [self getMapAnnotationPointImageWithIndex:[self.listContend indexOfObject:theAnnotation.lawyer] + 1];
        
        // paopao视图
        BMKLawyerPaoPaoView *paopaoView = [BMKLawyerPaoPaoView loadFromNib];
        
        // 加载paopao视图的数据
        [paopaoView loadViewData:theAnnotation.lawyer];
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
        LBSLawyerLocationAnnotation *locationAnnotation = annotationView.annotation;
        
        if ([locationAnnotation isKindOfClass:[LBSLawyerLocationAnnotation class]] && locationAnnotation.lawyer.isShowMapLawyerAnnotationPaopaoView)
        {
            [mapView selectAnnotation:locationAnnotation animated:YES];
            [mapView setCenterCoordinate:locationAnnotation.coordinate animated:YES];
            
            // 清除lawyer paopao视图的弹出状态
            [self clearLawyersShowMapPaopaoViewStatus];
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
	
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
	
}


// 搜索加载数据
#pragma mark - DataModle

- (void)loadmoreDataIsSearStatus:(BOOL)isSearch
{
    // [iToast make:@"搜索中..." duration:1000000];
    [UIView showHUDWithTitle:@"搜索中..." onView:self.view tag:HUDTage];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak SearchLawyerViewController *weakSelf = self;
    
      // 添加请求
    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestUpdateLocation]] locationUpdateComplete:^(CLLocation *location) {
        if (location)
        {
              //得到地理坐标后，进行百度LBS云搜索
            [[LBSSharedData sharedData] setCurrentCoordinate2D:location.coordinate];
            [weakSelf loadDataWithLocation:location.coordinate radius:200000 IsSearStatus:isSearch];
        }
        else
        {
            // 没有坐标则显示定位失败
            //  [iToast make:@"定位失败:(" duration:750];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [UIView hideHUDWithTitle:@"定位失败!" image:nil onView: weakSelf.view tag:HUDTage delay:1];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");

            });
        }
    }];
    return;
}


 // 用地理坐标进行百度LBS云搜索
- (void)loadDataWithLocation:(CLLocationCoordinate2D)location radius:(NSUInteger)radius IsSearStatus:(BOOL)isSearch
{
    __weak  SearchLawyerViewController * weakSelf = self;
    [[LBSDataCenter defaultCenter] loadDataWithNearby:location radius:radius searchtype:searchLawyer searchKye:self.searchKey index:currentIndex pageSize:pageSize pieceComplete:^(LBSRequest *request, NSDictionary *dataModel) {
        if (dataModel)
		{
//            DLog(@"searchkey = %@  index = %d page = %d",self.searchKey,currentIndex,pageSize);
            
            // 将得到的数据初始化律师这个数据
            LBSLawyer *lawyer = [[LBSLawyer alloc]initWithDataModel:dataModel];
            /*
            [weakSelf.listContend addObject:lawyer];// 将取到的数据放在数组里
             */
            if (!isSearch)
            {
                [weakSelf.allLawyerEntityArray addObject:lawyer];
            }
            else
            {
                [weakSelf.searchResults addObject:lawyer];
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
                    //	[iToast make:LBSUINetWorkError duration:750];
                    [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				else if (request.availableItemCount)
					//[iToast make:LBSUIDataComplete duration:750];
                    [UIView hideHUDWithTitle:LBSUIDataComplete image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				else
                    //	[iToast make:LBSUINoMoreData duration:750];
                    [UIView hideHUDWithTitle:LBSUINoMoreData image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				[weakSelf.tableView reloadData];//从新加载列表
                [self showMapnode];// 从新加载地图地图
                
            });
        }
        
    }];
}

// 以城市为单位进行搜索
- (void)loadLocalData
{
    [UIView showHUDWithTitle:@"搜索中..." onView:self.view tag:HUDTage];
    
    __weak  SearchLawyerViewController * weakSelf = self;
    
    [[LBSDataCenter defaultCenter] loadDataWithRegionSearchkey:self.searchKey searchtype:searchLawyer index:currentIndex pageSize:pageSize pieceComplete:^(LBSRequest *request, id dataModel) {
        if (dataModel)
		{
            LBSLawyer *lawyer = [[LBSLawyer alloc]initWithDataModel:dataModel];
            /*
            [weakSelf.listContend addObject:lawyer];
             */
            [weakSelf.searchResults addObject:lawyer];
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
                    //	[iToast make:LBSUINetWorkError duration:750];
                    [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				else if (request.availableItemCount)
					//[iToast make:LBSUIDataComplete duration:750];
                    [UIView hideHUDWithTitle:LBSUIDataComplete image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				else
                    //	[iToast make:LBSUINoMoreData duration:750];
                    [UIView hideHUDWithTitle:LBSUINoMoreData image:nil onView: weakSelf.view tag:HUDTage delay:HUDAutoHideTypeShowTime];
                
				[weakSelf.tableView reloadData];
                
            });
        }
        
    }];
    /*
    currentIndex++;
	[[LBSSharedData sharedData] setCurrentIndex:currentIndex];
    */
    
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
	//currentIndex++;
	//[[LBSSharedData sharedData] setCurrentIndex:currentIndex];
}

#pragma mark - UITableViewDatasource And UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listContend.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// 用自定义cell 显示每个律师数据
- (void)configureLawyerCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    LawyerCell *lycell = (LawyerCell *)cell;
    lycell.cellindexPath = indexPath;
    LBSLawyer *lawyer = [self.listContend objectAtIndex:indexPath.section];
    lycell.lbName.text = lawyer.name;
    lycell.lblawfirm.text = lawyer.lawfirmName;
    lycell.lbCertificate.text = lawyer.certificateNo;
    lycell.lbPhone.text = lawyer.mobile ? lawyer.mobile : @"暂无电话";
    lycell.specialAreaStr = lawyer.specialArea;

    [lycell.imgIntroduct setImageWithURL:lawyer.mainImageURL placeholderImage:[UIImage imageNamed:@"defaultlawyer"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LawyerCell";
    
    LawyerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    cell.delegate = self;
    /*
    if (!cell)
    {
        cell = [LawyerCell loadFromNib];
        cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
     */
    [self configureLawyerCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     self.seletedlawyer = [self.listContend objectAtIndex:indexPath.section];
    
    DetailLawyerViewController *detailLawyerVC = [[DetailLawyerViewController alloc] init];
    detailLawyerVC.lawyer = _seletedlawyer;
    [self pushViewController:detailLawyerVC];
    /*
    [self performSegueWithIdentifier:@"SearchtoLawyerDetail" sender:self];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        return 18;
    }
    else
    {
        return CellSeparatorSpace;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize size = [tableView rectForHeaderInSection:section].size;
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    lable.backgroundColor = 0 == section ? HEXCOLOR(0XF0F0F0) : [UIColor clearColor];
    lable.font = [UIFont boldSystemFontOfSize:12];
    if (0 == section)
    {
        lable.textColor = HEXCOLOR(0XB6B6B6);
        lable.text = [NSString stringWithFormat:@" 附近共%d位律师",self.listContend.count];
    }
    return lable;
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
    [self.searchBar setShowsCancelButton:NO animated:YES];;
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
    
    [self loadmoreDataIsSearStatus:YES];
}

#pragma mark -


- (void)dealloc
{
    [self.mapView  removeFromSuperview];
    self.mapView = nil;
    [self removeSignalObserver];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
      // 进入具体地图页面
     if ([segue.identifier isEqualToString:@"toDettailLawyerLocaion"]) {
         UINavigationController * navVC = segue.destinationViewController;
         DetailLocationViewController *vc = (DetailLocationViewController *)[navVC.viewControllers lastObject];
         vc.locationType = searchLawyer;
         vc.LBSLocation = self.seletedlawyer;
     }//律师详情界面
     else if ([segue.identifier isEqualToString:@"SearchtoLawyerDetail"]) {         DetailLawyerViewController *vc = (DetailLawyerViewController *)segue.destinationViewController;
         vc.lawyer = self.seletedlawyer;
     }

 }

#pragma mark - LawyerCellDelegate methods

- (void)LawyerCell:(LawyerCell *)cell didClickOperationBtnWithType:(LawyerCellOperationType)type sender:(id)sender
{
    LBSLawyer *cellSelectedLawyer = [_listContend objectAtIndex:[_tableView indexPathForCell:cell].section];
    
    switch (type)
    {
        case LawyerCellOperationType_MapLocation:
        {
            // 切换视图
            [self sceneChange:nil];
            
            // 设置地图annotation-paopao视图的弹出
            [self clearLawyersShowMapPaopaoViewStatus];
            cellSelectedLawyer.isShowMapLawyerAnnotationPaopaoView = YES;
            
            [self showMapnode];
        }
            break;
        case LawyerCellOperationType_SpecialAreaSearch:
        {
            UILabel *sepcialAreaLabel = (UILabel *)sender;

            [_searchResults removeAllObjects];
            
            self.searchKey = sepcialAreaLabel.text;
            [self loadLocalData];
        }
            break;
        case LawyerCellOperationType_Consult:
        {
            
        }
            break;
        /*
        case LawyerCellOperationType_PhoneCall:
        {
            [UIFactory call:cellSelectedLawyer.mobile];
        }
            break;
        case LawyerCellOperationType_SendMessage:
        {
            [UIFactory sendSMS:cellSelectedLawyer.mobile];
        }
            break;
        */
        default:
            break;
    }
}

// 清除lawyer paopao视图的弹出状态
- (void)clearLawyersShowMapPaopaoViewStatus
{
    for (LBSLawyer *lawyer in _listContend)
    {
        lawyer.isShowMapLawyerAnnotationPaopaoView = NO;
    }
}

@end

