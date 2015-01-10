//
//  GJHSlideSwitchView.m
//  zmt
//
//  Created by apple on 14-3-10.
//  Copyright (c) 2014年 com.ygsoft. All rights reserved.
//

#import "GJHSlideSwitchView.h"

static CGFloat kHeightOfTopScrollView = 0.0f;           // 会根据文字和图片自动调整
static const CGFloat kWidthOfButtonMargin = 20.0f;
static const CGFloat kFontSizeOfTabButton = 14.0f;
static const NSUInteger kTagOfRightSideButton = 999;
static const CGFloat kHeightOfShadowImageView = 3.0f;

@implementation GJHSlideSwitchView

@synthesize topScrollBtnsArray = _topScrollBtnsArray;
@synthesize titlesArray = _titlesArray;
@synthesize topScrollViewBackgroundColor = _topScrollViewBackgroundColor;

#pragma mark - 初始化参数

- (void)initValues
{
    //创建顶部可滑动的tab
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfTopScrollView)];
    _topScrollView.delegate = self;
    _topScrollView.backgroundColor = [UIColor clearColor];
    _topScrollView.pagingEnabled = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _topScrollView.scrollsToTop = NO;
    [self addSubview:_topScrollView];
    _userSelectedChannelID = 100;
    
    self.topScrollBtnsArray = [[NSMutableArray alloc] init];
    
    _isBuildUI = NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles
{
    return [self initWithFrame:frame titlesArray:titles imageNamesArray:nil selectedImageNamesArray:nil];
}

- (id)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titles imageNamesArray:(NSArray *)namesArray selectedImageNamesArray:(NSArray *)selectedNamesArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titlesArray = titles;
        self.imageNamesArray = namesArray;
        self.selectedImageNamesArray = selectedNamesArray;
        
        [self initValues];
    }
    return self;
}

#pragma mark getter/setter

- (void)setRigthSideButton:(UIButton *)rigthSideButton
{
    UIButton *button = (UIButton *)[self viewWithTag:kTagOfRightSideButton];
    [button removeFromSuperview];
    rigthSideButton.tag = kTagOfRightSideButton;
    _rigthSideButton = rigthSideButton;
    [self addSubview:_rigthSideButton];
}

#pragma mark - 创建控件

//当横竖屏切换时可通过此方法调整布局
- (void)layoutSubviews
{
    //创建完子视图UI才需要调整布局
    if (_isBuildUI) {
        //如果有设置右侧视图，缩小顶部滚动视图的宽度以适应按钮
        if (self.rigthSideButton.bounds.size.width > 0) {
            _rigthSideButton.frame = CGRectMake(self.bounds.size.width - self.rigthSideButton.bounds.size.width, 0,
                                                _rigthSideButton.bounds.size.width, kHeightOfTopScrollView);
            
            _topScrollView.frame = CGRectMake(0, 0,
                                              self.bounds.size.width - self.rigthSideButton.bounds.size.width, kHeightOfTopScrollView);
        }
        
        //调整顶部滚动视图选中按钮位置
        UIButton *button = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        [self adjustScrollViewContentX:button];
        
        // 重新调整shadowImage的尺寸
        self.shadowImage = [_shadowImage stretchableImageWithLeftCapWidth:_shadowImage.size.width / 2 topCapHeight:_shadowImage.size.height / 2];
    }
}

// 调整视图高度
- (void)resizeHeight
{
    if ([_titlesArray isAbsoluteValid] && ![_imageNamesArray isAbsoluteValid])
    {
        self.frameHeight = MAX(self.frameHeight, kDefaultSlideSwitchViewHeight);
    }
    else if ([_titlesArray isAbsoluteValid] && [_imageNamesArray isAbsoluteValid])
    {
        UIImage *image = [UIImage imageNamed:_imageNamesArray[0]];
        self.frameHeight = MAX(self.frameHeight, kDefaultSlideSwitchViewHeight + image.size.height);
    }
    
    kHeightOfTopScrollView = self.frameHeight;
    _topScrollView.frameHeight = kHeightOfTopScrollView;
}

/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI
{
    // 调整视图高度
    [self resizeHeight];
    
    // 创建子视图
    [self createNameButtons];
    
    //选中第一个view
    if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
    }
    
    _isBuildUI = YES;
    
    //创建完子视图UI才需要调整布局
    [self setNeedsLayout];
}

