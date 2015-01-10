//
//  EICheckBox.m
//  EInsure
//
//  Created by ivan on 14-5-9.
//  Copyright (c) 2014年 leo All rights reserved.
//

#import "YGButtonBox.h"

@interface YGButtonBox()
{
    CGFloat             _iconWidth;
    CGFloat             _betweenWidth;
    CGFloat             _iconStartX;
}

@end

@implementation YGButtonBox


- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.exclusiveTouch = YES;
//        [self setImage:[UIImage imageNamed:@"checkbox1_unchecked.png"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"checkbox1_checked.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(selectboxBtn) forControlEvents:UIControlEventTouchUpInside];
        _iconWidth = 15.0;
        _betweenWidth = 5.0;
        _iconStartX = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        _iconWidth = 15.0;
        _betweenWidth = 5.0;
        _iconStartX = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame iconStartX:(CGFloat)iconStartX iconWidth:(CGFloat)iconWidth iconAndTitleSpaceBetween:(CGFloat)betweenWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        self.exclusiveTouch = YES;
        _iconWidth = iconWidth;
        _betweenWidth = betweenWidth;
        _iconStartX = iconStartX;
    }
    return self;
}

- (void)setSelectBtn:(BOOL)selectBtn
{
    if (_selectBtn == selectBtn)
        return;
    
    _selectBtn = selectBtn;
    self.selected = selectBtn;
    
    if (_delegate && [_delegate respondsToSelector:@selector(YGButtonBox:didSelect:)]) {
        [_delegate YGButtonBox:self didSelect:self.selected];
    }
}

- (void)selectboxBtn
{
    self.selected = !self.selected;
    _selectBtn = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(YGButtonBox:didSelect:)]) {
        [_delegate YGButtonBox:self didSelect:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(_iconStartX, (CGRectGetHeight(contentRect) - _iconWidth)/2.0, _iconWidth, _iconWidth);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(_iconStartX + _iconWidth + _betweenWidth, 0,
                      CGRectGetWidth(contentRect) - _iconWidth - _betweenWidth,
                      CGRectGetHeight(contentRect));
}

//- (void)dealloc {
//    _delegate = nil;
//}

@end
