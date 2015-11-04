//
//  SearchHistoryView.h
//  o2o
//
//  Created by leo on 14-8-19.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchHistoryAndSuggestView;

@protocol SearchHistoryAndSuggestViewDelegate <NSObject>

/**
 * 点击搜索记录触发
 * 传递参数  事件源：搜索记录字符串
 */
- (void)SearchHistoryAndSuggestView:(SearchHistoryAndSuggestView*)historyView
    didSelectHistoryOrSuggestString:(NSString*)string;

- (void)theScrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface SearchHistoryAndSuggestView : UIView
{
    __weak id<SearchHistoryAndSuggestViewDelegate>      _delegate;
}

@property (nonatomic,weak)id                            delegate;
@property (nonatomic,strong)NSArray                     *suggestResultArray;//智能联想数据


/**
 * 添加新的搜索记录
 * 传入参数  新的搜索字符串
 *
 */
- (void)addNewSearchHistoryString:(NSString*)string;

/**
 * 改变视图和里面字视图tableView 的高度 
 * 传入参数  新的搜索字符串
 *
 */
- (void)changeViewAndTableViewHeight:(CGFloat)newHeight;

// 0: 历史 1: 建议
- (void)setTabShowStyle:(NSInteger)style;

@end


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//没有搜索结果提示视图
@interface NoSearchResultView : UIView



@end



