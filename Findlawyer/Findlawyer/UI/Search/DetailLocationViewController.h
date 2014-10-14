//
//  DetailLocationViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-21.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "FLBaseViewController.h"

@interface DetailLocationViewController : FLBaseViewController<BMKMapViewDelegate>

@property (nonatomic,strong) BMKMapView * mapView;
@property (nonatomic,strong) id  LBSLocation;// 地理标注信息
@property (nonatomic) NSInteger locationType; // 表示是律所还是律师的Location


- (IBAction)back:(id)sender;

@end
