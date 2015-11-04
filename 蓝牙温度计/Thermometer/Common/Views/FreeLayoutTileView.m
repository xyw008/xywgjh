//
//  FreeLayoutTileView.m
//  KKDictionary
//
//  Created by 龚俊慧 on 15/10/19.
//  Copyright © 2015年 YY. All rights reserved.
//

#import "FreeLayoutTileView.h"

@interface FreeLayoutTileView ()
{
    NSMutableArray<NSArray *> *_linesTitlesArray;
}

@end

@implementation FreeLayoutTileView

- (instancetype)initWithOrigin:(CGPoint)origin width:(CGFloat)width titlesArray:(NSArray<NSString *> *)titlesArray
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, 0)];
    if (self)
    {
        _titlesArray = titlesArray;
        
        [self setup];
    }
    return self;
}

/*
- (void)awakeFromNib
{
    [self setup];
}
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textFont = kSystemFont_Size(15);
    self.textColor = [UIColor blackColor];
    self.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.lineSpacing = 10;
    self.interitemSpacing = 10;
    
    self.textToBorderHorizontalSpace = 10;
    self.textToBorderVerticalSpace = 5;
    self.isFillItemWidth = YES;
}

- (void)setTitlesArray:(NSArray<NSString *> *)titlesArray
{
    _titlesArray = titlesArray;
    
    [self configureUI];
}

- (CGFloat)height
{
    [self groupDataOfLine];
    
    CGFloat itemHeight = [self stringHeight];
    return _contentInset.top + _contentInset.bottom + itemHeight * _linesTitlesArray.count + _lineSpacing * (_linesTitlesArray.count - 1);
}

- (CGFloat)stringWidth:(NSString *)string
{
    return [string sizeWithFont:_textFont constrainedToWidth:self.frameWidth - _contentInset.left - _contentInset.right].width + _textToBorderHorizontalSpace * 2;
}

- (CGFloat)stringHeight
{
    return [@"height" stringSizeWithFont:_textFont].height + _textToBorderVerticalSpace * 2;
}

// 一行所有控件的总宽度
- (CGFloat)lineTotalWidthByLineTitlesArray:(NSArray<NSString *> *)titlesArray
{
    CGFloat totalWidth = 0;
    for (NSString *title in titlesArray) {
        totalWidth += [self stringWidth:title];
    }
    return _contentInset.left + _contentInset.right + totalWidth + _interitemSpacing * (titlesArray.count - 1);
}

// 把字符串数据按行分组,一行能够显示下的放在一起
- (void)groupDataOfLine
{
    _linesTitlesArray = [NSMutableArray array];
    NSMutableArray<NSString *> *aLineArray = [NSMutableArray array];
    CGFloat titlesTotalWidth = _contentInset.left + _contentInset.right;
    BOOL isLineFirst = YES; // 是否为每一行的第一个
    
    for (NSString *title in _titlesArray) {
        
        NSInteger index = [_titlesArray indexOfObject:title];
        
        CGFloat width = [self stringWidth:title];
        titlesTotalWidth += (width + (isLineFirst ? 0 : _interitemSpacing));
        isLineFirst = NO;
        
        // 一行还没有满
        if (titlesTotalWidth < self.frameWidth)
        {
            [aLineArray addObject:title];
            
            if (index == (_titlesArray.count - 1))
            {
                [_linesTitlesArray addObject:[aLineArray copy]];
            }
        }
        // 一行已满
        else if (titlesTotalWidth == self.frameWidth)
        {
            [aLineArray addObject:title];
            [_linesTitlesArray addObject:[aLineArray copy]];
            
            [aLineArray removeAllObjects];
            titlesTotalWidth = _contentInset.left + _contentInset.right;
            isLineFirst = YES;
        }
        // 一行已满,需换行
        else
        {
            [_linesTitlesArray addObject:[aLineArray copy]];
            
            [aLineArray removeAllObjects];
            [aLineArray addObject:title];
            
            titlesTotalWidth = _contentInset.left + _contentInset.right + width;
            
            if (index == (_titlesArray.count - 1))
            {
                [_linesTitlesArray addObject:[aLineArray copy]];
            }
        }
    }
}

- (void)configureUI
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.frameHeight = self.height;
    /*
     [self mas_updateConstraints:^(MASConstraintMaker *make) {
     make.height.equalTo(@(viewHeight));
     }];
     */
    
    // 创建控件
    int tag = 0;
    
    for (int k = 0; k < _linesTitlesArray.count; ++k) {
        NSArray *aLineTitleArray = _linesTitlesArray[k];
        CGFloat lineTotalTitlesWidth = 0.0;
        
        // 把剩下没有填满的宽度平分给每一个item
        CGFloat fillingWidth = 0;
        if (_isFillItemWidth)
        {
            fillingWidth = (self.frameWidth - [self lineTotalWidthByLineTitlesArray:aLineTitleArray]) / aLineTitleArray.count;
        }
        
        for (int i = 0; i < aLineTitleArray.count; ++i) {
            NSString *title = aLineTitleArray[i];
            CGFloat itemWidth = MIN([self stringWidth:title] + fillingWidth, self.frameWidth - _contentInset.left - _contentInset.right);
            CGFloat itemHeight = [self stringHeight];
            
            UIButton *btn = InsertButton(self, CGRectMake(_contentInset.left + i * _interitemSpacing + lineTotalTitlesWidth, _contentInset.top + k * (itemHeight + _lineSpacing), itemWidth, itemHeight),
                                         tag,
                                         title,
                                         self,
                                         @selector(clickItemBtn:));
            // btn.backgroundColor = [UIColor redColor];
            ++tag;
            btn.titleLabel.font = _textFont;
            [btn setTitleColor:_textColor forState:UIControlStateNormal];
            
            if (_itemStyleHandle) _itemStyleHandle(btn);
            
            lineTotalTitlesWidth += itemWidth;
        }
    }
}

- (void)clickItemBtn:(UIButton *)sender
{
    if (_actionHandle) _actionHandle(sender, sender.tag);
}

@end
