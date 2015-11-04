//
//  PushTreeView.m
//  InfiniteTreeView
//
//  Created by 龚 俊慧 on 14-7-24.
//  Copyright (c) 2014年 Sword. All rights reserved.
//

#import "PushTreeView.h"
#import "PushTreeTableView.h"
#import "PushTreeLeftMenuView.h"

#define AnimationDuration                   0.25

#define CurrentTreeTableViewToLeftOffsetX   110     // 下一个tab进入视图的x坐标
#define NextTreeTableViewToMiddleOrginX     110     // 当下一个tab进入时,当前tab向前推进的距离

#define offsetOfCoverTabCellImage           -40     // 左侧栏菜单如果覆盖不到tab的image时的偏移量
#define oneTabOffset                        0       // 第一个tab的偏移量

@interface PushTreeView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    BOOL                    isAnimation;
    
    NSMutableArray          *_tableViewsStack;
    
    NSInteger               _selectedLevel;             // 当前被选择tab的level(中间那层)
    NSInteger               _currentReloadDataLevel;    // 当前被刷新数据tab的level(最右边那层)
    NSInteger               _level;                     // 当前的level,也就是最后一层tab的level
    
    PushTreeTableView       *_curTreeTableView;
    PushTreeTableView       *_nextTreeTableView;
    
    CGFloat                 oldScrollY;                 // 判断scrollView的滚动方向
    CGFloat                 oldArrowCenterY;            // 旧的箭头的中心位置
    
    PushTreeLeftMenuView    *_leftMenuView;             // 大于2层时左侧的菜单栏
}

@end

@implementation PushTreeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self collectTableViews];
        
        oldScrollY = 0;
    }
    return self;
}

#pragma mark - private methods
- (void)collectTableViews
{
    _level = 0;
    _selectedLevel = NSNotFound;
    _currentReloadDataLevel = 0;
    
    _tableViewsStack = [[NSMutableArray alloc] init];
    
    _nextTreeTableView = nil;
    _curTreeTableView = [self getNewTreeTableView];
    [_tableViewsStack addObject:_curTreeTableView];
    
    // 添加大于2层时左侧的菜单栏
    _leftMenuView = [[PushTreeLeftMenuView alloc] initWithFrame:CGRectMake(NextTreeTableViewToMiddleOrginX - PushTreeLeftMenuViewWidth, 0, PushTreeLeftMenuViewWidth, self.boundsHeight)];
    [_leftMenuView.popTopLevelBtn addTarget:self action:@selector(backRoot)];
    [_leftMenuView keepAutoresizingInFull];
    _leftMenuView.hidden = YES;
    [self addSubview:_leftMenuView];
}

- (void)setShouldSwipeToBack:(BOOL)shouldSwipeToBack
{
    _shouldSwipeToBack = shouldSwipeToBack;
    
    if (_shouldSwipeToBack)
    {
        UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
        gesture.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:gesture];
    }
}

- (PushTreeTableView *)getNewTreeTableView
{
    PushTreeTableView *tableView = [[PushTreeTableView alloc] initWithFrame:self.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.level = _level;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView keepAutoresizingInFull];
    if (0 < tableView.level)
    {
        tableView.frame = CGRectOffset(self.bounds, self.bounds.size.width, 0);
    }
    
    [self addSubview:tableView];
    
    return tableView;
}

- (PushTreeTableView *)tableViewWithLevel:(NSInteger)level
{
    PushTreeTableView *foundTableView = nil;
    for (PushTreeTableView *tableView in _tableViewsStack)
    {
        if (tableView.level == level)
        {
            foundTableView = tableView;
            break;
        }
    }
    foundTableView.dataSource = self;
    foundTableView.delegate = self;
    return foundTableView;
}

