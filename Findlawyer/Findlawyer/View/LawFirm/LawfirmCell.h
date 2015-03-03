//
//  LawfirmCell.h
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSLawfirm.h"

typedef NS_ENUM(NSInteger, LawFirmCellOperationType)
{
    /// 地图定位跳转
    LawFirmCellOperationType_MapLocation = 0,
    /// 网址
    LawFirmCellOperationType_OpenUrl,
    /// 电话
    LawFirmCellOperationType_PhoneCall
};

@protocol LawFirmCellDelegate;

@interface LawfirmCell : UITableViewCell

@property (nonatomic, assign) id<LawFirmCellDelegate>       delegate;

@property (weak, nonatomic) IBOutlet UIButton *btnNerAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbMembercount;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgIntroduct;
@property (strong, nonatomic) NSIndexPath *cellindexPath;
@property (strong, nonatomic) UIView *lineView;

- (IBAction)showmap:(id)sender;
- (IBAction)openUrl:(id)sender;
- (IBAction)call:(id)sender;

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(LBSLawfirm *)entity;

@end

@protocol LawFirmCellDelegate <NSObject>

- (void)LawFirmCell:(LawfirmCell *)cell didClickOperationBtnWithType:(LawFirmCellOperationType)type sender:(id)sender;

@end
