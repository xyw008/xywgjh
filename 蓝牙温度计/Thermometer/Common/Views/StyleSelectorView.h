//
//  StyleSelectorView.h
//  kkpoem
//
//  Created by 龚俊慧 on 15/9/2.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StyleSelectorViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface StyleSelectorView : UIView

- (instancetype)initWithFrame:(CGRect)frame
              registerNibName:(NSString *)nibName;

@property (nonatomic, copy) NSString *registerNibName;  // 必须设置(需为UICollectionViewCell及其子类)
@property (nonatomic, weak) id<StyleSelectorViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentItemIndex;

@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection; // default is UICollectionViewScrollDirectionVertical

@property (nonatomic, copy) void (^itemStyleHandle) (UICollectionViewCell *item);

- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSArray *)visibleItemViews;
- (void)reloadData;

@end

////////////////////////////////////////////////////////////////////////////////

@protocol StyleSelectorViewDelegate <NSObject>

@required
- (NSInteger)numberOfItemsInStyleSelectorView:(StyleSelectorView *)selectorView;
- (CGSize)sizeForItemInStyleSelectorView:(StyleSelectorView *)selectorView;
- (void)styleSelectorView:(StyleSelectorView *)selectorView itemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@optional
- (void)styleSelectorView:(StyleSelectorView *)selectorView didSelectItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
