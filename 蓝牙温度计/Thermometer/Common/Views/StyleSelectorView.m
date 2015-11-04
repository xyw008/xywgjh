//
//  StyleSelectorView.m
//  kkpoem
//
//  Created by 龚俊慧 on 15/9/2.
//  Copyright (c) 2015年 KungJack. All rights reserved.
//

#import "StyleSelectorView.h"

static NSString * const StyleSelectorViewCollectionCellIdentifier = @"StyleSelectorViewCollectionCellIdentifier";

@interface StyleSelectorView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@end

@implementation StyleSelectorView

- (instancetype)initWithFrame:(CGRect)frame registerNibName:(NSString *)nibName
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.registerNibName = nibName;
        
        [self initialization];
    }
    return self;
}

/*
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialization];
}
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    _currentItemIndex = 0;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    // layout.itemSize = [StyleSelectorItemView getViewSize];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    if ([_registerNibName isAbsoluteValid])
    {
        [_collectionView registerNib:[UINib nibWithNibName:_registerNibName bundle:nil]
          forCellWithReuseIdentifier:StyleSelectorViewCollectionCellIdentifier];
    }
    [_collectionView keepAutoresizingInFull];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_collectionView];
}

- (void)setRegisterNibName:(NSString *)registerNibName
{
    _registerNibName = registerNibName;
    
    if ([_registerNibName isAbsoluteValid])
    {
        [_collectionView registerNib:[UINib nibWithNibName:_registerNibName bundle:nil]
          forCellWithReuseIdentifier:StyleSelectorViewCollectionCellIdentifier];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    _sectionInset = sectionInset;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.sectionInset = _sectionInset;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    _minimumLineSpacing = minimumLineSpacing;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumLineSpacing = _minimumLineSpacing;
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    _minimumInteritemSpacing = minimumInteritemSpacing;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = _minimumInteritemSpacing;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.scrollDirection = _scrollDirection;
}

- (UIView *)itemViewAtIndex:(NSInteger)index
{
    return [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (NSArray *)visibleItemViews
{
    return [_collectionView visibleCells];
}

- (void)reloadData
{
    [_collectionView reloadData];
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(numberOfItemsInStyleSelectorView:)])
    {
        return [_delegate numberOfItemsInStyleSelectorView:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:StyleSelectorViewCollectionCellIdentifier forIndexPath:indexPath];
    
    if (_itemStyleHandle) _itemStyleHandle(cell);
    
    if ([_delegate respondsToSelector:@selector(styleSelectorView:itemAtIndex:reusingView:)])
    {
        [_delegate styleSelectorView:self itemAtIndex:indexPath.item reusingView:cell];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(sizeForItemInStyleSelectorView:)])
    {
        return [_delegate sizeForItemInStyleSelectorView:self];
    }
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    self.currentItemIndex = indexPath.item;
    
    if ([_delegate respondsToSelector:@selector(styleSelectorView:didSelectItemAtIndex:)])
    {
        [_delegate styleSelectorView:self didSelectItemAtIndex:indexPath.item];
    }
}

@end
