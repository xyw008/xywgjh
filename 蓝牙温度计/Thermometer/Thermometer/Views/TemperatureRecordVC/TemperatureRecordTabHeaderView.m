//
//  TemperatureRecordTabHeaderView.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/15.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "TemperatureRecordTabHeaderView.h"

@interface TemperatureRecordTabHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TemperatureRecordTabHeaderView

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(0, 0, IPHONE_WIDTH, kGetScaleValueBaseIP6(195));
    self.headerImage = [UIImage imageWithColor:Common_ThemeColor];
    // self.headerImage = [UIImage imageNamed:@"FriendsBackground"];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    _dateLabel.text = [NSDate stringFromDate:[NSDate date] withFormatter:DataFormatter_Date];
}

//////////////////////////////////////////////////////////////////////

- (IBAction)clickDatePreBtn:(UIButton *)sender {
    NSDate *date = [NSString dateFromString:_dateLabel.text withFormatter:DataFormatter_Date];
    date = [date dateBySubtractingDays:1];
    _dateLabel.text = [NSDate stringFromDate:date withFormatter:DataFormatter_Date];
    
    if (_operationHandle) _operationHandle(self, HeaderViewOperationType_DatePre,date);
}

- (IBAction)clickDateNextBtn:(UIButton *)sender {
    NSDate *date = [NSString dateFromString:_dateLabel.text withFormatter:DataFormatter_Date];
    date = [date dateByAddingDays:1];
    _dateLabel.text = [NSDate stringFromDate:date withFormatter:DataFormatter_Date];
    
    if (_operationHandle) _operationHandle(self, HeaderViewOperationType_DateNext,date);
}

@end
