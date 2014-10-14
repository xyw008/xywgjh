//
//  UIButton+Cache.m
//  zmt
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "UIButton+Cache.h"
#import "UrlManager.h"
#import "MyScaleScrollView.h"
#import "SDImageCache.h"

@implementation UIButton (Cache)

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options
{
    [self setBackgroundImageWithImageId:imageId storeTableType:storeTableType placeholderImage:placeholder options:options resize:NO];
}

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options resize:(BOOL)resize
{
    [self setBackgroundImageWithImageId:imageId storeTableType:storeTableType placeholderImage:placeholder options:options isRoundedRect:NO roundedRectSize:CGSizeZero resize:resize];
}

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize
{
    [self setBackgroundImageWithImageId:imageId storeTableType:storeTableType placeholderImage:placeholder options:options isRoundedRect:isRoundedRect roundedRectSize:roundedRectSize resize:NO];
}

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize resize:(BOOL)resize
{
    // 取消上一次的图片下载
    [self cancelCurrentImageLoad];

    if (resize)
        [self setNewImgBtn:placeholder oldImgBtn:self];
    else
    {
        [self setBackgroundImage:placeholder forState:UIControlStateNormal];
        [self setBackgroundImage:placeholder forState:UIControlStateSelected];
        [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
    }
    
    if (imageId)
    {
        NSString *cacheKeyStr = [NSString stringWithFormat:@"%@",imageId];
        
        UIImage *cacheImg = nil;
        
        if (WebImageNotCache != options)
        {
            cacheImg = [[SDImageCache sharedImageCache] imageFromKey:cacheKeyStr fromDisk:options == WebImageDownload ? YES : NO];
        }
        
        if (cacheImg)
        {
            if (isRoundedRect)
                cacheImg = [UIImage createRoundedRectImage:cacheImg roundedRectSize:roundedRectSize];
            
            if (resize)
                [self setNewImgBtn:cacheImg oldImgBtn:self];
            else
            {
                [self setBackgroundImage:cacheImg forState:UIControlStateNormal];
                [self setBackgroundImage:cacheImg forState:UIControlStateSelected];
                [self setBackgroundImage:cacheImg forState:UIControlStateHighlighted];
            }
        }
        else
        {
            NSURL *url = nil;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            switch (storeTableType)
            {
                case WebImageStoreTablePic:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"com.ygsoft.omc.base.service.PictureService/getPictureById"];
                    
                    [dic setObject:imageId forKey:@"picId"];//图片ID
                    [dic setObject:[NSNumber numberWithInt:3] forKey:@"picType"];//图片类型(1为低分辨率,2为中分辨率,3为高分辨率)
                }
                    break;
                case WebImageStoreTableFileLittle:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"FileService/getFileByteById"];
                    
                    [dic setObject:imageId forKey:@"fileId"];//图片ID
                }
                    break;
                case WebImageStoreTableFileLarge:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"FileService/downFile"];
                    
                    [dic setObject:imageId forKey:@"fileId"];//图片ID
                }
                    break;
                    
                default:
                    break;
            }
            
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
            [userInfoDic setObject:self forKey:@"btn"];
            [userInfoDic setObject:cacheKeyStr forKey:@"cacheKey"];
            [userInfoDic setObject:[NSNumber numberWithInt:options] forKey: @"options"];
            [userInfoDic setObject:[NSNumber numberWithBool:isRoundedRect] forKey: @"isRoundedRect"];
            [userInfoDic setObject:[NSValue valueWithCGSize:roundedRectSize] forKey: @"roundedRectSize"];
            [userInfoDic setObject:[NSNumber numberWithBool:resize] forKey: @"resize"];
            
            [[NetRequestManager sharedInstance] sendRequest:url parameterDic:dic requestTag:1000 delegate:self userInfo:userInfoDic];
        }
    }
}

- (void)cancelCurrentImageLoad
{
    [[NetRequestManager sharedInstance] clearDelegate:self];
}

- (void)setNewImgBtn:(UIImage *)image oldImgBtn:(UIButton *)oldImgBtn
{
    if (!image || !oldImgBtn) return;
    
    UIView *superView = oldImgBtn.superview;
    
    // 先以高度为标准来改image的宽度
    CGSize size = image.size;
    
    float widthScale = size.height / superView.boundsHeight;
    
    size.height = superView.boundsHeight;
    size.width = size.width / widthScale;
    
    // 改变旧imageBtn的尺寸
    oldImgBtn.frame = CGRectMake((superView.boundsWidth - size.width) / 2, 0, size.width, size.height);
    
    // 如果宽度超出了scrollview的宽度,那就以宽度为标准来改image的高度
    if (size.width > superView.boundsWidth)
    {
        float heightScale = size.width / superView.boundsWidth;
        
        size.width = superView.boundsWidth;
        size.height = size.height / heightScale;
        
        // 如果高度还大于scrollview的高度,那就直接赋值
        if (size.height > superView.boundsHeight)
        {
            size.height = superView.boundsHeight;
        }
       
        oldImgBtn.frame = CGRectMake(0, (superView.boundsHeight - size.height) / 2, size.width, size.height);
    }

    [oldImgBtn setBackgroundImage:image forState:UIControlStateNormal];
    [oldImgBtn setBackgroundImage:image forState:UIControlStateSelected];
    [oldImgBtn setBackgroundImage:image forState:UIControlStateHighlighted];
}