- (void)reloadData
{
    for (PushTreeTableView *pushTreeTableView in _tableViewsStack)
    {
        [pushTreeTableView reloadData];
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section tabLevel:(NSInteger)level
{
    PushTreeTableView *treeTableView = [self tableViewWithLevel:level];
    return [treeTableView numberOfRowsInSection:section];
}

- (ProductCategoryCell *)dequeueReusableCellWithIdentifier:(NSString*)identifier tabLevel:(NSInteger)level
{
    PushTreeTableView *treeTableView = [self tableViewWithLevel:level];
    return [treeTableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated tabLevel:(NSInteger)level;
{
    PushTreeTableView *treeTableView = [self tableViewWithLevel:level];
    [treeTableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)selectedAtLevel:(NSInteger)level indexPath:(NSIndexPath*)indexPath animated:(BOOL)animated
{
    PushTreeTableView *treeTableView = [self tableViewWithLevel:level];
    
    if (treeTableView.delegate && [treeTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
    {
        [treeTableView.delegate tableView:treeTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier tabLevel:(NSInteger)level
{
    PushTreeTableView *treeTableView = [self tableViewWithLevel:level];
    [treeTableView registerClass:cellClass forCellReuseIdentifier:identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    return [_dataSource numberOfSectionsInLevel:treeTableView.level];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    return [_dataSource numberOfRowsInLevel:treeTableView.level section:section];
}

- (ProductCategoryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    ProductCategoryCell *cell = [_dataSource pushTreeView:self level:treeTableView.level indexPath:indexPath];
    
    /*
    cell.textLabel.textColor = Common_InkBlackColor;
    cell.textLabel.highlightedTextColor = Common_LiteBlueColor;
    cell.detailTextLabel.textColor = Common_InkGreenColor;
    
    cell.textLabel.font = SP16Font;
    cell.detailTextLabel.font = SP12Font;
    
    cell.backgroundColor = [UIColor clearColor];
    */
    
    // 设置cell的背景图
    CGFloat cellSeparatorSpace = 10.0;
    CGFloat lineHeight = .5;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(cellSeparatorSpace, cellSize.height - lineHeight, cellSize.width - cellSeparatorSpace * 2, lineHeight)];
    separatorView.backgroundColor = CellSeparatorColor;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
    [backgroundView addSubview:separatorView];
    cell.backgroundView = backgroundView;
    
    // 非选择和已选择的背景图一定要分开创建不能共用同一个视图,不然非选择的背景图会被选择的背景图取消掉
    UIView *separatorView1 = [[UIView alloc] initWithFrame:CGRectMake(cellSeparatorSpace, cellSize.height - lineHeight, cellSize.width - cellSeparatorSpace * 2, lineHeight)];
    separatorView1.backgroundColor = CellSeparatorColor;
    
    UIView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height)];
    [selectedBackgroundView addSubview:separatorView1];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:level:heightForHeaderInSection:)])
    {
        return [_delegate pushTreeView:self level:treeTableView.level heightForHeaderInSection:section];
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:level:heightForRowAtIndexPath:)])
    {
        return [_delegate pushTreeView:self level:treeTableView.level heightForRowAtIndexPath:indexPath];
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:level:viewForHeaderInSection:)])
    {
        return [_delegate pushTreeView:self level:treeTableView.level viewForHeaderInSection:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushTreeTableView *treeTableView = (PushTreeTableView*)tableView;
    _selectedLevel = treeTableView.level;
    _currentReloadDataLevel = _selectedLevel + 1;
    
    if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:didSelectedLevel:indexPath:)])
    {
        [_delegate pushTreeView:self didSelectedLevel:treeTableView.level indexPath:indexPath];
    }
    
    if (_nextTreeTableView && treeTableView == _curTreeTableView)
    {
        [_nextTreeTableView reloadData];
    }
    else if (treeTableView == _nextTreeTableView ||
            (treeTableView == _curTreeTableView && !_nextTreeTableView))
    {
        BOOL hasNext = FALSE;
        if (_delegate && [_delegate respondsToSelector:@selector(pushTreeViewHasNextLevel:currentLevel:indexPath:)])
        {
            hasNext = [_delegate pushTreeViewHasNextLevel:self currentLevel:treeTableView.level indexPath:indexPath];
        }
        
        if (hasNext)
        {
            ++_level;

            if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:willPushLevel:previousIndexPath:)])
            {
                [_delegate pushTreeView:self willPushLevel:_level previousIndexPath:indexPath];
            }
            
            PushTreeTableView *tableView = [self getNewTreeTableView];
            NSAssert(tableView != nil, @"nil table view");
            
            [tableView reloadData];

            [self applyNextAnimation:tableView preIndexPath:indexPath];
        }
    }
    
    // 更改_curTreeTableView箭头的纵向位置
    [UIView animateWithDuration:AnimationDuration options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self updateOldArrowCenterYValue];
        [self updateTreeTableArrowViewPositionWithToMoveCenterY:oldArrowCenterY];

    }];
}

