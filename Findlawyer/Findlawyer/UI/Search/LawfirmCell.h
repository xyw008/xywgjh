//
//  LawfirmCell.h
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawfirmCell : UITableViewCell

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

@end
