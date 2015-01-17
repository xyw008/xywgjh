//
//  SearchCollectionHeaderView.m
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "SearchCollectionHeaderView.h"

@interface SearchCollectionHeaderView ()

@end

@implementation SearchCollectionHeaderView

static CGSize defaultCellSize = {0,0};

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
    self.backgroundColor = PageBackgroundColor;
    [self addLineWithPosition:ViewDrawLinePostionType_Top
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    [self addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _titleLabel.textColor = Common_BlackColor;
    
    [_selectorBtn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
    [_selectorBtn setImage:[UIImage imageNamed:@"gouXuan"] forState:UIControlStateNormal];
    [_selectorBtn setImage:[UIImage imageNamed:@"gouXuan_Selected"] forState:UIControlStateSelected];
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

+ (CGSize)getViewSize
{
    if (CGSizeEqualToSize(defaultCellSize, CGSizeMake(0, 0)))
    {
        CGFloat width = IPHONE_WIDTH;
        defaultCellSize = CGSizeMake(width, 30);
    }
    
    return defaultCellSize;
}

@end
