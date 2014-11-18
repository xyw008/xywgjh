//
//  CycleScrollView.m
//  o2o
//
//  Created by swift on 14-7-17.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "CycleScrollView.h"
#import "StringJudgeManager.h"
#import "MyScaleScrollView.h"
#import "GCDThread.h"

#define AutoScrollIntervalTime 4.0

@interface CycleScrollView ()
{
    NSInteger _totalPages;
    
    NSArray *_imageDataSourceArray;
    NSMutableArray *_curImageDataSourceArray;
    
    BOOL _isAutoScroll;
    BOOL _isCanZoom;
    ViewShowStyle _viewContentMode;
}

@end

@implementation CycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _currentPage;
@synthesize delegate = _delegate;

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame viewContentMode:(ViewShowStyle)contenMode delegate:(id<CycleScrollViewDelegate>)delegate imgUrlsStrArray:(NSArray *)urlsStrArray isAutoScroll:(BOOL)YesOrNo isCanZoom:(BOOL)canZoom
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        _imageDataSourceArray = urlsStrArray;
        _viewContentMode = contenMode;
        _isAutoScroll = YesOrNo;
        _isCanZoom = canZoom;
        
        if([_imageDataSourceArray isAbsoluteValid])
        {
            [self setup];
            [self loadData];
            [self setAutoScroll];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame viewContentMode:(ViewShowStyle)contenMode delegate:(id<CycleScrollViewDelegate>)delegate localImgNames:(NSArray *)names isAutoScroll:(BOOL)YesOrNo isCanZoom:(BOOL)canZoom
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        _imageDataSourceArray = names;
        _viewContentMode = contenMode;
        _isAutoScroll = YesOrNo;
        _isCanZoom = canZoom;
        
        if([_imageDataSourceArray isAbsoluteValid])
        {
            [self setup];
            [self loadData];
            [self setAutoScroll];
        }
    }
    return self;
}

- (void)setup
{
    // Initialization code
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 30;
    rect.size.height = 30;
    _pageControl = [[UIPageControl alloc] initWithFrame:rect];
    _pageControl.userInteractionEnabled = NO;
    
    [self addSubview:_pageControl];
    
    // 默认从第0页开始
    _currentPage = 0;
    _totalPages = _imageDataSourceArray.count;
    _pageControl.numberOfPages = _totalPages;
}

// 获取一个加载图片的scrollView子视图
// ImageDataSourceStr: 图片名或者图片URL
- (UIView *)getOnceSubviewOfScrollViewWithCurImageDataSourceStr:(NSString *)dataSource
{
    if ([dataSource isAbsoluteValid])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];

        // 是一个有效的url
        if ([StringJudgeManager isValidateStr:dataSource regexStr:UrlRegex])
        {
            NSURL *url = [NSURL URLWithString:dataSource];
            
            [imageView gjh_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"shangpinxiangqing-morentupian"] imageShowStyle:_viewContentMode options:SDWebImageCacheMemoryOnly success:nil failure:nil];
            
            if (_isCanZoom)
            {
                MyScaleScrollView *zoomScroll = [[MyScaleScrollView alloc] initWithFrame:self.bounds];
                imageView.tag = SubviewTag;
                imageView.frame = zoomScroll.bounds;
                [zoomScroll addSubview:imageView];
                
                return zoomScroll;
            }
            else
            {
                return imageView;
            }
        }
        // 为本地图片名
        else
        {
            UIImage *image = nil;
            
            // imgeDataSourceItemString有可能是沙盒里的图片路径也有可能是bundle里的图片名
            if ([[NSFileManager defaultManager] isReadableFileAtPath:dataSource])
            {
                image = [UIImage imageWithContentsOfFile:dataSource];
            }
            else
            {
                image = [UIImage imageNamed:dataSource];
            }
            
            switch (_viewContentMode)
            {
                case ViewShowStyle_AutoResizing:
                {
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
                    break;
                case ViewShowStyle_Square:
                {
                    image = [image squareImage];
                }
                    break;
                case ViewShowStyle_None:
                {
                    // do nothing
                }
                    break;
                    
                default:
                    break;
            }
            
            imageView.image = image;
            
            if (_isCanZoom)
            {
                MyScaleScrollView *zoomScroll = [[MyScaleScrollView alloc] initWithFrame:self.bounds];
                imageView.tag = SubviewTag;
                imageView.frame = zoomScroll.bounds;
                [zoomScroll addSubview:imageView];
                
                return zoomScroll;
            }
            else
            {
                return imageView;
            }
        }
    }
    return nil;
}

- (void)setAutoScroll
{
    if (_isAutoScroll)
    {
        [GCDThread enqueueBackground:^{
            while (YES)
            {
                [NSThread sleepForTimeInterval:AutoScrollIntervalTime];

                [GCDThread enqueueForeground:^{
                    
//                    DLog(@" %d == %@",_currentPage,NSStringFromCGPoint(_scrollView.contentOffset));
                    
                    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 2, 0) animated:YES];
                }];
            }
        }];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [self scrollToIndex:currentPage];
}

- (void)scrollToIndex:(int)aIndex
{
    if (aIndex > (_totalPages - 1) || aIndex < 0) return;
    
    WEAKSELF
    [_scrollView animationFadeWithExecuteBlock:^{
        
        _currentPage = aIndex;
        [weakSelf loadData];
    }];
}

- (void)loadData
{
//    _pageControl.currentPage = _currentPage;
    _pageControl.currentPage = [self validPageValue:_currentPage];
    
    // 从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if(subViews && [subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_currentPage];
    
    for (int i = 0; i < 3; i++)
    {
        UIView *view = [self getOnceSubviewOfScrollViewWithCurImageDataSourceStr:_curImageDataSourceArray[i]];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [view addGestureRecognizer:singleTap];
        
        view.frame = CGRectOffset(self.bounds, self.bounds.size.width * i, 0);
        
        [_scrollView addSubview:view];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page
{
    int pre = [self validPageValue:_currentPage - 1];
    _currentPage = page = [self validPageValue:page];
    int last = [self validPageValue:_currentPage + 1];
    
    if (!_curImageDataSourceArray)
    {
        _curImageDataSourceArray = [[NSMutableArray alloc] init];
    }
    
    [_curImageDataSourceArray removeAllObjects];
    
    [_curImageDataSourceArray addObject:_imageDataSourceArray[pre]];
    [_curImageDataSourceArray addObject:_imageDataSourceArray[page]];
    [_curImageDataSourceArray addObject:_imageDataSourceArray[last]];
}

- (int)validPageValue:(NSInteger)value
{
    if (_totalPages >= 2)
    {
        if(value < 0) value = _totalPages - 1;
        if(value > _totalPages - 1) value = 0;
    }
    else
    {
        value = 0;
    }
    
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)])
    {
        [_delegate didClickPage:self atIndex:_currentPage];
    }
}

/*
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _currentPage)
    {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++)
        {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}
 */

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int x = aScrollView.contentOffset.x;
    
    // 往下翻一张
    if(x >= (2 * self.frame.size.width))
    {
        _currentPage = [self validPageValue:_currentPage + 1];
        [self loadData];
    }
    
    // 往上翻
    if(x <= 0)
    {
        _currentPage = [self validPageValue:_currentPage - 1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

@end
