//
//  LawyerCell.h
//  Find lawyer
//
//  Created by macmini01 on 14-7-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawyerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIntroduct;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lblawfirm;
@property (weak, nonatomic) IBOutlet UILabel *lbCertificate;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialArea;
@property (strong, nonatomic) NSIndexPath *cellindexPath;

- (IBAction)showmap:(id)sender;
- (IBAction)consult:(id)sender;
- (IBAction)call:(id)sender;
- (IBAction)btnSendSms:(id)sender;

@end
