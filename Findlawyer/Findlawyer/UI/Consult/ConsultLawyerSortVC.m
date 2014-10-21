//
//  ConsultLawyerSortVC.m
//  Find lawyer
//
//  Created by leo on 14-10-21.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ConsultLawyerSortVC.h"
#import "SearchSortView.h"
#import "SearchLawyerViewController.h"

#define kSortBetweenSpace 10

@interface ConsultLawyerSortVC ()
{
    SearchSortView              *_specialtySortView;//擅长分类
}
@end

@implementation ConsultLawyerSortVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ATColorRGBMake(223, 223, 223);
    [self initSpecialtySortView];
    [self setNavigationItemTitle:@"我要咨询"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSpecialtySortView
{
    _specialtySortView = [[SearchSortView alloc] initWithFrame:CGRectMake(kSortBetweenSpace, 4,self.view.width - kSortBetweenSpace*2, 10) title:@"擅长领域" sortNameArray:kSpecialtyDomainArray];
    _specialtySortView.delegate = self;
    [self.view addSubview:_specialtySortView];
}


#pragma mark - SearchSortView delegate
- (void)SearchSortView:(SearchSortView*)view didTouchIndex:(NSInteger)index didBtnTitle:(NSString*)title
{
    SearchLawyerViewController *vc = [[SearchLawyerViewController alloc] init];
    vc.strTitle = @"附近律师";
    vc.searchKey = title;
    vc.isShowMapView = YES;
    vc.isHiddenSearchKey = YES;
    vc.fromConsultVC = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
