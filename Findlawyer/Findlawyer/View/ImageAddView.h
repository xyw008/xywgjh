//
//  ImageAddView.h
//  Find lawyer
//
//  Created by leo on 14-10-16.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//  添加图片视图

#import <UIKit/UIKit.h>

@class ImageAddView;

@protocol ImageAddViewDelegate <NSObject>

/**
 *  点击添加图片按钮触发
 *
 *  @param addView self
 */
- (void)ImageAddViewWantAddImage:(ImageAddView*)addView;

/**
 *  改变高度触发
 *
 *  @param addView self
 */
- (void)ImageAddViewMyHeightHasChange:(ImageAddView *)addView;

/**
 *  删除图片触发
 *
 *  @param addView self
 *  @param img     删除的图片
 */
- (void)ImageAddView:(ImageAddView *)addView deleteImg:(UIImage*)img;

@end




#define kDefaultEdgeDistance 15
#define kDefaultLineImageNum 3
#define kDefaultMaxAllImageNum 6
#define kDefaultImageViewWidth 60
#define kDefaultImageViewHeight 60
#define kDefaultImageVerticalSpace 8

@interface ImageAddView : UIView
{
    __weak id<ImageAddViewDelegate>                 _delegate;
}

@property (nonatomic,weak)id                        delegate;

@property (nonatomic,assign)CGFloat                 edgeDistance;//边缘距离 (default 15)

@property (nonatomic,assign,readonly)NSInteger      lineImageNum;//一行的图片数量 (default 3)

@property (nonatomic,assign)NSInteger               maxAllImageNum;//允许最多图片数目 (default 6)

@property (nonatomic,assign,readonly)CGFloat        imageViewWidth;//图片视图的宽度 (优先级高于 lineImageNum 参数, default 60)

@property (nonatomic,assign,readonly)CGFloat        imageViewHeight;//图片视图的高度 (default 60)

@property (nonatomic,assign)CGFloat                 imageVerticalSpace;//图片间的垂直间距 (default 8)

@property (nonatomic,assign,readonly)BOOL           autoChangeSelfHeight;//是否自动改变自己的高度(default YES)

/**
 *  添加一张图片
 *
 *  @param img UIImage
 */
- (void)addImage:(UIImage*)img;

/**
 *  添加一组图片
 *
 *  @param imgArray 图片数组
 */
- (void)addImageArray:(NSArray*)imgArray;



@end
