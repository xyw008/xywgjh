//
//  ProductCategoryCell.m
//  o2o
//
//  Created by swift on 14-8-6.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "ProductCategoryCell.h"

@interface ProductCategoryCell ()

@end

@implementation ProductCategoryCell

- (void)awakeFromNib
{
    // Initialization code
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

- (void)setup
{
    _cellTextLabel.textColor = Common_InkBlackColor;
    _cellTextLabel.highlightedTextColor = Common_LiteBlueColor;
    _cellDetailTextLabel.textColor = Common_InkGreenColor;
    
    _cellTextLabel.font = SP16Font;
    _cellDetailTextLabel.font = SP12Font;
    
    self.backgroundColor = [UIColor clearColor];
}

@end
