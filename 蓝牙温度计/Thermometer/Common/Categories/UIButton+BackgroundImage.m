//
//  UIButton+BackgroundImage.m
//  o2o
//
//  Created by swift on 14-7-14.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "UIButton+BackgroundImage.h"

@implementation UIButton (BackgroundImage)

#if NS_BLOCKS_AVAILABLE
- (void)gjh_setBackgroundImageWithURL:(NSURL *)url success:(void (^)(UIImage *))success
{
    /*
    WEAKSELF
    void (^successBlock)(UIImage *) = ^(UIImage *image){
        
        success(image);
        
        weakSelf.contentMode = UIViewContentModeScaleAspectFit;
    };
    */
    
    [self gjh_setBackgroundImageWithURL:url success:success failure:nil];
}

- (void)gjh_setBackgroundImageWithURL:(NSURL *)url success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    [self gjh_setBackgroundImageWithURL:url placeholderImage:[UIImage imageNamed:@""] success:success failure:failure];
}

- (void)gjh_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    [self gjh_setBackgroundImageWithURL:url placeholderImage:placeholder options:SDWebImageCacheMemoryOnly success:success failure:failure];
}

- (void)gjh_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *))success failure:(void (^)(NSError *))failure
{
    // [self setBackgroundImageWithURL:url placeholderImage:placeholder options:options success:success failure:failure];
    
    [self sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && !error)
        {
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
    [self sd_cancelBackgroundImageLoadForState:UIControlStateNormal];
}

@end
