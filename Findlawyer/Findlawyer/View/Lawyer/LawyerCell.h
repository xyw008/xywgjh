//
//  LawyerCell.h
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"
#import "LBSLawyer.h"

typedef NS_ENUM(NSInteger, LawyerCellOperationType)
{
    /// 地图定位跳转
    LawyerCellOperationType_MapLocation = 0,
    /// 专业领域搜索
    LawyerCellOperationType_SpecialAreaSearch,
    /// 咨询
    LawyerCellOperationType_Consult,
    /// 电话
    LawyerCellOperationType_PhoneCall,
    /// 短信
    LawyerCellOperationType_SendMessage
};

@protocol LawyerCellDelegate;

@interface LawyerCell : UITableViewCell

@property (nonatomic, assign) id<LawyerCellDelegate>       delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgIntroduct;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lblawfirm;
@property (weak, nonatomic) IBOutlet UILabel *lbCertificate;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;

@property (nonatomic, copy) NSString *specialAreaStr;

@property (strong, nonatomic) NSIndexPath *cellindexPath;

- (IBAction)showmap:(id)sender;
- (IBAction)consult:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)btnSendSms:(id)sender;

+ (CGFloat)getCellHeight;
- (void)loadCellShowDataWithItemEntity:(LBSLawyer *)entity;

@end

@protocol LawyerCellDelegate <NSObject>

- (void)LawyerCell:(LawyerCell *)cell didClickOperationBtnWithType:(LawyerCellOperationType)type sender:(id)sender;

@end