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

@end

@implementation LawyerCell

- (void)awakeFromNib
{
    for (UIView *btn in self.contentView.subviews)
    {
        if ([btn isKindOfClass:[FUIButton class]])
        {
            FUIButton *theBtn = (FUIButton *)btn;
            theBtn.buttonColor = HEXCOLOR(0xEAE6E2);
            theBtn.highlightedColor = HEXCOLOR(0x3FA6AC);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)showmap:(id)sender {
    
 [self sendSignal:[QSignal signalWithName:SignalCellShowMap userInfo:@{@"cellindexPath": self.cellindexPath}]];
}

- (IBAction)consult:(id)sender {
    
   [self sendSignal:[QSignal signalWithName:SignalCellConSult userInfo:@{@"cellindexPath": self.cellindexPath}]];

}

- (IBAction)call:(id)sender {
    [self sendSignal:[QSignal signalWithName:SignalCellCall userInfo:@{@"cellindexPath": self.cellindexPath}]];

}

- (IBAction)btnSendSms:(id)sender {

    [self sendSignal:[QSignal signalWithName:SignalCellSendSms userInfo:@{@"cellindexPath": self.cellindexPath}]];
}


@end
