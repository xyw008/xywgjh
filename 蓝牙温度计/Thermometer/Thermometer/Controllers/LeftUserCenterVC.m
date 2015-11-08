//
//  LeftUserCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/5.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "LeftUserCenterVC.h"

@interface LeftUserCenterVC ()

@end

@implementation LeftUserCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgIV.image = [UIImage imageNamed:@"leftmenu_bg"];
    [self.view addSubview:bgIV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
