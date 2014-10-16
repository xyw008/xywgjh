//
//  ImageAddView.m
//  Find lawyer
//
//  Created by leo on 14-10-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ImageAddView.h"


@class ImageBox;

@protocol ImageBoxDelegate <NSObject>

- (void)ImageBox:(ImageBox*)box didDeleteBtn:(UIButton*)btn;

@end

@interface ImageBox : UIView
{
    UIButton                        *_deleteBtn;//删除按钮
    __weak id<ImageBoxDelegate>     _delegate;
}

@end


@implementation ImageBox

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)img delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.image = img;
        [self addSubview:imageView];
        
        CGFloat btnWidth = 20;
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor clearColor];
        deleteBtn.frame = CGRectMake(self.width - btnWidth, 0, btnWidth, btnWidth);
        [deleteBtn setImage:[UIImage imageNamed:@"Delete_img"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
    }
    return self;
}

- (void)deleteBtnTouch:(UIButton*)btn
{
    if ([_delegate respondsToSelector:@selector(ImageBox:didDeleteBtn:)]) {
        [_delegate ImageBox:self didDeleteBtn:btn];
    }
}

@end


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////


@implementation ImageAddView



@end
