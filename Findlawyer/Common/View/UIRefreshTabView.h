//
//  RefreshTabView.h
//  zmt
//
//  Created by apple on 14-2-19.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRRefreshView.h"

@interface UIRefreshTabView : UITableView

@property (nonatomic, strong) SRRefreshView *srRefreshView;

- (id)initWithFrame:(CGRect)frame tag:(int)tag dataSoure:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate srRefreshViewDelegate:(id<SRRefreshDelegate>)srRefreshViewDelegate;

@end
