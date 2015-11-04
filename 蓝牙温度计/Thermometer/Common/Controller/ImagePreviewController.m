//
//  ImagePreviewController.m
//  JmrbNews
//
//  Created by swift on 14/12/6.
//
//

#import "ImagePreviewController.h"
#import "CycleScrollView.h"

#define kNavBarHeight (44.0 + 20.0)

@interface ImagePreviewController () <CycleScrollViewDelegate>
{
    UINavigationBar *_navBar;
    
    UIImageView     *_imageDescBGView;  // 图注背景视图
    UILabel         *_titleLabel;       // 标题
    UILabel         *_indexLabel;       // 页数
    UITextView      *_descTV;           // 描述
}

@property (nonatomic, strong) NSMutableArray *imageSourceArray;    // 图片的urls或者图片名数组
@property (nonatomic, strong) NSMutableArray *imageDescArray;      // 图片对应的图注描述数组

@end

@implementation ImagePreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self unpackSourceData];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)unpackSourceData
{
    if ([_imageItemsArray isAbsoluteValid])
    {
        self.imageSourceArray = [NSMutableArray arrayWithCapacity:_imageItemsArray.count];
        self.imageDescArray = [NSMutableArray arrayWithCapacity:_imageItemsArray.count];
        
        for (ImageItem *item in _imageItemsArray)
        {
            [_imageSourceArray addObject:item.imageUrlOrNameStr ? item.imageUrlOrNameStr : @""];
            [_imageDescArray addObject:item.imageDescStr ? item.imageDescStr : @""];
        }
    }
}

- (NSString *)curIndexStrByCurIndex:(NSInteger)curIndex
{
    return [NSString stringWithFormat:@"%d/%d",curIndex + 1, _imageSourceArray.count];
}

- (void)initialization
{
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.viewBoundsWidth, kNavBarHeight)];
    [_navBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor] size:CGSizeMake(1, 1)]
                 forBarMetrics:UIBarMetricsDefault];
    _navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    item.leftBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 30, 30)
                                                           normalImg:[UIImage imageNamed:@"navBack"]
                                                      highlightedImg:nil
                                                              target:self action:@selector(backViewController)];
    _navBar.items = @[item];
    [self.view addSubview:_navBar];
    
    // scroll
    /*
    UIScrollView *scrollView = InsertScrollView(self.view, self.view.bounds, 1000, self);
    [scrollView addTarget:self action:@selector(operationTapGesture:)];
    scrollView.backgroundColor = [UIColor blueColor];
     */
    CycleScrollView *scrollView = [[CycleScrollView alloc] initWithFrame:self.view.bounds
                                                         viewContentMode:ViewShowStyle_AutoResizing
                                                                delegate:self
                                                         imgUrlsStrArray:_imageSourceArray
                                                            isAutoScroll:NO
                                                               isCanZoom:YES];
    scrollView.pageControl.hidden = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:scrollView];
    
    // 前置navBar
    [self.view bringSubviewToFront:_navBar];
    
    const CGFloat viewBetweenSpace = 10.0;
    
    // 图片图注及页数显示
    UIImageView *BGView = InsertImageView(self.view, CGRectZero, nil, nil);
    BGView.backgroundColor = [UIColor clearColor];
    _imageDescBGView = BGView;
    [BGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(self.viewBoundsWidth, 80));
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    // 页数
    UILabel *curIndexLabel = InsertLabel(BGView, CGRectZero, NSTextAlignmentRight, [self curIndexStrByCurIndex:0], SP12Font, [UIColor whiteColor], NO);
    [curIndexLabel sizeToFit];
    _indexLabel = curIndexLabel;
    [curIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BGView);
        make.right.equalTo(BGView).with.offset(-viewBetweenSpace);
        make.height.equalTo(18);
    }];
    
    // 标题
    UILabel *titleLabel = InsertLabel(BGView, CGRectZero, NSTextAlignmentLeft, _titleStr, SP15Font, [UIColor whiteColor], NO);
    _titleLabel = titleLabel;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(viewBetweenSpace);
        make.top.equalTo(curIndexLabel.mas_top);
        make.right.mas_lessThanOrEqualTo(curIndexLabel.mas_left).with.offset(-viewBetweenSpace);
        make.height.equalTo(curIndexLabel.mas_height);
    }];
    
    // 图注
    UITextView *textView = [[UITextView alloc] init];
    textView.userInteractionEnabled = NO;
    textView.textColor = [UIColor whiteColor];
    textView.font = SP12Font;
    [BGView addSubview:textView];
    textView.text = [_imageDescArray isAbsoluteValid] ? _imageDescArray[0] : nil;
    textView.backgroundColor = [UIColor clearColor];
    _descTV = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(@(0));
        make.left.equalTo(titleLabel);
        make.right.equalTo(curIndexLabel);
        make.bottom.equalTo(BGView).with.offset(@(0));
    }];
}

- (void)operationTapGesture:(UITapGestureRecognizer *)gesture
{
    [self hideOrShowNavigationBar];
}

- (void)hideOrShowNavigationBar
{
    WEAKSELF
    [self.view animationFadeWithExecuteBlock:^{
        STRONGSELF
        strongSelf->_navBar.hidden = !strongSelf->_navBar.hidden;
        strongSelf->_imageDescBGView.hidden = !strongSelf->_imageDescBGView.hidden;
        [[UIApplication sharedApplication] setStatusBarHidden:strongSelf->_navBar.hidden withAnimation:UIStatusBarAnimationSlide];
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }];
}

- (BOOL)prefersStatusBarHidden
{
    // 返回NO表示要显示,返回YES将hiden
    return _navBar.hidden;
}

#pragma mark - CycleScrollViewDelegate methods

- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index
{
    [self hideOrShowNavigationBar];
}

- (void)didScrollToPage:(CycleScrollView *)csView atPage:(NSInteger)page
{
    _indexLabel.text = [self curIndexStrByCurIndex:page];
    _descTV.text = _imageDescArray[page];
}

@end

#pragma mark - ////////////////////////////////////////////////////////////////////////////////

@implementation ImageItem

- (id)initWithImageUrlOrName:(NSString *)urlOrName imageDesc:(NSString *)desc
{
    self = [super init];
    if (self)
    {
        self.imageUrlOrNameStr = urlOrName;
        self.imageDescStr = desc;
    }
    return self;
}

@end
