//
//  GridView.h
//  KKDictionary
//
//  Created by 龚俊慧 on 15/10/10.
//  Copyright © 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface GridView : UIView

- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
               registerNibName:(NSString *)nibName
                      delegate:(id<GridViewDelegate>)delegate;

@property (nonatomic, copy) NSString *registerNibName;    // 必须设置(需为UICollectionViewCell及其子类)
@property (nonatomic, weak) id<GridViewDelegate> delegate;

@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat minimumLineSpacing;

@property (nonatomic, strong) UIColor *horizontalSeparatorColor;
@property (nonatomic, assign) UIEdgeInsets horizontalSeparatorInset;
@property (nonatomic, strong) UIColor *verticalSeparatorColor;
@property (nonatomic, assign) UIEdgeInsets verticalSeparatorInset;

@property (nonatomic, copy) void (^itemStyleHandle) (UICollectionViewCell *item);

/// 重置高度&刷新界面
- (void)resizeSelfFrameHeightAndReloadData;

- (nullable UIView *)itemViewAtIndex:(NSInteger)index;
- (nullable NSArray *)visibleItemViews;
- (void)reloadData;

@end

////////////////////////////////////////////////////////////////////////////////

@protocol GridViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInGridView:(GridView *)gridView;      // 总个数
- (NSInteger)columnCountOfRowInGridView:(GridView *)gridView;   // 一行的列数
- (CGSize)sizeForItemInGridView:(GridView *)gridView;
- (void)girdView:(GridView *)gridView itemAtIndex:(NSInteger)index itemView:(UIView *)view;

@optional
- (void)gridView:(GridView *)gridView didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END