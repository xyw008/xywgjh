//
//  DetailLawfirmViewController.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-21.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BaseTableViewController.h"

@class LBSLawfirm;
@interface DetailLawfirmViewController : BaseTableViewController
@property (nonatomic) NSInteger lawfirmid;//律所ID
@property (strong,nonatomic)LBSLawfirm * lawfirm;  // 律所数据

@end
