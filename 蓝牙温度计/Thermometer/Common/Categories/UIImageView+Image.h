//
//  UIImageView+Image.h
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

typedef enum
{   /// 根据自身尺寸及图片长宽比自动调整大小全部显示
    ImageShowStyle_AutoResizing = 0,
    /// 根据自身尺寸及图片长宽比剪切成方块显示
    ImageShowStyle_Square,
    /// 不做任何处理
    ImageShowStyle_None
    
} ImageShowStyle;

@interface UIImageView (Image)

#if NS_BLOCKS_AVAILABLE

/// 异步加载网络图片
- (void)gjh_setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success;

- (void)gjh_setImageWithURL:(NSURL *)url imageShowStyle:(ImageShowStyle)style success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

- (void)gjh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imageShowStyle:(ImageShowStyle)style success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

- (void)gjh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imageShowStyle:(ImageShowStyle)style options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;

#endif

/// 取消图片下载
- (void)gjh_cancelCurrentImageLoad;

@end

