//
//  SetupVC.m
//  Thermometer
//
//  Created by leo on 15/11/22.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "SetupVC.h"
#import "YSBLEManager.h"

@interface SetupVC ()
{
    UILabel     *_macLB;
}
@end

@implementation SetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    [self setNavigationItemTitle:@"设置"];
    
    CGFloat margin = 15;
    NSString *macAdd = [YSBLEManager sharedInstance].macAdd;
    
    _macLB = [[UILabel alloc] initWithFrame:CGRectMake(margin, 20, IPHONE_WIDTH - margin * 2, 40)];
    ViewRadius(_macLB, 5);
    _macLB.font = SP16Font;
    _macLB.backgroundColor = [UIColor whiteColor];
    _macLB.textColor = Common_BlackColor;
    _macLB.text = [macAdd isAbsoluteValid] ? [self macString:macAdd] : [self macString:@"还未连接设备"];
    [self.view addSubview:_macLB];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(margin, CGRectGetMaxY(_macLB.frame) + 35, _macLB.width, 40);
    logoutBtn.backgroundColor = Common_GreenColor;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font = SP16Font;
    ViewRadius(logoutBtn, 5);
    [self.view addSubview:logoutBtn];
    
}

- (NSString *)macString:(NSString*)string
{
    return [NSString stringWithFormat:@"   MAC地址           %@",string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)logoutBtnTouch:(UIButton*)btn
{
    
}


@end
