//
//  ImageBox.h
//  Find lawyer
//
//  Created by kadis on 14-10-19.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageBox;
@protocol ImageBoxDelegate <NSObject>

- (void)ImageBoxWantDeleteImg:(ImageBox*)box;

@end

@interface ImageBox : UIView
{
    UIButton                        *_deleteBtn;//删除按钮
    __weak id<ImageBoxDelegate>     _delegate;
}

@property (nonatomic,strong)UIImageView  *imgView;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)img delegate:(id)delegate needDeleteBtn:(BOOL)needDelete;


@end