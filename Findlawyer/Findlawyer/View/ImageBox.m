//
//  ImageBox.m
//  Find lawyer
//
//  Created by kadis on 14-10-19.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ImageBox.h"
#import "EXPhotoViewer.h"

@implementation ImageBox

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)img delegate:(id)delegate needDeleteBtn:(BOOL)needDelete
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.image = img;
        [self addSubview:_imgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageTap:)];
        [self addGestureRecognizer:tap];
        
        if (needDelete)
        {
            CGFloat btnWidth = 12;
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.backgroundColor = [UIColor clearColor];
            deleteBtn.frame = CGRectMake(self.width - btnWidth - 2, 2, btnWidth, btnWidth);
            [deleteBtn setImage:[UIImage imageNamed:@"Delete_img"] forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:deleteBtn];
        }
    }
    return self;
}

- (void)deleteBtnTouch:(UIButton*)btn
{
    if ([_delegate respondsToSelector:@selector(ImageBoxWantDeleteImg:)]) {
        [_delegate ImageBoxWantDeleteImg:self];
    }
}

- (void)enlargeImageTap:(UIGestureRecognizer*)tap
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [EXPhotoViewer showImageFrom:(UIImageView *)view];
            return;
        }
    }
}

@end