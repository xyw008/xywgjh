//
//  SearchSortView.h
//  Find lawyer
//
//  Created by leo on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  法院周边分类、擅长领域分类

#import <UIKit/UIKit.h>

@class SearchSortView;

@protocol SearchSortViewDelegate <NSObject>

/**
 *  btn 点击触发
 *
 *  @param view  self
 *  @param index index
 */
- (void)SearchSortView:(SearchSortView*)view didTouchIndex:(NSInteger)index;

@end


@interface SearchSortView : UIView
{
    __weak id<SearchSortViewDelegate>       _delegate;
}
@property (nonatomic,weak)id                delegate;

/**
 *  初始化视图
 *
 *  @param frame frame
 *  @param title 标题
 *  @param array 类型名字数组
 *
 *  @return id
 */
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title sortNameArray:(NSArray*)array;

@end
