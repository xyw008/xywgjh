//
//  BaseSearchController.h
//  o2o
//
//  Created by leo on 14-8-12.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//


#import "BaseNetworkViewController.h"
#import "SearchHistoryAndSuggestView.h"

@class NITextField;
@interface BaseSearchController : BaseNetworkViewController
{
    NITextField                     *_searchTF;//顶部搜索栏
    SearchHistoryAndSuggestView     *_historyAndSuggestView;//搜索历史页面
    NSString                        *_lastSearchStr;//上一个搜索字符串
    UIButton                        *_cancelSearchBtn;//取消搜索按钮
}

@end
