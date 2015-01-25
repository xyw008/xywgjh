//
//  MyMagicCell.h
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMagicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (CGFloat)getCellHeight;

- (void)setBadgeOneValue:(NSString *)value;
- (void)setBadgeTwoValue:(NSString *)value;

@end
