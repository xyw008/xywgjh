//
//  AppDelegate.m
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "AppDelegate.h"
#import "ACETelPrompt.h"
#import "AppPropertiesInitialize.h"
#import "BaseTabBarVC.h"
#import "HomePageVC.h"
#import "SearchViewController.h"
#import "ConsultViewController.h"
#import "SettingViewController.h"
#import "SearchVC.h"
#import "MyMagic.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"1kL57f4WT8aD1HUXoV9umUGW" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    self.locationmanage = [[CLLocationManager alloc] init];
    self.locationmanage .delegate = self;
    self.locationmanage .desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        [self.locationmanage requestAlwaysAuthorization];
    }
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    HomePageVC *homePage = [[HomePageVC alloc] init];
    UINavigationController *homePageNav = [[UINavigationController alloc] initWithRootViewController:homePage];
    
    SearchVC *search = [[SearchVC alloc] init];
    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:search];
    
    /*
    ConsultViewController *consult = [[ConsultViewController alloc] init];
    UINavigationController *consultNav = [[UINavigationController alloc] initWithRootViewController:consult];
    */
    
    MyMagic *myMagic = [[MyMagic alloc] init];
    UINavigationController *myMagicNav = [[UINavigationController alloc] initWithRootViewController:myMagic];

    SettingViewController *setting = [[SettingViewController alloc] init];
    UINavigationController *settingNav = [[UINavigationController alloc] initWithRootViewController:setting];
    
    BaseTabBarVC *baseTabBarController = [[BaseTabBarVC alloc] init];
    baseTabBarController.viewControllers = @[homePageNav, searchNav, myMagicNav, settingNav];
    
    self.window.rootViewController = baseTabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self LocationUser];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)chooseMaintabIndex:(NSInteger)index
{
    
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) // 如果是属于TabBarController，说明已经进入主界面了
    {
        UITabBarController *mainTab = (UITabBarController *)self.window.rootViewController;
        mainTab.selectedIndex = index;
    }
}

-(void)LocationUser
{
    ifgetnewloacation =YES;

    [self.locationmanage startUpdatingLocation];
}

- (void)callPhone:(NSString *)number
{
    if (number.length > 0)
    {
        NSDate *begin_time = [NSDate date];
        
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码为空，拨打失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)sendSms:(id)receivers msg:(NSString *)msg
{
    
}



- (void)consult
{
    
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationmanage stopUpdatingLocation];
    if (ifgetnewloacation)
    {
      ifgetnewloacation = NO;
      self.userlocation = newLocation;
    }
     NSLog(@"Latitude =%f", newLocation.coordinate.latitude);
     NSLog(@"Longitude =%f", newLocation.coordinate.longitude);
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    self.userlocation = [[CLLocation alloc]initWithLatitude:22.5460540000 longitude:114.025974000];
    
    if ([error code] == kCLErrorDenied)
    {
        
        errorMsg = @"你未启用定位服务";
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:errorMsg
                                                           message:@"可到系统设置页面启用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alertView show];
        
    }
    
    if ([error code] == kCLErrorLocationUnknown) {
        // errorMsg = @"未能获取位置信息";
        //  NSLog(@"未能获取位置信息！");
        
        //  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:errorMsg
        //                                                           message: @"请检查网络" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        //        [alertView show];
    }
    [self.locationmanage stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case
        kCLAuthorizationStatusNotDetermined:
            if ([self.locationmanage respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationmanage requestAlwaysAuthorization];
            }
            
            break;
        default:
            break;
            
            
    } 
}



@end