- (void)showLeftMenuViewWithAnimation
{
    _leftMenuView.hidden = NO;
    _leftMenuView.alpha = 0.0;
    [self bringSubviewToFront:_leftMenuView];
    _leftMenuView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:AnimationDuration options:UIViewAnimationOptionCurveLinear animations:^{
        
        _leftMenuView.transform = CGAffineTransformMakeTranslation(-_leftMenuView.frameOriginX, 0);
        _leftMenuView.alpha = 1.0;
    }];
}

- (void)hideLeftMenuViewWithAnimation
{
    [UIView animateWithDuration:AnimationDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _leftMenuView.transform = CGAffineTransformIdentity;
        _leftMenuView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        _leftMenuView.hidden = YES;
    }];
}

// 更新上一级箭头的位置
- (void)updateOldArrowCenterYValue
{
    NSIndexPath *preIndexPath = [_curTreeTableView indexPathForSelectedRow];
    CGRect clickCellFrame = [_curTreeTableView rectForRowAtIndexPath:preIndexPath];
    CGFloat toMoveArrowCenterY = (clickCellFrame.size.height / 2 + clickCellFrame.origin.y);
    
    oldArrowCenterY = toMoveArrowCenterY;
}

// 更新当前选择的箭头的位置
- (void)updateTreeTableArrowViewPositionWithToMoveCenterY:(CGFloat)centerY
{
    _curTreeTableView.arrowCenterY = centerY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    PushTreeTableView *tableView = (PushTreeTableView *)scrollView;
    
    if ([tableView isKindOfClass:[PushTreeTableView class]] && tableView == _curTreeTableView)
    {
        CGFloat y = scrollView.contentOffset.y;
        [self updateTreeTableArrowViewPositionWithToMoveCenterY:oldArrowCenterY + (y - oldScrollY)];
        
        oldScrollY = scrollView.contentOffset.y;
    }
     */
}

