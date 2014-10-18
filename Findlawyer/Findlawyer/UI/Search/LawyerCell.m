//
//  LawyerCell.m
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "LawyerCell.h"
#import "QSignalManager.h"

@interface LawyerCell ()

@property (weak, nonatomic) IBOutlet FUIButton *consultBtn;
@property (weak, nonatomic) IBOutlet FUIButton *callBtn;
@property (weak, nonatomic) IBOutlet FUIButton *messageBtn;

@property (weak, nonatomic) IBOutlet UILabel *lbSpecialAreaOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialAreaTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialAreaThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialAreaMoreLabel;

@end

@implementation LawyerCell

- (void)awakeFromNib
{
    for (UIView *view in self.contentView.subviews)
    {
        if ([view isKindOfClass:[FUIButton class]])
        {
            FUIButton *theBtn = (FUIButton *)view;
            theBtn.buttonColor = HEXCOLOR(0xEAE6E2);
            theBtn.highlightedColor = HEXCOLOR(0x3FA6AC);
        }
        else if ([view isKindOfClass:[UILabel class]] && view.tag >= 1000)
        {
            view.userInteractionEnabled = YES;
            [view addTarget:self action:@selector(clickSpecialAreaLabel:)];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSpecialAreaStr:(NSString *)specialAreaStr
{
    _specialAreaStr = specialAreaStr;
    
    _lbSpecialAreaOneLabel.text = nil;
    _lbSpecialAreaTwoLabel.text = nil;
    _lbSpecialAreaThreeLabel.text = nil;
    _lbSpecialAreaMoreLabel.text = nil;
    
    NSArray *specialAreaStrsArray = [_specialAreaStr componentsSeparatedByString:@","];
    
    for (NSString *oneSpecialArea in specialAreaStrsArray)
    {
        int index = [specialAreaStrsArray indexOfObject:oneSpecialArea];
        
        switch (index)
        {
            case 0:
            {
                _lbSpecialAreaOneLabel.text = oneSpecialArea;
            }
                break;
            case 1:
            {
                _lbSpecialAreaTwoLabel.text = oneSpecialArea;
            }
                break;
            case 2:
            {
                _lbSpecialAreaThreeLabel.text = oneSpecialArea;
            }
                break;
            case 3:
            {
                _lbSpecialAreaMoreLabel.text = @"更多";
                
                return;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)operationDelegateMethodWithOperationBtnType:(LawyerCellOperationType)type sender:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(LawyerCell:didClickOperationBtnWithType:sender:)])
    {
        [self.delegate LawyerCell:self didClickOperationBtnWithType:type sender:sender];
    }
}

- (void)clickSpecialAreaLabel:(UIGestureRecognizer *)gesture
{
    UILabel *label = (UILabel *)gesture.view;
    
    if ([label.text isAbsoluteValid])
    {
        [self operationDelegateMethodWithOperationBtnType:LawyerCellOperationType_SpecialAreaSearch sender:label];
    }
}

- (IBAction)showmap:(id)sender
{
    [self operationDelegateMethodWithOperationBtnType:LawyerCellOperationType_MapLocation sender:sender];
//    [self sendSignal:[QSignal signalWithName:SignalCellShowMap userInfo:@{@"cellindexPath": self.cellindexPath}]];
}

- (IBAction)consult:(id)sender
{
    [self operationDelegateMethodWithOperationBtnType:LawyerCellOperationType_Consult sender:sender];
//    [self sendSignal:[QSignal signalWithName:SignalCellConSult userInfo:@{@"cellindexPath": self.cellindexPath}]];
}

- (IBAction)call:(id)sender
{
    [self operationDelegateMethodWithOperationBtnType:LawyerCellOperationType_PhoneCall sender:sender];
//    [self sendSignal:[QSignal signalWithName:SignalCellCall userInfo:@{@"cellindexPath": self.cellindexPath}]];
}

- (IBAction)btnSendSms:(id)sender
{
    [self operationDelegateMethodWithOperationBtnType:LawyerCellOperationType_SendMessage sender:sender];
//    [self sendSignal:[QSignal signalWithName:SignalCellSendSms userInfo:@{@"cellindexPath": self.cellindexPath}]];
}


@end
