//
//  ConsultInfoVC.h
//  Find lawyer
//
//  Created by leo on 14-10-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  咨询详细信息上传

#import "BaseViewController.h"
#import "BaseNetworkViewController.h"
#import "LBSLawyer.h"

@interface ConsultInfoVC : BaseNetworkViewController

@property (nonatomic,strong)LBSLawyer       *lawyerItem;

@end