/*!
 * @method 初始化顶部tab的各个按钮
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)createNameButtons
{
    UIImage *shadowImage = [_shadowImageArray isAbsoluteValid] ? _shadowImageArray[0] : _shadowImage;
    
    _shadowImageView = [[UIImageView alloc] init];
    [_shadowImageView setImage:shadowImage];
    [_topScrollView addSubview:_shadowImageView];
    _topScrollView.backgroundColor = _topScrollViewBackgroundColor;
    
    //顶部tabbar的总长度
    CGFloat topScrollViewContentWidth = kWidthOfButtonMargin;
    //每个tab偏移量
    CGFloat xOffset = kWidthOfButtonMargin;
    for (int i = 0; i < [_titlesArray count]; i++) {
        NSString *title = [_titlesArray objectAtIndex:i];
        UIImage *normalImage = i < _imageNamesArray.count ? [UIImage imageNamed:_imageNamesArray[i]] : nil;
        UIImage *selectedImage = i < _selectedImageNamesArray.count ? [UIImage imageNamed:_selectedImageNamesArray[i]] : nil;
        UIColor *normalTextColor = i < _tabItemNormalColorArray.count ? _tabItemNormalColorArray[i] : _tabItemNormalColor;
        UIColor *selectedTextColor = i < _tabItemSelectedColorArray.count ? _tabItemSelectedColorArray[i] : _tabItemSelectedColor;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize btnSize = CGSizeZero;
        CGSize textSize = CGSizeZero;
        
        textSize = [title sizeWithFont:[UIFont systemFontOfSize:kFontSizeOfTabButton]
                     constrainedToSize:CGSizeMake(_topScrollView.bounds.size.width, kHeightOfTopScrollView)
                         lineBreakMode:NSLineBreakByTruncatingTail];
        if (!_isTabItemEqualWidthInFullScreenWidth)
        {
            if (normalImage)
            {
                btnSize = CGSizeMake(MAX(textSize.width, normalImage.size.width), kHeightOfTopScrollView);
            }
            else
            {
                btnSize = textSize;
            }
        }
        else
        {
            btnSize = CGSizeMake((self.bounds.size.width - _rigthSideButton.bounds.size.width - kWidthOfButtonMargin * (_titlesArray.count + 1)) / _titlesArray.count, kHeightOfTopScrollView);
        }
        
        //累计每个tab文字的长度
        topScrollViewContentWidth += kWidthOfButtonMargin+btnSize.width;
        //设置按钮尺寸
        [button setFrame:CGRectMake(xOffset,0,
                                    btnSize.width, kHeightOfTopScrollView)];
        //计算下一个tab的x偏移量
        xOffset += btnSize.width + kWidthOfButtonMargin;
        
        [button setTag:i+100];
        if (i == 0) {
            _shadowImageView.frame = CGRectMake(kWidthOfButtonMargin, kHeightOfTopScrollView - kHeightOfShadowImageView, btnSize.width, kHeightOfShadowImageView);
            button.selected = YES;
        }
        /*
        [button setTitle:title forState:UIControlStateNormal];
         */
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeOfTabButton];
        [button setTitleColor:normalTextColor forState:UIControlStateNormal];
        [button setTitleColor:selectedTextColor forState:UIControlStateSelected];
        [button setBackgroundImage:self.tabItemNormalBackgroundImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.tabItemSelectedBackgroundImage forState:UIControlStateSelected];
        if (normalImage)
        {
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, kDefaultSlideSwitchViewHeight / 2 + 5, 0);
            
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:selectedImage forState:UIControlStateSelected];
            
            // 有图片的情况下,在btn上单独放label,btn只显示图片
            UILabel *titleLabel = InsertLabel(button, CGRectMake(0, 0, button.boundsWidth, textSize.height), NSTextAlignmentCenter, title, [UIFont systemFontOfSize:kFontSizeOfTabButton], normalTextColor, NO);
            titleLabel.tag = 8888;
            titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            titleLabel.highlightedTextColor = selectedTextColor;
            titleLabel.center = CGPointMake(button.boundsWidth / 2, button.boundsHeight / 2 + normalImage.size.height / 2);
            if (0 == i)
            {
                titleLabel.highlighted = YES;
            }
        }
        else
        {
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        
        [_topScrollBtnsArray addObject:button];
    }
    
    [_topScrollView bringSubviewToFront:_shadowImageView];
    
    //设置顶部滚动视图的内容总尺寸
    _topScrollView.contentSize = CGSizeMake(topScrollViewContentWidth, kHeightOfTopScrollView);
}

