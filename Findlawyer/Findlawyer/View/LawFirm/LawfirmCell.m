//
//  LawfirmCell.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "LawfirmCell.h"
#import "QSignalManager.h"

@implementation LawfirmCell

static CGFloat defaultCellHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
   [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                   lineColor:CellSeparatorColor
                   lineWidth:LineWidth];
    
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *theBtn = (UIButton *)view;
            
            [theBtn setTitleColor:Common_GrayColor forState:UIControlStateNormal];
        }
        else if ([view isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)view;
            
            label.textColor = Common_GrayColor;
        }
    }
    
    _lbName.textColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showmap:(id)sender
{
    // [self sendSignal:[QSignal signalWithName:SignalCellShowMap userInfo:@{@"cellindexPath": self.cellindexPath}]];
    
    [self operationDelegateMethodWithOperationBtnType:LawFirmCellOperationType_MapLocation sender:sender];
}

- (IBAction)openUrl:(id)sender
{
   // [self sendSignal:[QSignal signalWithName:SignalCellopenUrl userInfo:@{@"cellindexPath": self.cellindexPath}]];
    
    [self operationDelegateMethodWithOperationBtnType:LawFirmCellOperationType_OpenUrl sender:sender];
}

- (IBAction)call:(id)sender
{
   // [self sendSignal:[QSignal signalWithName:SignalCellCall userInfo:@{@"cellindexPath": self.cellindexPath}]];
    
    [self operationDelegateMethodWithOperationBtnType:LawFirmCellOperationType_PhoneCall sender:sender];
}

- (void)operationDelegateMethodWithOperationBtnType:(LawFirmCellOperationType)type sender:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(LawFirmCell:didClickOperationBtnWithType:sender:)])
    {
        [_delegate LawFirmCell:self didClickOperationBtnWithType:type sender:sender];
    }
}

//////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        LawfirmCell *cell = [self loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

- (void)loadCellShowDataWithItemEntity:(LBSLawfirm *)entity
{
    [self.imgIntroduct setImageWithURL:entity.mainImageURL placeholderImage:[UIImage imageNamed:@"defualtLawfirm"]];
    
    self.lbName.text = entity.name;
    self.lbMembercount.text = [NSString stringWithFormat:@"%@",entity.memberCount];
    self.lbAddress.text = entity.address;
    
    /*
    self.lbCertificate.text = entity.certificateNo;
    self.lbPhone.text = entity.mobile ? entity.mobile : @"暂无电话";
    
    [_distanceBtn setTitle:[NSString stringWithFormat:@"%.0lf米", entity.distance] forState:UIControlStateNormal];
     */
}

@end
