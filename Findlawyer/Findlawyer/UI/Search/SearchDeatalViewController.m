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
#import  "UIView+ProgressHUD.h"

#define HUDTage 999



@interface SearchDeatalViewController ()

{
  	NSUInteger currentIndex;
	NSUInteger pageSize;
	NSUInteger totalItemCount;
}

@property (assign, atomic) BOOL loading;
@property (assign, atomic) BOOL noMoreResultsAvail;
@property (assign, atomic) BOOL isLocationBasedSearch;
@property (assign, atomic) BOOL isHaveResult;


@property (nonatomic,strong ) NSMutableArray *searchResults;
@property (nonatomic,strong ) NSMutableArray * listContend;
@property (strong,nonatomic ) LBSLawfirm  *seletedlawfirm;

@end

@implementation SearchDeatalViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
   
    
    self.searchBar.delegate = self;
    self.searchResults =[[NSMutableArray alloc]init];
    self.listContend  = [[NSMutableArray alloc]init];
    
    CGFloat statusBarHigh = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat high = [UIScreen mainScreen].bounds.size.height - statusBarHigh - navBarHigh- CGRectGetHeight(self.searchBar.frame);
    CGRect subviewframe = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), CGRectGetWidth(self.view.frame), high);
    self.bgSearchView = [[UIView alloc]initWithFrame:subviewframe];
    
    self.bgSearchView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.tableView = [[UITableView alloc]initWithFrame:subviewframe];
   //先注册自定义的LawfirmCell以便重用
   [self.tableView registerNib:[UINib nibWithNibName:@"LawfirmCell" bundle:nil] forCellReuseIdentifier:@"LawfirmCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 15)];
    [self.view addSubview:self.tableView];

    // 开始时先加上地图，但先让地图隐藏，列表显示
    self.mapView = [[BMKMapView alloc]initWithFrame:subviewframe];
    self.mapView.hidden = YES;
    [self.view addSubview:self.mapView];
    self.tableView.hidden = NO;
    
    self.title = self.strTitle;;

    self.searchBar.placeholder = @"请输入你要找的律师事务所名称";
    
    if (self.searchKey.length >0)
    {
        self.searchBar.text = self.searchKey;
    }
    [self loadmoreData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     [self addSignalObserver];
 
    [self showMapnode];
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
 
    if (self.listContend.count >0) {
        
        LBSLawfirm *lawyerfirm = [self.listContend objectAtIndex:0];
        CLLocationCoordinate2D coor = lawyerfirm.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        
        NSArray * array = [NSArray arrayWithArray:[self.mapView annotations]];
        if (array.count >0) {
              [self.mapView removeAnnotations:array];
        }
        [self loadAnnotationWithArray:self.listContend];
    }
    else
    {
        AppDelegate *delegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
        CLLocationCoordinate2D coor;
        coor.latitude = delegate.userlocation.coordinate.latitude;
        coor.longitude= delegate.userlocation.coordinate.longitude;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
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
			[self.mapView addAnnotations:annotations];
		});
	});
	
}
// 列表和地图模式切换
- (IBAction)sceneChange:(id)sender {
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"列表"]) {
       
        self.mapView.hidden = YES;
        self.tableView.hidden = NO;
        self.navigationItem.rightBarButtonItem.title = @"地图";
    }
    else
    {
        if (self.tableView) {
            self.tableView.hidden = YES;
            self.mapView.hidden = NO;
            [self showMapnode];
        }
        self.navigationItem.rightBarButtonItem.title = @"列表";
    }
}

// 处理cell 中各种BUtton 发出的通知

- (void)receiveSignal:(QSignal *)signal
{
    if ([signal.name isEqualToString:SignalCellShowMap] && [self isViewLoaded])
    {
       NSDictionary * userinfo = signal.userInfo;
       NSIndexPath * cellindexpath = [userinfo objectForKey:@"cellindexPath"];
       self.seletedlawfirm = [self.listContend objectAtIndex:cellindexpath.row];
       [self showMap];
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
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES; // 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
	
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{

}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    
}



// 搜索加载数据
#pragma mark - DataModle

- (void)loadmoreData
{

    [self showHUDWithTitle:@"搜索中...."];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    __weak SearchDeatalViewController *weakSelf = self;
    
    // 添加请求
    [[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestUpdateLocation]] locationUpdateComplete:^(CLLocation *location) {
        if (location)
        {
            [[LBSSharedData sharedData] setCurrentCoordinate2D:location.coordinate];
            // 得到地理坐标后，进行百度LBS云搜索
            [weakSelf loadDataWithLocation:location.coordinate radius:200000];
        }
        else
        {    // 没有坐标则显示定位失败
            [self hideHUDWithTitle:@"定位失败!" image:nil delay:1];
                     self.navigationItem.rightBarButtonItem.enabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");
           
            });
        }
    }];
    return;
}


 // 用地理坐标进行百度LBS云搜索
