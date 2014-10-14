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


@interface DetailLocationViewController ()

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
    [self.view addSubview:self.mapView];
    [self showMapNode];
    // Do any additional setup after loading the view.
}

// 根据加载地图
- (void) showMapNode
{
    if (self.locationType == SearchHouse)
    {
        LBSLawfirm *lawfirm = (LBSLawfirm *)self.LBSLocation;
        CLLocationCoordinate2D coor = lawfirm.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        LBSLocationAnnotation *locationAnnotation = [[LBSLocationAnnotation alloc] initWithLawfirm:lawfirm];
        [self.mapView addAnnotation:locationAnnotation];
    }
    else
    {
        LBSLawyer *lawyer = (LBSLawyer *)self.LBSLocation;
        CLLocationCoordinate2D coor = lawyer.coordinate;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.05f,0.05f));
        BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        LBSLawyerLocationAnnotation *locationAnnotation = [[LBSLawyerLocationAnnotation alloc] initWithLawyer:lawyer];
        [self.mapView addAnnotation:locationAnnotation];
    }

}

//地图代理方法
#pragma mark -BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[LBSLocationAnnotation class]])
    {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
	
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
	//LBSLocationAnnotation *locationAnnotation = view.annotation;
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.mapView viewWillAppear];
    self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    // [self showMapnode];
}

-(void)viewWillDisappear:(BOOL)animated
{
   [self.mapView viewWillDisappear];
   self.mapView.delegate = nil; // 不用时，置nil
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
