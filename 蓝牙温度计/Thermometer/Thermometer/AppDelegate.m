//
//  AppDelegate.m
//  rest_test
//
//  Created by swift on 15/1/23.
//  Copyright (c) 2015年 com.gjh. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarVC.h"
#import "AppPropertiesInitialize.h"
#import "PRPAlertView.h"
#import "UrlManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "RESideMenu.h"
#import "MainCenterVC.h"
#import "LeftUserCenterVC.h"
#import "AboutVC.h"
#import "AlarmSettingVC.h"
#import "TemperatureRecordVC.h"
#import "LoginVC.h"
#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/Extend/SMSSDK+AddressBookMethods.h>
#import "PasswordInputVC.h"
#import "BabyBluetooth.h"
#import "AccountStautsManager.h"
#import "UIFactory.h"

#define appKey      @"1942fa7c21588"
#define appSecret   @"3082cebc97dd25784def4167daee6d6e"

@interface AppDelegate () <NetRequestDelegate,RESideMenuDelegate>
{
    BaseTabBarVC *_baseTabBarController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 进行应用程序一系列属性的初始化设置
    [AppPropertiesInitialize startAppPropertiesInitialize];
    
    // 注册通知
    [UIFactory registerRemoteNotification];
    
    // 初始化应用，appKey和appSecret从后台申请得到
    [SMSSDK registerApp:appKey
             withSecret:appSecret];
    
//    _baseTabBarController = [[BaseTabBarVC alloc] init];
//    _baseTabBarController.viewControllers = @[
//                                              [[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]],
//                                              [[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]],
//                                              [[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]],
//                                              [[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]],
//                                              [[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]]];

    /*
    
    LeftUserCenterVC *leftMenuViewController = [[LeftUserCenterVC alloc] init];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:[MainCenterVC new]] leftMenuViewController:leftMenuViewController rightMenuViewController:nil];
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    self.window.rootViewController = sideMenuViewController;
     */
    
    MainCenterVC *mainVC = [[MainCenterVC alloc] init];
    LeftUserCenterVC *leftVC = [[LeftUserCenterVC alloc] init];
    leftVC.delegate = mainVC;
    
    /*
    self.slideMenuVC = [[HKSlideMenu3DController alloc] init];
    self.slideMenuVC.view.frame =  [[UIScreen mainScreen] bounds];
    self.slideMenuVC.mainViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.slideMenuVC.menuViewController = leftVC;
    self.slideMenuVC.backgroundImage = [UIImage imageNamed:@"leftmenu_bg"];
    self.slideMenuVC.backgroundImageContentMode = UIViewContentModeScaleAspectFill;
    self.slideMenuVC.enablePan = NO;
    */
    
    self.slideMenuVC = [[IIViewDeckController alloc] initWithCenterViewController:[[UINavigationController alloc] initWithRootViewController:mainVC] leftViewController:leftVC];
    
    /* To adjust speed of open/close animations, set either of these two properties. */
    self.slideMenuVC.leftSize = IIDeckViewLeftSize;
    self.slideMenuVC.panningCancelsTouchesInView = YES;
    self.slideMenuVC.panningMode = IIViewDeckPanningViewPanning;
    self.slideMenuVC.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    self.slideMenuVC.openSlideAnimationDuration = 0.2f;
    self.slideMenuVC.closeSlideAnimationDuration = 0.2f;
    self.slideMenuVC.panningView = mainVC.view;
    
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TemperatureRecordVC new]];

    //self.window.rootViewController = sideMenuViewController;

    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginVC loadFromNib]];
    
    self.window.rootViewController = _slideMenuVC;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:Common_ThemeColor];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [AccountStautsManager sharedInstance].enterBackground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [AccountStautsManager sharedInstance].enterBackground = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([AccountStautsManager sharedInstance].alarming && [[AccountStautsManager sharedInstance].alarmNoticeStr isAbsoluteValid]) {
        [[AccountStautsManager sharedInstance] showAlarmAlert:[AccountStautsManager sharedInstance].alarmNoticeStr];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[BabyBluetooth shareBabyBluetooth] cancelAllPeripheralsConnection];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    DLog(@"sss");
