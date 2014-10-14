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

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showmap:(id)sender {
    
    [self sendSignal:[QSignal signalWithName:SignalCellShowMap userInfo:@{@"cellindexPath": self.cellindexPath}]];
}

- (IBAction)openUrl:(id)sender {
    
   [self sendSignal:[QSignal signalWithName:SignalCellopenUrl userInfo:@{@"cellindexPath": self.cellindexPath}]];

}
- (IBAction)call:(id)sender {
    
   [self sendSignal:[QSignal signalWithName:SignalCellCall userInfo:@{@"cellindexPath": self.cellindexPath}]];
    
}

- (void)dealloc
{

}

@end