/**
 * 方法描述: 正方形或全屏等比例显示图片，即将图片等比例显示后以正方形进行裁减
 * 输入参数: 图片id,图片存储路径,默认图片,是否圆角,圆角大小,是否改变大小,是否方形或全屏显示
 * 返回值: 无
 * 创建人: 张绍裕
 * 创建时间: 2013-12-25
 */
/*
 * -----------------------------------  BEGIN   --------------------------------------------------
 */
- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize resize:(BOOL)resize square:(BOOL)square delegate:(id<ImageDownloaderDelegate>)delegate
{
    if (resize)
    {
        [self reSetNewImgBtn:placeholder fromOldImgBtn:self square:square];
    }
    else
    {
        [self setBackgroundImage:placeholder forState:UIControlStateNormal];
        [self setBackgroundImage:placeholder forState:UIControlStateSelected];
        [self setBackgroundImage:placeholder forState:UIControlStateHighlighted];
    }
    
    if (imageId)
    {
        NSString *cacheKeyStr = [NSString stringWithFormat:@"%@",imageId];
        
        UIImage *cacheImg = nil;
        
        if (WebImageNotCache != options)
            cacheImg = [[SDImageCache sharedImageCache] imageFromKey:cacheKeyStr fromDisk:options == WebImageDownload ? YES : NO];
        
        if (cacheImg)
        {
            if (isRoundedRect)
            {
                cacheImg = [UIImage createRoundedRectImage:cacheImg roundedRectSize:roundedRectSize];
            }
            if (resize)
            {
                [self reSetNewImgBtn:cacheImg fromOldImgBtn:self square:square];
            }
            else
            {
                [self setBackgroundImage:cacheImg forState:UIControlStateNormal];
                [self setBackgroundImage:cacheImg forState:UIControlStateSelected];
                [self setBackgroundImage:cacheImg forState:UIControlStateHighlighted];
            }
        }
        else
        {
            NSURL *url = nil;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            switch (storeTableType)
            {
                case WebImageStoreTablePic:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"com.ygsoft.omc.base.service.PictureService/getPictureById"];
                    
                    [dic setObject:imageId forKey:@"picId"];//图片ID
                    [dic setObject:[NSNumber numberWithInt:3] forKey:@"picType"];//图片类型(1为低分辨率,2为中分辨率,3为高分辨率)
                }
                    break;
                case WebImageStoreTableFileLittle:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"FileService/getFileByteById"];
                    
                    [dic setObject:imageId forKey:@"fileId"];//图片ID
                }
                    break;
                case WebImageStoreTableFileLarge:
                {
                    url = [UrlManager getRequestUrlByMethodName:@"FileService/downFile"];
                    
                    [dic setObject:imageId forKey:@"fileId"];//图片ID
                }
                    break;
                    
                default:
                    break;
            }
            
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
            [userInfoDic setObject:self forKey:@"btn"];
            [userInfoDic setObject:cacheKeyStr forKey:@"cacheKey"];
            [userInfoDic setObject:[NSNumber numberWithInt:options] forKey: @"options"];
            [userInfoDic setObject:[NSNumber numberWithBool:isRoundedRect] forKey: @"isRoundedRect"];
            [userInfoDic setObject:[NSValue valueWithCGSize:roundedRectSize] forKey: @"roundedRectSize"];
            [userInfoDic setObject:[NSNumber numberWithBool:resize] forKey: @"resize"];
            [userInfoDic setObject:[NSNumber numberWithBool:square] forKey: @"square"];// 多张时方形或单张时全屏显示
            if (delegate)
            {
                [userInfoDic setObject:delegate forKey: @"delegate"]; // 设置协议代理
            }
            
            [[NetRequestManager sharedInstance] sendRequest:url parameterDic:dic requestTag:2000 delegate:self userInfo:userInfoDic];
        }
    }
}