//    if (central.state == CBCentralManagerStatePoweredOn) {
//        [self.centralManger scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"f3d9"]]
//                                                   options:nil];
//    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[AccountStautsManager sharedInstance] showAlarmAlert:notification.alertBody];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"报警提示"
//                                                    message:notification.alertBody
//                                                   delegate:self
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:@"十分钟后再次提醒",@"二十分钟后再次提醒",@"三十分钟后再次提醒", nil];
//    [alert show];
}

#pragma mark - UIAlert Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[AccountStautsManager sharedInstance] handleThermometerAlertActionWithAlertButtonIndex:buttonIndex];
}

#pragma mark - /***************************推送相关***************************/

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // register to receive notifications
    //[application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    NSString *deviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    // DLog(@"token = %@", deviceTokenStr);
//    
//    // 保存token值
//    [UserInfoModel setUserDefaultDeviceToken:deviceTokenStr];
//    [self sendDeviceToken:deviceTokenStr];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //[self handleRemoteNotificationWithApplication:application notification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //[self handleRemoteNotificationWithApplication:application notification:userInfo];
}

////////////////////////////////////////////////////////////////////////////////

- (void)sendDeviceToken:(NSString *)deviceToken
{
    NSURL *url = [UrlManager getRequestUrlByMethodName:[BaseNetworkViewController getRequestURLStr:NetUploadDeviceTokenRequestType_UploadDeviceToken]];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:deviceToken forKey:@"deviceToken"];
    [dic setObject:@"ios" forKey:@"deviceType"];
    if ([UserInfoModel getUserDefaultUserId])
    {
        [dic setObject:[UserInfoModel getUserDefaultUserId] forKey:@"userId"];
    }
    
    [[NetRequestManager sharedInstance] sendRequest:url
                                       parameterDic:dic
                                  requestMethodType:RequestMethodType_POST
                                         requestTag:1000
                                           delegate:self
                                           userInfo:nil];
}

- (void)handleRemoteNotificationWithApplication:(UIApplication *)application notification:(NSDictionary *)userInfo
{
    NSDictionary *apsDic = [userInfo safeObjectForKey:@"aps"];
    
    NSString *alertBodyStr = [apsDic safeObjectForKey:@"alert"];
    NSNumber *commentId = [userInfo safeObjectForKey:@"id"];
    NSInteger type = [[userInfo safeObjectForKey:@"type"] integerValue];
    
    // 应用正在使用状态
    if (application.applicationState == UIApplicationStateActive)
    {
        // 弹窗提示再跳转
        WEAKSELF
        [PRPAlertView showWithTitle:@"推送信息"
                            message:alertBodyStr
                        cancelTitle:LocalizedStr(All_Cancel)
                        cancelBlock:^{
                            
                        } otherTitle:@"查看" otherBlock:^{
                            
                            [weakSelf pushToCommentDetailVCWithCommentId:commentId type:type];
                        }];
    }
    else
    {
        // 打开应用后直接跳转
        [self pushToCommentDetailVCWithCommentId:commentId type:type];
    }
    
    [UIFactory clearApplicationBadgeNumber];
}

// type 0: 晒单 1: 视频
- (void)pushToCommentDetailVCWithCommentId:(NSNumber *)commentId type:(NSInteger)type
{
    UIViewController *curSelectedController = [_baseTabBarController selectedViewController];
    
    if ([curSelectedController isKindOfClass:[UINavigationController class]])
    {
        if (0 == type)
        {
            /*
            CommentDetailVC *commentDetail = [[CommentDetailVC alloc] initWithCommentId:commentId.integerValue];
            commentDetail.isFromShareOrderVC = YES;
            commentDetail.hidesBottomBarWhenPushed = YES;
            
            [(UINavigationController *)curSelectedController pushViewController:commentDetail animated:YES];
             */
        }
        else if (1 == type)
        {
            
        }
    }
}

#pragma mark - NetRequestDelegate Methods

// 发生请求成功时
- (void)netRequest:(NetRequest *)request successWithDicInfo:(NSDictionary *)info
{
    NSLog(@"send the token success");
}

// 发送请求失败时
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    NSLog(@"send the token error : %@",error);
}


#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}



@end
