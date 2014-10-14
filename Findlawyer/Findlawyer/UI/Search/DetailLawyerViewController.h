//
//  DetailLawyerViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-22.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "FLBaseViewController.h"
#import "ToolView.h"
@class LBSLawyer;

@interface DetailLawyerViewController : FLBaseViewController <UITableViewDataSource,UITableViewDelegate,ToolViewDelegate>


@property (nonatomic, strong)UIScrollView *myScrollView;// 用来添加各种界面后可以滚动
@property (nonatomic, strong)UITableView *tableView;

//@property (nonatomic,strong)UIView * bgSegmentcontrol;
@property (strong,nonatomic)UISegmentedControl * segmentcontrol; // 用来显示文章类型列表
@property (strong,nonatomic)LBSLawyer *lawyer;//律师数据


@end
