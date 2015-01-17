//
//  SearchCollectionFooterView.m
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "SearchCollectionFooterView.h"

@implementation SearchCollectionFooterView

static CGSize defaultCellSize = {0,0};

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - custom methods

- (void)configureViewsProperties
{
//    self.backgroundColor = PageBackgroundColor;
    [self addLineWithPosition:ViewDrawLinePostionType_Top
                    lineColor:CellSeparatorColor
                    lineWidth:LineWidth];
    
    _searchBtn.backgroundColor = Common_ThemeColor;
    [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_searchBtn setRadius:5];
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

////////////////////////////////////////////////////////////////////////////////

+ (CGSize)getViewSize
{
    if (CGSizeEqualToSize(defaultCellSize, CGSizeMake(0, 0)))
    {
        CGFloat width = IPHONE_WIDTH;
        defaultCellSize = CGSizeMake(width, 60);
    }
    
    return defaultCellSize;
}

@end
