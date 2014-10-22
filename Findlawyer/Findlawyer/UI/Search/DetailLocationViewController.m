//
//  DetailLocationViewController.m
//  Find lawyer
//
//  Created by macmini01 on 14-8-21.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLocationViewController.h"
#import "LBSLawfirm.h"
#import "LBSLawyer.h"
#import "LBSSharedData.h"
#import "BMKLawyerPaoPaoView.h"
#import "BMKLawfirmPaoPaoView.h"
#import "DetailLawfirmViewController.h"
#import "DetailLawyerViewController.h"

@interface DetailLocationViewController ()
{
    LBSLawfirm              *_lawfirm;
    LBSLawyer               *_lawyer;
}
@end

@implementation DetailLocationViewController

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
    
    CGFloat statusBarHigh = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat high = [UIScreen mainScreen].bounds.size.height - statusBarHigh - navBarHigh;
    CGRect subviewframe = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), high);
    self.mapView = [[BMKMapView alloc]initWithFrame:subviewframe];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self showMapNode];
    // Do any additional setup after loading the view.
}


// 根据加载地图
- (void) showMapNode
{
    if (self.locationType == SearchHouse)
    {
        _lawfirm = (LBSLawfirm *)self.LBSLocation;
        CLLocationCoordinate2D coor = _lawfirm.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(kMapShowSpan,kMapShowSpan));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        _lawfirm.isShowMapLawfirmAnnotationPaopaoView = YES;
        [self.mapView setRegion:adjustedRegion animated:YES];
        LBSLocationAnnotation *locationAnnotation = [[LBSLocationAnnotation alloc] initWithLawfirm:_lawfirm];
        [self.mapView addAnnotation:locationAnnotation];
        [self setNavigationItemTitle:_lawfirm.name];
    }
    else
    {
        _lawyer = (LBSLawyer *)self.LBSLocation;
        CLLocationCoordinate2D coor = _lawyer.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(kMapShowSpan,kMapShowSpan));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        _lawyer.isShowMapLawyerAnnotationPaopaoView = YES;
        [self.mapView setRegion:adjustedRegion animated:YES];
        LBSLawyerLocationAnnotation *locationAnnotation = [[LBSLawyerLocationAnnotation alloc] initWithLawyer:_lawyer];
        [self.mapView addAnnotation:locationAnnotation];
        [self setNavigationItemTitle:_lawyer.name];
    }

}

//地图代理方法
#pragma mark -BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[LBSLocationAnnotation class]] || [annotation isKindOfClass:[LBSLawyerLocationAnnotation class]])
    {

        // 生成重用标示identifier
        NSString *AnnotationViewID = @"renameMark";
        
        // 检查是否有重用的缓存
        BMKAnnotationView* newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        newAnnotationView.image = [UIImage imageNamed:@"1"];
        
        
        if (_locationType == SearchHouse)
        {
            // paopao视图
            BMKLawfirmPaoPaoView *paopaoView = [BMKLawfirmPaoPaoView loadFromNib];
            
            // 加载paopao视图的数据
            [paopaoView loadViewData:((LBSLocationAnnotation*)annotation).lawfirm];
            newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        }
        else
        {
            BMKLawyerPaoPaoView *paopaoView = [BMKLawyerPaoPaoView loadFromNib];
            // 加载paopao视图的数据
            [paopaoView loadViewData:((LBSLawyerLocationAnnotation*)annotation).lawyer];
            newAnnotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:paopaoView];
        }

        return newAnnotationView;
    }
    return nil;

    /*
    if ([annotation isKindOfClass:[LBSLocationAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
     */
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (BMKAnnotationView *annotationView in views)
    {
        if (_locationType == SearchHouse)
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
        else
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
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if (_locationType == SearchHouse)
    {
        LBSLocationAnnotation *locationAnnotation = view.annotation;
        DetailLawfirmViewController * vc = [[DetailLawfirmViewController alloc] init];
        vc.lawfirmid = [locationAnnotation.lawfirm.lfid integerValue];
        vc.lawfirm = locationAnnotation.lawfirm;
        [self pushViewController:vc];
    }
    else
    {
        LBSLawyerLocationAnnotation *annotation = view.annotation;
        DetailLawyerViewController *detailLawyerVC = [[DetailLawyerViewController alloc] init];
        detailLawyerVC.lawyer = annotation.lawyer;
        detailLawyerVC.showConsultBtn = NO;
        [self pushViewController:detailLawyerVC];
    }
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
	
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放

    // [self showMapnode];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
    [_mapView viewWillDisappear];
    [self clearLawyersShowMapPaopaoViewStatus];
    
    [super viewWillDisappear:animated];
}

- (void)clearLawyersShowMapPaopaoViewStatus
{
    if (self.locationType == SearchHouse)
        _lawfirm.isShowMapLawfirmAnnotationPaopaoView = NO;
    else
        _lawyer.isShowMapLawyerAnnotationPaopaoView = NO;
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}




#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
