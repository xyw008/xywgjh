//
//  AppDelegate.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,CLLocationManagerDelegate>

{
    BMKMapManager* _mapManager;
    BOOL ifgetnewloacation;
   
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString * currentCity;
@property (strong, nonatomic) CLLocationManager *locationmanage;;
@property (strong,nonatomic ) CLLocation *userlocation;

- (void)chooseMaintabIndex:(NSInteger)index andType:(NSInteger)type;

@end
