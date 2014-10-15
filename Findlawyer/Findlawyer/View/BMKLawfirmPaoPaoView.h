//
//  BMKLawfirmPaoPaoView.h
//  Find lawyfirm
//
//  Created by leo on 14-10-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSLawfirm.h"

@interface BMKLawfirmPaoPaoView : UIView

/// 律师图像
@property (nonatomic, weak) IBOutlet UIImageView *lawyfirmHeaderImageView;

/// 距离
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;

/// 律所名字
@property (nonatomic, weak) IBOutlet UILabel *lawfirmNameLabel;

/// 律所地址
@property (nonatomic, weak) IBOutlet UILabel *lawfirmAddressLabel;

/// 律所人数
@property (nonatomic, weak) IBOutlet UILabel *lawyerNumLabel;



/// 加载数据
- (void)loadViewData:(LBSLawfirm *)lawfirmEntity;


@end
