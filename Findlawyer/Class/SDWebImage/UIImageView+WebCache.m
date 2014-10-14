/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "UIImage+SSToolkitAdditions.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}

// 新增方法
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder imageShowStyle:(int)style options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    self.image = placeholder;
    
    if (url)
    {
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:style], @"imageShowStyle", nil];
        [manager downloadWithURL:url delegate:self options:options userInfo:info success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    if ([info objectForKey:@"imageShowStyle"])
    {
        int styleValue = [[info objectForKey:@"imageShowStyle"] intValue];
        
        switch (styleValue)
        {
            case 0:
            {
                self.contentMode = UIViewContentModeScaleAspectFit;
            }
                break;
            case 1:
            {
                self.contentMode = UIViewContentModeScaleToFill;
                image = [image squareImage];
            }
                break;
            case 2:
            {
                // do nothing
                self.contentMode = UIViewContentModeScaleToFill;
            }
                break;
                
            default:
                break;
        }
    }
    
    self.image = image;
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info
{
    if ([info objectForKey:@"imageShowStyle"])
    {
        int styleValue = [[info objectForKey:@"imageShowStyle"] intValue];
        
        switch (styleValue)
        {
            case 0:
            {
                self.contentMode = UIViewContentModeScaleAspectFit;
            }
                break;
            case 1:
            {
                self.contentMode = UIViewContentModeScaleToFill;
                image = [image squareImage];
            }
                break;
            case 2:
            {
                // do nothing
                self.contentMode = UIViewContentModeScaleToFill;
            }
                break;
                
            default:
                break;
        }
    }
    
    self.image = image;
    [self setNeedsLayout];
}

@end