- (void)applyNextAnimation:(PushTreeTableView *)tableView preIndexPath:(NSIndexPath *)indexPath
{
    // 显示左侧菜单
    if (tableView.level == 2)
    {
        [self showLeftMenuViewWithAnimation];
    }
    
    // 确定下一个tab进入视图的x坐标
    CGFloat nextTreeTableViewToMiddleOrginX_new = tableView.level > 1 ? (NextTreeTableViewToMiddleOrginX + 30) : NextTreeTableViewToMiddleOrginX;
    // 确定当下一个tab进入时,当前tab向前推进的距离
    CGFloat currentTreeTableViewToLeftOffsetX_new = NSNotFound;
    if (tableView.level > 2)
    {
        currentTreeTableViewToLeftOffsetX_new = NextTreeTableViewToMiddleOrginX + 30 + offsetOfCoverTabCellImage;
    }
    else if (tableView.level == 2)
    {
        currentTreeTableViewToLeftOffsetX_new = NextTreeTableViewToMiddleOrginX + offsetOfCoverTabCellImage;
    }
    else
    {
        currentTreeTableViewToLeftOffsetX_new = oneTabOffset; // 第一个tab偏移55
    }
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        isAnimation = YES;
        
        if (tableView.level > 1)
        {
            _curTreeTableView.userInteractionEnabled = NO;
           
            _curTreeTableView = _nextTreeTableView;
            _nextTreeTableView = tableView;
        }
        else
        {
            _nextTreeTableView = tableView;
        }
        
        if (_curTreeTableView)
        {
            _curTreeTableView.frame = CGRectOffset(_curTreeTableView.frame, -currentTreeTableViewToLeftOffsetX_new, 0);
        }
        if (_nextTreeTableView)
        {
            _nextTreeTableView.left = nextTreeTableViewToMiddleOrginX_new;
            
        }
        
        // 显示或者隐藏最后一层tab的cells的子标题
        [self showOrHideLastTabVisibleCellsDetailTextLabe:YES];
        
    } completion:^(BOOL finished){
       
        isAnimation = NO;
        [_tableViewsStack addObject:tableView];
        
        // 改变箭头的横向位置
        if (tableView.level > 1)
        {
//            _curTreeTableView.arrowCenterX = currentTreeTableViewToLeftOffsetX_new - ArrowSizeWidth - 1;
            _curTreeTableView.arrowCenterX = nextTreeTableViewToMiddleOrginX_new - ArrowSizeWidth - 1 + offsetOfCoverTabCellImage;
//            _curTreeTableView.arrowView.frameOriginX = nextTreeTableViewToMiddleOrginX_new - ArrowSizeWidth - 1 + offset;
        }
        else
        {
            _curTreeTableView.arrowCenterX = nextTreeTableViewToMiddleOrginX_new + currentTreeTableViewToLeftOffsetX_new - ArrowSizeWidth - 1;
//            _curTreeTableView.arrowView.frameOriginX = nextTreeTableViewToMiddleOrginX_new + currentTreeTableViewToLeftOffsetX_new - ArrowSizeWidth - 1;
        }
        
        // 调用委托
        if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:didPushLevel:previousIndexPath:)])
        {
            [_delegate pushTreeView:self didPushLevel:tableView.level previousIndexPath:indexPath];
        }
    }];
}

- (void)applyBackAnimation:(PushTreeTableView *)tableView
{
    if (tableView.level <= 0) return;
    
    // 隐藏左侧菜单
    if (tableView.level == 2)
    {
        [self hideLeftMenuViewWithAnimation];
    }
    
    // 确定当前tab推出时,上一个tab向后推出的距离
    CGFloat currentTreeTableViewToLeftOffsetX_new = NSNotFound;
    if (tableView.level > 2)
    {
        currentTreeTableViewToLeftOffsetX_new = NextTreeTableViewToMiddleOrginX + 30 + offsetOfCoverTabCellImage;
    }
    else if (tableView.level == 2)
    {
        currentTreeTableViewToLeftOffsetX_new = NextTreeTableViewToMiddleOrginX + offsetOfCoverTabCellImage;
    }
    else
    {
        currentTreeTableViewToLeftOffsetX_new = oneTabOffset; // 第一个tab偏移55
    }
   
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        isAnimation = YES;
        
        if (_nextTreeTableView)
        {
            _nextTreeTableView.left = self.bounds.size.width;
        }
        if (_curTreeTableView)
        {
            _curTreeTableView.frame = CGRectOffset(_curTreeTableView.frame, currentTreeTableViewToLeftOffsetX_new, 0);
        }
        
        // 改变箭头的横向位置
        _curTreeTableView.arrowCenterX = _curTreeTableView.boundsWidth;
//        _curTreeTableView.arrowView.frameOriginX = _curTreeTableView.boundsWidth;
        
    } completion:^(BOOL finished){
        
        isAnimation = NO;
        
        if (tableView.level > 1)
        {
            [_nextTreeTableView removeFromSuperview];
            _nextTreeTableView = _curTreeTableView;
            [_tableViewsStack removeLastObject];
            _curTreeTableView = [_tableViewsStack objectAtIndex:_tableViewsStack.count - 2];
            
            --_level;
            --_selectedLevel;
            --_currentReloadDataLevel;
        }
        else
        {
            [_nextTreeTableView removeFromSuperview];
            _nextTreeTableView = nil;
            [_tableViewsStack removeLastObject];
            _curTreeTableView = [_tableViewsStack firstObject];
            
            _level = 0;
            _selectedLevel = NSNotFound;
            _currentReloadDataLevel = 0;
        }
        
        [self updateOldArrowCenterYValue];
        
        _curTreeTableView.userInteractionEnabled = YES;
        
        // 显示或者隐藏最后一层tab的cells的子标题
        [self showOrHideLastTabVisibleCellsDetailTextLabe:NO];
        // 把最后一层tab的cells全部置为非选择状态
        [self deselectLastTabCells];
        
        // 调用委托
        if (_delegate && [_delegate respondsToSelector:@selector(pushTreeView:didPopLevel:)])
        {
            [_delegate pushTreeView:self didPopLevel:tableView.level];
        }
    }];
}

