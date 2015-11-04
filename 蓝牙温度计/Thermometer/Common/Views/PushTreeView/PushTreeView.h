//
//  PushTreeView.h
//  InfiniteTreeView
//
//  Created by 龚 俊慧 on 14-7-24.
//  Copyright (c) 2014年 Sword. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductCategoryCell.h"

@protocol PushTreeViewDataSource;
@protocol PushTreeViewDelegate;

@interface PushTreeView : UIView

@property (nonatomic, assign) id<PushTreeViewDataSource>dataSource;
@property (nonatomic, assign) id<PushTreeViewDelegate>delegate;

@property (nonatomic, assign, setter = setShouldSwipeToBack:) BOOL shouldSwipeToBack;

- (void)back;
- (void)backRoot;

- (void)reloadData;
- (NSInteger)numberOfRowsInSection:(NSInteger)section tabLevel:(NSInteger)level;
- (ProductCategoryCell *)dequeueReusableCellWithIdentifier:(NSString*)identifier tabLevel:(NSInteger)level;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated tabLevel:(NSInteger)level;
- (void)selectedAtLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath animated:(BOOL)animated;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier tabLevel:(NSInteger)level NS_AVAILABLE_IOS(6_0);

@end



@protocol PushTreeViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInLevel:(NSInteger)level;
- (NSInteger)numberOfRowsInLevel:(NSInteger)level section:(NSInteger)section;
- (ProductCategoryCell *)pushTreeView:(PushTreeView *)pushTreeView level:(NSInteger)level indexPath:(NSIndexPath*)indexPath;

@end



@protocol PushTreeViewDelegate <NSObject>

@optional
- (void)pushTreeView:(PushTreeView *)pushTreeView didSelectedLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath;
- (BOOL)pushTreeViewHasNextLevel:(PushTreeView *)pushTreeView currentLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath;
- (UIView *)pushTreeView:(PushTreeView *)pushTreeView level:(NSInteger)level viewForHeaderInSection:(NSInteger)section;
- (CGFloat)pushTreeView:(PushTreeView *)pushTreeView level:(NSInteger)level heightForHeaderInSection:(NSInteger)section;
- (CGFloat)pushTreeView:(PushTreeView *)pushTreeView level:(NSInteger)level heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)pushTreeView:(PushTreeView *)pushTreeView willPushLevel:(NSInteger)level previousIndexPath:(NSIndexPath *)indexPath;
- (void)pushTreeView:(PushTreeView *)pushTreeView didPushLevel:(NSInteger)level previousIndexPath:(NSIndexPath *)indexPath;
- (void)pushTreeView:(PushTreeView *)pushTreeView didPopLevel:(NSInteger)level;
- (void)pushTreeViewDidPopTopLevel:(PushTreeView *)pushTreeView;

@end
