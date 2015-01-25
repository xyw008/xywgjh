//
//  MyMagicCell.m
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "MyMagicCell.h"

@interface MyMagicCell ()

@property (weak, nonatomic) IBOutlet UILabel *badgeLabelOne;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabelTwo;

@end

@implementation MyMagicCell

static CGFloat defaultCellHeight = 0;

- (void)awakeFromNib
{
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    self.backgroundView = nil;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addLineWithPosition:ViewDrawLinePostionType_Top
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _titleLabel.textColor = Common_BlackColor;
    
    _badgeLabelOne.textColor = [UIColor whiteColor];
    [_badgeLabelOne setRadius:_badgeLabelOne.boundsHeight / 2];
    
    _badgeLabelTwo.textColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
    
    [self setBadgeOneValue:nil];
    [self setBadgeTwoValue:nil];
}

- (void)setBadgeOneValue:(NSString *)value
{
    if ([value isAbsoluteValid])
    {
        _badgeLabelOne.text = value;
        _badgeLabelOne.backgroundColor = [UIColor redColor];
        
        CGFloat strWidth = [value stringSizeWithFont:_badgeLabelOne.font].width + 8;
        
        [_badgeLabelOne mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(MAX(strWidth, _badgeLabelOne.boundsHeight)));
        }];
    }
    else
    {
        _badgeLabelOne.text = nil;
        _badgeLabelOne.backgroundColor = [UIColor clearColor];
    }
}

- (void)setBadgeTwoValue:(NSString *)value
{
    _badgeLabelTwo.text = value;
}

////////////////////////////////////////////////////////////////////////////////

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        MyMagicCell *cell = [self loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

@end