// 把最后一层tab的cells全部置为非选择状态
- (void)deselectLastTabCells
{
    PushTreeTableView *lastVisibleTab = [_tableViewsStack lastObject]; // 最后显示的一层tab
    NSArray *curTabVisibleCells = [lastVisibleTab visibleCells];
    
    if (curTabVisibleCells && 0 != curTabVisibleCells.count)
    {
        for (ProductCategoryCell *cell in curTabVisibleCells)
        {
            NSIndexPath *indexPath = [lastVisibleTab indexPathForCell:cell];
            [lastVisibleTab deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}

// 显示或者隐藏最后一层tab的cells的子标题
- (void)showOrHideLastTabVisibleCellsDetailTextLabe:(BOOL)yesOrNo
{
    PushTreeTableView *lastVisibleTab = [_tableViewsStack lastObject]; // 最后显示的一层tab
    NSArray *curTabVisibleCells = [lastVisibleTab visibleCells];
    
    if (curTabVisibleCells && 0 != curTabVisibleCells)
    {
        for (ProductCategoryCell *cell in curTabVisibleCells)
        {
            cell.cellDetailTextLabel.hidden = yesOrNo;
        }
    }
}

- (void)back
{
    if (_tableViewsStack.count > 1 && !isAnimation)
    {
        [self applyBackAnimation:[_tableViewsStack lastObject]];
    }
}

- (void)backRoot
{
    if (_tableViewsStack.count > 1 && !isAnimation)
    {
        if (_tableViewsStack.count <= 2)
        {
            [self applyBackAnimation:[_tableViewsStack lastObject]];
        }
        else
        {
            // 显示左侧菜单
            [self hideLeftMenuViewWithAnimation];
            
            NSArray *tableViewsArrayBesideFirst = [_tableViewsStack subarrayWithRange:NSMakeRange(1, _tableViewsStack.count - 1)];
            
            [UIView animateWithDuration:AnimationDuration animations:^{
                
                isAnimation = YES;
                
                for (PushTreeTableView *tableView in tableViewsArrayBesideFirst)
                {
                    tableView.left = self.bounds.size.width;
                    tableView.arrowCenterX = tableView.boundsWidth;
                }
                
                PushTreeTableView *firstTableView = [_tableViewsStack firstObject];
                firstTableView.frame = self.bounds;
                firstTableView.userInteractionEnabled = YES;
                firstTableView.arrowCenterX = firstTableView.boundsWidth;
                
                _curTreeTableView = firstTableView;
                _nextTreeTableView = nil;

            } completion:^(BOOL finished){
                
                isAnimation = NO;
                
                [tableViewsArrayBesideFirst makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_tableViewsStack removeObjectsInArray:tableViewsArrayBesideFirst];
                
                _level = 0;
                _selectedLevel = NSNotFound;
                _currentReloadDataLevel = 0;
                
                // 显示或者隐藏最后一层tab的cells的子标题
                [self showOrHideLastTabVisibleCellsDetailTextLabe:NO];
                
                // 调用委托
                if (_delegate && [_delegate respondsToSelector:@selector(pushTreeViewDidPopTopLevel:)])
                {
                    [_delegate pushTreeViewDidPopTopLevel:self];
                }
            }];
        }
    }
}

@end