- (void)loadDataWithLocation:(CLLocationCoordinate2D)location radius:(NSUInteger)radius
{
    __weak  SearchDeatalViewController * weakSelf = self;
    [[LBSDataCenter defaultCenter] loadDataWithNearby:location radius:radius searchtype:SearchHouse searchKye:self.searchKey index:currentIndex     pageSize:pageSize pieceComplete:^(LBSRequest *request, NSDictionary *dataModel) {
        if (dataModel)
		{
            // 将得到的数据初始化律所这个数据
            LBSLawfirm *lawfirm = [[LBSLawfirm alloc]initWithDataModel:dataModel];
            [weakSelf.listContend addObject:lawfirm];// 将取到的数据放在数组里
        }
		else
		{
           self.navigationItem.rightBarButtonItem.enabled = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.listContend count]);
				NSUInteger curCnt = [weakSelf.listContend count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
				if (request.error)

                    [self hideHUDWithTitle:LBSUINetWorkError image:nil delay:1];
                
				else if (request.availableItemCount)

                    [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:1];

				else

                     [self hideHUDWithTitle:LBSUIDataComplete image:nil delay:1];

				[weakSelf.tableView reloadData];//从新加载列表
                [self showMapnode];// 从新加载地图地图
            
            });
        }
	
    }];
}

// 以城市为单位进行搜索
- (void)loadLocalData
{
     __weak  SearchDeatalViewController * weakSelf = self;
    [[LBSDataCenter defaultCenter] loadDataWithRegionSearchkey:self.searchKey searchtype:SearchHouse index:currentIndex pageSize:pageSize pieceComplete:^(LBSRequest *request, id dataModel) {
        if (dataModel)
		{
            LBSLawfirm *lawfirm = [[LBSLawfirm alloc]initWithDataModel:dataModel];
            [weakSelf.listContend addObject:lawfirm];
        }
		else
		{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reload data now.");
				totalItemCount = request.availableItemCount;
				NSLog(@"total:%d, loaded:%d", totalItemCount, [weakSelf.listContend count]);
				NSUInteger curCnt = [weakSelf.listContend count];
				if (curCnt >= totalItemCount)
					_noMoreResultsAvail = YES;
				if (request.error)
                    //	[iToast make:LBSUINetWorkError duration:750];
                    [UIView hideHUDWithTitle:LBSUINetWorkError image:nil onView: weakSelf.view tag:HUDTage delay:1];
                
				else if (request.availableItemCount)
					//[iToast make:LBSUIDataComplete duration:750];
                    [UIView hideHUDWithTitle:LBSUIDataComplete image:nil onView: weakSelf.view tag:HUDTage delay:1];
                
				else
                    //	[iToast make:LBSUINoMoreData duration:750];
                    [UIView hideHUDWithTitle:LBSUINoMoreData image:nil onView: weakSelf.view tag:HUDTage delay:1];
                
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
	//currentIndex++;
	//[[LBSSharedData sharedData] setCurrentIndex:currentIndex];


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

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"LawfirmCell"];
    [self configureLawfirmCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.seletedlawfirm = [self.listContend objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SearchtoDetailLawfirm" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.backgroundColor = [UIColor clearColor];
    lable.font = [UIFont boldSystemFontOfSize:15];
    // lable.textColor = [UIColor colorWithRed:0 green:122/255.0 blue:255.0/255.0 alpha:1];
    [view addSubview:lable];
    lable.text = [NSString stringWithFormat:@"  搜索到%d家律师事务所",self.listContend.count];
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
    [self.bgSearchView removeFromSuperview];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
   
    [self.bgSearchView removeFromSuperview];
    [self.searchBar resignFirstResponder];
    self.searchKey = searchBar.text;
    
    if (self.listContend.count >0) {
        [self.listContend removeAllObjects];
    }
    [self loadmoreData];
}


#pragma mark -


- (void)dealloc
{
    [self.mapView  removeFromSuperview];
    self.mapView = nil;
    self.mapView.delegate = nil;
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
