//
//  MyMagicCell.m
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "MyMagicCell.h"

@interface MyMagicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *theImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
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
    self.accessoryView = nil;
    
    _titleLabel.textColor = Common_BlackColor;
    
    _badgeLabelTwo.textColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
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
