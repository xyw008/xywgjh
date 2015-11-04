//
//  GridView.m
//  KKDictionary
//
//  Created by 龚俊慧 on 15/10/10.
//  Copyright © 2015年 YY. All rights reserved.
//

#import "GridView.h"

static NSString * const GridViewCollectionCellIdentifier = @"GridViewCollectionCellIdentifier";

@interface GridView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
}

@end

@implementation GridView

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width registerNibName:(NSString *)nibName delegate:(id<GridViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, 0)];
    if (self)
    {
        self.registerNibName = nibName;
        self.delegate = delegate;
        
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
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    if ([_registerNibName isAbsoluteValid])
    {
        [_collectionView registerNib:[UINib nibWithNibName:_registerNibName bundle:nil]
          forCellWithReuseIdentifier:GridViewCollectionCellIdentifier];
    }
    [_collectionView keepAutoresizingInFull];
    
    self.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.minimumLineSpacing = 20;
    
    [self addSubview:_collectionView];
}

- (void)setRegisterNibName:(NSString *)registerNibName
{
    _registerNibName = registerNibName;
    
    if ([_registerNibName isAbsoluteValid])
    {
        [_collectionView registerNib:[UINib nibWithNibName:_registerNibName bundle:nil]
          forCellWithReuseIdentifier:GridViewCollectionCellIdentifier];
    }
}

// 重置高度&刷新界面
- (void)resizeSelfFrameHeightAndReloadData
{
    CGSize itemSize = [_delegate sizeForItemInGridView:self];
    NSInteger numberOfItem = [_delegate numberOfItemsInGridView:self];
    NSInteger columnCountOfRow = [_delegate columnCountOfRowInGridView:self];
    
    NSInteger rowCount = (numberOfItem / columnCountOfRow) + (numberOfItem % columnCountOfRow == 0 ? 0 : 1);
    
    CGFloat height = _sectionInset.top + _sectionInset.bottom + itemSize.height * rowCount + _minimumLineSpacing * (rowCount - 1);
    
    self.frameHeight = height;
    _collectionView.frameHeight = height;
    
    [self reloadData];
    [self drawSeparator];
}

// 设置分割线
- (void)drawSeparator
{
    for (UIView *lineView in _collectionView.subviews) {
        if ([lineView isKindOfClass:[UIView class]] && lineView.tag >= 8888)
        {
            [lineView removeFromSuperview];
        }
    }
    
    NSInteger itemCount = [_delegate numberOfItemsInGridView:self];
    NSInteger columnCount = [_delegate columnCountOfRowInGridView:self];
    NSInteger rowCount = itemCount / columnCount + ((itemCount % columnCount == 0) ? 0 : 1);
    
    CGSize itemSize = [_delegate sizeForItemInGridView:self];
    
    CGFloat lineWidth = ThinLineWidth;
    // 横向
    if (_horizontalSeparatorColor) {
        for (int i = 1; i < rowCount; ++i) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_horizontalSeparatorInset.left, _sectionInset.top + _minimumLineSpacing / 2 + itemSize.height * i + _minimumLineSpacing * (i - 1), self.frameWidth - _horizontalSeparatorInset.left - _horizontalSeparatorInset.right, lineWidth)];
            lineView.backgroundColor = _horizontalSeparatorColor;
            lineView.tag = 8888 + i * columnCount;
            
            [_collectionView addSubview:lineView];
        }
    }
    // 纵向
    CGFloat minimumInteritemSpacing = [self getMinimumInteritemSpacing];
    if (_verticalSeparatorColor) {
        for (int i = 0; i < rowCount; ++i) {
            for (int j = 1; j < columnCount; ++j) {
                NSInteger index = i * columnCount + j;
                
                if (index <= itemCount - 1)
                {
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_sectionInset.left + minimumInteritemSpacing / 2 + itemSize.width * j + minimumInteritemSpacing * (j - 1), _verticalSeparatorInset.top + _sectionInset.top + (itemSize.height + _minimumLineSpacing) * i, lineWidth, itemSize.height - _verticalSeparatorInset.top - _verticalSeparatorInset.bottom)];
                    lineView.backgroundColor = _verticalSeparatorColor;
                    lineView.tag = 8888 + i * columnCount + j;
                    
                    [_collectionView addSubview:lineView];
                }
            }
        }
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

- (CGFloat)getMinimumInteritemSpacing
{
    NSInteger columnCount = [_delegate columnCountOfRowInGridView:self];
    CGSize itemSize = [_delegate sizeForItemInGridView:self];
    
    return floorf((_collectionView.frameWidth - _sectionInset.left - _sectionInset.right - itemSize.width * columnCount) / (columnCount - 1));
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_delegate respondsToSelector:@selector(numberOfItemsInGridView:)])
    {
        return [_delegate numberOfItemsInGridView:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridViewCollectionCellIdentifier forIndexPath:indexPath];
    
    if (_itemStyleHandle) _itemStyleHandle(cell);
    
    if ([_delegate respondsToSelector:@selector(girdView:itemAtIndex:itemView:)])
    {
        [_delegate girdView:self itemAtIndex:indexPath.item itemView:cell];
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self getMinimumInteritemSpacing];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_delegate sizeForItemInGridView:self];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(gridView:didSelectItemAtIndex:)])
    {
        [_delegate gridView:self didSelectItemAtIndex:indexPath.item];
    }
}

@end
