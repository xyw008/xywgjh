//
//  DetailLawyerViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-22.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BaseViewController.h"
#import "ToolView.h"
@class LBSLawyer;

@interface DetailLawyerViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,ToolViewDelegate>


@property (nonatomic, strong)UIScrollView *myScrollView;// 用来添加各种界面后可以滚动
@property (nonatomic, strong)UITableView *tableView;

//@property (nonatomic,strong)UIView * bgSegmentcontrol;
@property (strong,nonatomic)UISegmentedControl * segmentcontrol; // 用来显示文章类型列表
@property (strong,nonatomic)LBSLawyer *lawyer;//律师数据

@property (nonatomic, assign)BOOL   showConsultBtn;//判断是显示电话和咨询的toolView 还是单独显示向TA咨询

@end
