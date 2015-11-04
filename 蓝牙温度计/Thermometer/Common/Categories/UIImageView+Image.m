//
//  UIImageView+Image.m
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "UIImageView+Image.h"

@implementation UIImageView (Image)

#if NS_BLOCKS_AVAILABLE
- (void)gjh_setImageWithURL:(NSURL *)url success:(void (^)(UIImage *))success
{
    [self gjh_setImageWithURL:url imageShowStyle:ImageShowStyle_AutoResizing success:success failure:nil];
}

- (void)gjh_setImageWithURL:(NSURL *)url imageShowStyle:(ImageShowStyle)style success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    [self gjh_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""] imageShowStyle:style success:success failure:failure];
}

- (void)gjh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imageShowStyle:(ImageShowStyle)style success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    [self gjh_setImageWithURL:url placeholderImage:placeholder imageShowStyle:style options:SDWebImageCacheMemoryOnly success:success failure:failure];
}

- (void)gjh_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imageShowStyle:(ImageShowStyle)style options:(SDWebImageOptions)options success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    self.contentMode = UIViewContentModeCenter;
    
    // [self setImageWithURL:url placeholderImage:placeholder imageShowStyle:style options:options success:success failure:failure];
    
    WEAKSELF
    [self sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:placeholder options:options progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && !error)
        {
            switch (style)
            {
                case ImageShowStyle_AutoResizing:
                {
                    weakSelf.contentMode = UIViewContentModeScaleAspectFit;
                }
                    break;
                case ImageShowStyle_Square:
                {
                    weakSelf.contentMode = UIViewContentModeScaleToFill;
                    image = [image squareImage];
                }
                    break;
                case ImageShowStyle_None:
                {
                    // do nothing
                    weakSelf.contentMode = UIViewContentModeScaleToFill;
                }
                    break;
                    
                default:
                    break;
            }
            
            weakSelf.image = image;
            [weakSelf setNeedsLayout];
            
            // 回调
            if (success) success(image);
        }
        else
        {
            if (failure) failure(error);
        }
    }];
}
#endif

- (void)gjh_cancelCurrentImageLoad
{
    [self sd_cancelCurrentImageLoad];
}

@end
