//
//  ImageAddView.m
//  Find lawyer
//
//  Created by leo on 14-10-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ImageAddView.h"
#import "EXPhotoViewer.h"

@class ImageBox;

@protocol ImageBoxDelegate <NSObject>

- (void)ImageBoxWantDeleteImg:(ImageBox*)box;

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
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enlargeImageTap:)];
        [self addGestureRecognizer:tap];
        
        CGFloat btnWidth = 12;
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [UIColor clearColor];
        deleteBtn.frame = CGRectMake(self.width - btnWidth - 2, 2, btnWidth, btnWidth);
        [deleteBtn setImage:[UIImage imageNamed:@"Delete_img"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
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


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

#define kTopSpace 8 //距离顶部空间
#define kBottomSpace 10 //距离底部空间
#define kImgBoxStartTag 1000

@implementation ImageAddView
{
    NSMutableArray              *_imageBoxArray;//图片数组
    UIButton                    *_addImgBtn;//添加图片按钮
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _edgeDistance = kDefaultEdgeDistance;
        _lineImageNum = kDefaultLineImageNum;
        _maxAllImageNum = kDefaultMaxAllImageNum;
        _imageViewWidth = kDefaultImageViewWidth;
        _imageViewHeight = kDefaultImageViewHeight;
        _imageVerticalSpace = kDefaultImageVerticalSpace;
        _autoChangeSelfHeight = YES;
        
        _addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addImgBtn.frame = CGRectMake(kDefaultEdgeDistance, kTopSpace, 60, 60);
        [_addImgBtn setImage:[UIImage imageNamed:@"consult_addImg"] forState:UIControlStateNormal];
//        [_addImgBtn setTitle:@"添加图片" forState:UIControlStateNormal];
        [_addImgBtn addTarget:self action:@selector(addImgBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addImgBtn];
        self.height = CGRectGetMaxY(_addImgBtn.frame) + kBottomSpace;
    }
    return self;
}

#pragma mark - btn touch event
//添加图片
- (void)addImgBtnTouch:(UIButton*)btn
{
    if ([_delegate respondsToSelector:@selector(ImageAddViewWantAddImage:)]) {
        [_delegate ImageAddViewWantAddImage:self];
    }
}

#pragma mark - add Image method
- (void)addImage:(UIImage *)img
{
    [self creatImageBox:img];
    [self changeAddBtnOrigin];
}

- (void)addImageArray:(NSArray *)imgArray
{
    for (UIImage *img in imgArray)
    {
        if ([img isKindOfClass:[UIImage class]])
        {
            [self creatImageBox:img];
        }
    }
    [self changeAddBtnOrigin];
}

/**
 *  创建ImageBox 并加入本视图
 *
 *  @param img uiimage
 */
- (void)creatImageBox:(UIImage*)img
{
    if (_imageBoxArray == nil) {
        _imageBoxArray = [[NSMutableArray alloc] init];
    }
    ImageBox *box = [[ImageBox alloc] initWithFrame:[self getImageBoxFrameForIndex:_imageBoxArray.count] image:img delegate:self];
    box.tag = kImgBoxStartTag + _imageBoxArray.count;
    [self addSubview:box];
    [_imageBoxArray addObject:box];
}

/**
 *  获取对应index 的ImageBox frame
 *
 *  @param index ImageBox在_imageBoxArray里所处的index
 *
 *  @return frame
 */
- (CGRect)getImageBoxFrameForIndex:(NSInteger)index
{
    //图片之间的水平距离
    CGFloat betweenSpace = (self.width - _edgeDistance*2 - _imageViewWidth*_lineImageNum)/(_lineImageNum - 1);
    //余数
    NSInteger remainder = index%_lineImageNum;
    //除以 后取整
    NSInteger divisor = (NSInteger)(index/_lineImageNum);
    
    CGFloat x = _edgeDistance + remainder * (_imageViewWidth + betweenSpace);
    CGFloat y = kTopSpace + divisor * (_imageViewHeight + _imageVerticalSpace);
    
    return CGRectMake(x, y, _imageViewWidth, _imageViewHeight);
}


#pragma mark - change frame method
/**
 *  改变自己的高度
 */
- (void)changeSelfHeight
{
    if (_autoChangeSelfHeight)
    {
        CGFloat addBtnAndBottom = CGRectGetMaxY(_addImgBtn.frame) + kBottomSpace;
        if (self.height != addBtnAndBottom)
        {
            self.height = addBtnAndBottom;
            if ([_delegate respondsToSelector:@selector(ImageAddViewMyHeightHasChange:)]) {
                [_delegate ImageAddViewMyHeightHasChange:self];
            }
        }
    }
}

/**
 *  改变 添加图片按钮的 origin
 */
- (void)changeAddBtnOrigin
{
    if (_imageBoxArray.count < _maxAllImageNum)
    {
        _addImgBtn.origin = [self getImageBoxFrameForIndex:_imageBoxArray.count].origin;
        [self changeSelfHeight];
    }
}


#pragma mark - ImageBox delegate
/**
 *  删除图片按钮触发 delegate
 *
 *  @param box
 */
- (void)ImageBoxWantDeleteImg:(ImageBox*)box
{
    int startI = box.tag - kImgBoxStartTag;
    [box removeFromSuperview];
    [_imageBoxArray removeObject:box];
    
    for (int i=startI; i<_imageBoxArray.count; i++)
    {
        ImageBox *box = [_imageBoxArray objectAtIndex:i];
        box.origin = [self getImageBoxFrameForIndex:i].origin;
    }
    [self changeAddBtnOrigin];
}

@end
