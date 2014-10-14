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
    
    [self setImageWithURL:url placeholderImage:placeholder imageShowStyle:style options:options success:success failure:failure];
}
#endif

- (void)gjh_cancelCurrentImageLoad
{
    [self cancelCurrentImageLoad];
}

@end