- (void)scrollToIndex:(int)index
{
    if (index < 0 || index >= _topScrollBtnsArray.count) return;
    
    UIButton *button = (UIButton *)[_topScrollView viewWithTag:index + 100];
    [self selectNameButton:button];
}

#pragma mark - 顶部滚动视图逻辑方法

/*!
 * @method 选中tab时间
 * @abstract
 * @discussion
 * @param 按钮
 * @result
 */
- (void)selectNameButton:(UIButton *)sender
{
    //如果点击的tab文字显示不全，调整滚动视图x坐标使用使tab文字显示全
    [self adjustScrollViewContentX:sender];
    
    //如果更换按钮
    if (sender.tag != _userSelectedChannelID) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[_topScrollView viewWithTag:_userSelectedChannelID];
        lastButton.selected = NO;
        ((UILabel *)[lastButton viewWithTag:8888]).highlighted = NO;
        
        //赋值按钮ID
        _userSelectedChannelID = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        ((UILabel *)[sender viewWithTag:8888]).highlighted = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x, _shadowImageView.frameOriginY, sender.frame.size.width, kHeightOfShadowImageView)];
            
            // 更换shadowImageView的image
            NSInteger selectedBtnIndex = [_topScrollBtnsArray indexOfObject:sender];
            UIImage *shadowImage = selectedBtnIndex < _shadowImageArray.count ? _shadowImageArray[selectedBtnIndex] : _shadowImage;
            _shadowImageView.image = shadowImage;
            
        } completion:^(BOOL finished) {
            if (finished) {
                //设置新页出现

                if (self.slideSwitchViewDelegate && [self.slideSwitchViewDelegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
                    [self.slideSwitchViewDelegate slideSwitchView:self didselectTab:_userSelectedChannelID - 100];
                }
            }
        }];
        
    }
    //重复点击选中按钮
    else {
        
    }
}

/*!
 * @method 调整顶部滚动视图x位置
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)adjustScrollViewContentX:(UIButton *)sender
{
    /*
    //如果 当前显示的最后一个tab文字超出右边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x > self.bounds.size.width - (kWidthOfButtonMargin+sender.bounds.size.width)) {
        //向左滚动视图，显示完整tab文字
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - (_topScrollView.bounds.size.width- (kWidthOfButtonMargin+sender.bounds.size.width)), 0)  animated:YES];
    }
    
    //如果 （tab的文字坐标 - 当前滚动视图左边界所在整个视图的x坐标） < 按钮的隔间 ，代表tab文字已超出边界
    if (sender.frame.origin.x - _topScrollView.contentOffset.x < kWidthOfButtonMargin) {
        //向右滚动视图（tab文字的x坐标 - 按钮间隔 = 新的滚动视图左边界在整个视图的x坐标），使文字显示完整
        [_topScrollView setContentOffset:CGPointMake(sender.frame.origin.x - kWidthOfButtonMargin, 0)  animated:YES];
    }
    */
    
    // 让当前选中的item位于scrollView的中间
    if (_topScrollView.contentSize.width > _topScrollView.frame.size.width)
    {
        if ((sender.frame.origin.x + sender.frame.size.width / 2) > _topScrollView.frame.size.width / 2)
        {
            if ((_topScrollView.contentSize.width - (sender.frame.origin.x + sender.frame.size.width / 2)) >= _topScrollView.frame.size.width / 2)
            {
                [_topScrollView setContentOffset:CGPointMake((sender.frame.origin.x + sender.frame.size.width / 2) - _topScrollView.frame.size.width / 2, 0) animated:YES];
            }
            else
            {
                [_topScrollView setContentOffset:CGPointMake(_topScrollView.contentSize.width - _topScrollView.frame.size.width, 0) animated:YES];
            }
        }
        else
        {
            [_topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    else
    {
        [_topScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

@end
