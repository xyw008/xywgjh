//
//  SearchItemCollectionCell.m
//  Find lawyer
//
//  Created by 龚 俊慧 on 15/1/14.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "SearchItemCollectionCell.h"

@interface SearchItemCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SearchItemCollectionCell

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
//    UIView *background = [[UIView alloc] init];
//    background.backgroundColor = [UIColor whiteColor];
//    self.backgroundView = background;
//    
//    UIView *selectedBackground = [[UIView alloc] init];
//    selectedBackground.backgroundColor = Common_ThemeColor;
//    self.selectedBackgroundView = selectedBackground;
    
    _titleLabel.textColor = Common_BlackColor;
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    
    
    
//    [_titleBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
//    [_titleBtn setBackgroundImage:[UIImage imageWithColor:Common_ThemeColor size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _titleLabel.backgroundColor = selected ? Common_ThemeColor : [UIColor whiteColor];
}

@end
