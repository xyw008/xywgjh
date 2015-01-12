//
//  TableViewCell.m
//  Find lawyer
//
//  Created by 龚 俊慧 on 15/1/10.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "HomePageNewsCell.h"

@interface HomePageNewsCell ()

@end

@implementation HomePageNewsCell

static CGFloat defaultCellHeight = 0;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight
{
    if (0 == defaultCellHeight)
    {
        HomePageNewsCell *cell = [self loadFromNib];
        defaultCellHeight = cell.boundsHeight;
    }
    return defaultCellHeight;
}

@end
