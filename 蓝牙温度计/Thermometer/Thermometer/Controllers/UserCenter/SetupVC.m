//
//  SetupVC.m
//  Thermometer
//
//  Created by leo on 15/11/22.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "SetupVC.h"
#import "YSBLEManager.h"
#import "AccountStautsManager.h"
#import "PRPAlertView.h"

@interface SetupVC ()
{
    UILabel     *_macLB;
}
@end

@implementation SetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    [self setNavigationItemTitle:LocalizedStr(setting)];
    
    CGFloat margin = 15;
    NSString *macAdd = [YSBLEManager sharedInstance].deviceIdentifier;
    
    _macLB = [[UILabel alloc] initWithFrame:CGRectMake(margin, 20, IPHONE_WIDTH - margin * 2, 40)];
    ViewRadius(_macLB, 5);
    _macLB.font = SP16Font;
    _macLB.backgroundColor = [UIColor whiteColor];
    _macLB.textColor = Common_BlackColor;
    _macLB.textAlignment = NSTextAlignmentCenter;
    _macLB.text = [macAdd isAbsoluteValid] ? [self macString:@"清空默认设备"] : [self macString:LocalizedStr(unconnec_device)];
    [self.view addSubview:_macLB];
    
    _macLB.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clearMacAdd:)];
    [_macLB addGestureRecognizer:longGesture];
    //_macLB.hidden = YES;
    
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(margin, CGRectGetMaxY(_macLB.frame) + 35, _macLB.width, 40);
    logoutBtn.backgroundColor = Common_GreenColor;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:LocalizedStr(log_out) forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font = SP16Font;
    ViewRadius(logoutBtn, 5);
    [self.view addSubview:logoutBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:kLogoutNotificationKey
                                               object:nil];
    
}

- (NSString *)macString:(NSString*)string
{
    return [NSString stringWithFormat:@"%@",string];
    //return [NSString stringWithFormat:@"   MAC地址           %@",string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)logoutBtnTouch:(UIButton*)btn
{
    //停止蓝牙
    [[YSBLEManager sharedInstance] cancelAllPeripheralsConnection];
    
    [UserInfoModel setUserDefaultLoginName:@""];
    [UserInfoModel setUserDefaultPassword:@""];
    
    [AccountStautsManager sharedInstance].isLogin = NO;
    [AccountStautsManager sharedInstance].nowUserItem = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutNotificationKey object:nil];
    
    [self backViewController];
}

- (void)clearMacAdd:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        if ([[YSBLEManager sharedInstance].deviceIdentifier isAbsoluteValid])
        {
            WEAKSELF
            [PRPAlertView showWithTitle:nil message:@"是否清除默认设备" cancelTitle:Cancel cancelBlock:nil otherTitle:Confirm otherBlock:^{
                STRONGSELF
                strongSelf->_macLB.text = [strongSelf macString:LocalizedStr(unconnec_device)];
                [YSBLEManager sharedInstance].macAdd = nil;
                [YSBLEManager sharedInstance].deviceIdentifier = nil;
                [UserInfoModel setUserDefaultDeviceMacAddr:@""];
                [UserInfoModel setUserDefaultDeviceIdentifier:@""];
            }];
        }
    }
    
}


- (void)logout:(NSNotification *)notification
{
    [YSBLEManager sharedInstance].macAdd = nil;
    
    _macLB.text = [self macString:LocalizedStr(unconnec_device)];
}


@end
