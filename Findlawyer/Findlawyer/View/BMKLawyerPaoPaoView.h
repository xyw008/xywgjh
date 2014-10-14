//
//  BMKLawyerPaoPaoView.h
//  Find lawyer
//
//  Created by swift on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSLawyer.h"

@interface BMKLawyerPaoPaoView : UIView

/// 律师图像
@property (nonatomic, weak) IBOutlet UIImageView *lawyerHeaderImageView;

/// 律师名字
@property (nonatomic, weak) IBOutlet UILabel *lawyerNameLabel;

/// 律所名字
@property (nonatomic, weak) IBOutlet UILabel *lawfirmNameLabel;

/// 证件号
@property (nonatomic, weak) IBOutlet UILabel *certificateNoLabel;

/// 擅长领域
@property (nonatomic, weak) IBOutlet UILabel *specialAreaLabel;

/// 距离
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

/// 加载数据
- (void)loadViewData:(LBSLawyer *)lawyerEntity;

@end
