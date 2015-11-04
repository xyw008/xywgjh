//
//  PushTreeTableView.h
//  InfiniteTreeView
//
//  Created by 龚 俊慧 on 14-7-24.
//  Copyright (c) 2014年 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ITTAdditions.h"
#import "PushTreeArrowView.h"

//#define ArrowSizeWidth      10
//#define ArrowSizeHeight     18

@interface PushTreeTableView : UITableView

@property (nonatomic, assign) NSInteger         level;
@property (nonatomic, assign) CGFloat           arrowCenterY;    // 画箭头的区域,箭头的中点
@property (nonatomic, assign) CGFloat           arrowCenterX;    // 画箭头的区域,箭头的X点

@property (nonatomic, strong) PushTreeArrowView *arrowView;

@end