- (void)reSetNewImgBtn:(UIImage *)image fromOldImgBtn:(UIButton *)oldImgBtn square:(BOOL)square
{
    // 只有单张图片且图片高度小于原始默认的图片高度时，会出现加载成功后原始图片叠放在新图片下面的情况，故需移除
    for (UIView *subview in oldImgBtn.subviews)
    {
        if (subview.tag == 3000)
        {
            [subview removeFromSuperview];
            break;
        }
    }
    
    if (!image || !oldImgBtn)
    {
       return;
    }
    
    UIView *superView = oldImgBtn.superview;
    
    // 获取图片原始大小
    CGSize size = image.size;
    
    // 根据父视图大小设置图片大小
    float widthScale = superView.boundsWidth / size.width;
    size.width = superView.boundsWidth;
    size.height = size.height * widthScale;
    
    // 多张图片时，方形显示
    if (square)
    {
        if ((size.width > size.height) && (size.height < superView.boundsHeight))
        {
            float heightScale = superView.boundsHeight / size.height;
            size.height = superView.boundsHeight;
            size.width = size.width * heightScale;
        }
    }
    
    // 改变UIImageView的尺寸，以便于按需显示图片，即方形或全屏
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    [imgView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [imgView setTag:3000];
    // 设置oldImgBtn的图片，并只显示oldImgBtn大小范围内的图片
    [oldImgBtn addSubview:imgView];
    if (!square)
    {
        // 单图时，全屏显示
        // 却掉小数位取整(未取整时整个tableview带有小数，在滚动到最后一行时不会自动加载)
        size.height = [self clearDecimalplacesWithNum:size.height];
        // 限制最大高度
        if (size.height > 145.0)
        {
            size.height = 145.0;
        }
        [oldImgBtn setFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    // 只显示在主视图区域内的图片(多图时，方形显示)
    [oldImgBtn setClipsToBounds:YES];
}

/// 去掉浮点数小数位
- (CGFloat)clearDecimalplacesWithNum:(CGFloat)floatNum
{
    NSMutableString *numString = [NSMutableString stringWithFormat:@"%f",floatNum];
    NSRange range = [numString rangeOfString:@"."];
    if (range.location != NSNotFound)
    {
        numString = (NSMutableString *)[numString substringToIndex:range.location];
    }
    
    return numString.floatValue;
}

/*
 * -----------------------------------  END   --------------------------------------------------
 */

#pragma mark - NetRequestDelegate Methods

// 发生请求成功时
- (void)netRequest:(NetRequest *)request successWithInfoObj:(id)infoObj
{
    // 拿到传过来的参数
    UIButton *btn = [request.userInfo objectForKey:@"btn"];
    NSString *cacheKeyStr = [request.userInfo objectForKey:@"cacheKey"];
    WebImageOptions options = [[request.userInfo objectForKey:@"options"] intValue];
    BOOL isRoundedRect = [[request.userInfo objectForKey:@"isRoundedRect"] boolValue];
    CGSize roundedRectSize = [[request.userInfo objectForKey:@"roundedRectSize"] CGSizeValue];
    BOOL resize = [[request.userInfo objectForKey:@"resize"] boolValue];
    
    // 把下载好的image缓存到内存中,以便下次直接获取,不需要从网上下载
    UIImage *image = [UIImage imageWithData:(NSData *)infoObj];
    
    if (WebImageNotCache != options)
        [[SDImageCache sharedImageCache] storeImage:image forKey:cacheKeyStr toDisk:options == WebImageDownload ? YES : NO];
    
    if (isRoundedRect)
        image = [UIImage createRoundedRectImage:image roundedRectSize:roundedRectSize];
    
    /**
     * 方法描述: 区分是方形显示请求还是其他方式请求
     * 输入参数: 无
     * 返回值: 无
     * 创建人: 张绍裕
     * 创建时间: 2013-12-23
     */
    /*
     * -----------------------------------  BEGIN   --------------------------------------------------
     */
    /*
    if (resize)
        [self setNewImgBtn:image oldImgBtn:btn];
    else
    {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:image forState:UIControlStateSelected];
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    */
    
    if (resize)
    {
        if (request.tag == 2000)
        {
            BOOL isSquare = [[request.userInfo objectForKey:@"square"] boolValue];
            id<ImageDownloaderDelegate> delegate = [request.userInfo objectForKey:@"delegate"];
            
            [self reSetNewImgBtn:image fromOldImgBtn:btn square:isSquare];
            
            if (delegate && [delegate respondsToSelector:@selector(networkImageDidDownload)])
            {
                [delegate networkImageDidDownload];
            }
        }
        else
        {
            [self setNewImgBtn:image oldImgBtn:btn];
        }
    }
    else
    {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:image forState:UIControlStateSelected];
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    /*
     * -----------------------------------  END   --------------------------------------------------
     */
}

// 发送请求失败时
- (void)netRequest:(NetRequest *)request failedWithError:(NSError *)error
{
    // 拿到传过来的参数
    UIButton *btn = [request.userInfo objectForKey:@"btn"];
    
    // begin 张绍裕 20140317
    
    // 加载失败时，先移除加载中的图片，避免图片重叠
    if (2000 == request.tag)
    {
        // 移除原图片
        for (UIView *subView in btn.subviews)
        {
            if ([subView isKindOfClass:[UIImageView class]])
            {
                [(UIImageView *)subView setImage:nil];
            }
        }
    }
    
    // end
    
    [btn setBackgroundImage:[UIImage imageNamed:@"Unify_Image_w2.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unify_Image_w2.png"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"Unify_Image_w2.png"] forState:UIControlStateSelected];
}

@end
