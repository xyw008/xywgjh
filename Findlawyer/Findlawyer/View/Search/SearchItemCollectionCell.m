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

static CGSize defaultCellSize = {0,0};

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *background = [[UIView alloc] init];
    background.backgroundColor = [UIColor whiteColor];
    self.backgroundView = background;
    
    UIView *selectedBackground = [[UIView alloc] init];
    selectedBackground.backgroundColor = Common_ThemeColor;
    self.selectedBackgroundView = selectedBackground;
    
    [self setRadius:self.boundsHeight / 2];
    
    _titleLabel.textColor = Common_BlackColor;
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)setTitleStr:(NSString *)title
{
    _titleLabel.text = title;
}

////////////////////////////////////////////////////////////////////////////////

+ (CGSize)getCellSize
{
    if (CGSizeEqualToSize(defaultCellSize, CGSizeMake(0, 0)))
    {
        CGFloat width = (IPHONE_WIDTH - 10 * 4) / 3;
        defaultCellSize = CGSizeMake(width, 30);
    }
    
    return defaultCellSize;
}

@end
