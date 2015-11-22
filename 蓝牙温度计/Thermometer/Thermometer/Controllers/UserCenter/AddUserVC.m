//
//  AddUserVC.m
//  Thermometer
//
//  Created by leo on 15/11/22.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "AddUserVC.h"

@interface AddUserVC ()
{
    UIImageView     *_headIV;//头像
    UITextField     *_nameTF;
    UILabel         *_gengerLB;//性别
    UILabel         *_ageLB;
}
@end

@implementation AddUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHeadView
{
    _headIV = [[UIImageView alloc] init];
}


@end
