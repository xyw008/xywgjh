//
//  UIButton+Cache.h.h
//  zmt
//
//  Created by admin on 13-4-16.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestManager.h"
#import "SDImageCache.h"

typedef enum
{   /// 缓存到内存
    WebImageCacheMemoryOnly,
    /// 缓存到磁盘
    WebImageDownload,
    /// 不做缓存
    WebImageNotCache
    
} WebImageOptions;

//图片储存到数据库里表的类型
typedef enum
{
    WebImageStoreTablePic, //图片表
    WebImageStoreTableFileLittle, //附件表,小体积类型(大体积和小体积的请求接口又不一样)
    WebImageStoreTableFileLarge, //附件表,大体积类型
    
} WebImageStoreTableType;

/**
 * 方法描述: 设置协议，用于加载完成图片时刷新表视图
 * 输入参数: 无
 * 返回值: 无
 * 创建人: 张绍裕
 * 创建时间: 2013-12-30
 */
/*
 * -----------------------------------  BEGIN   --------------------------------------------------
 */
@protocol ImageDownloaderDelegate;
/*
 * -----------------------------------  END   --------------------------------------------------
 */

@interface UIButton (Cache) <NetRequestDelegate>

/// 异步加载btn网络图片
- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options;

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options resize:(BOOL)resize;

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize;

- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize resize:(BOOL)resize;

/// 根据图片尺寸重设btn的大小
- (void)setNewImgBtn:(UIImage *)image oldImgBtn:(UIButton *)oldImgBtn;

/// 取消图片下载
- (void)cancelCurrentImageLoad;

/**
 * 方法描述: 正方形，即将图片等比例显示后以正方形进行裁减，或全屏等比例显示图片
 * 输入参数: 图片id,图片存储路径,默认图片,是否圆角,圆角大小,是否改变大小,是否方形或全屏显示
 * 返回值: 无
 * 创建人: 张绍裕
 * 创建时间: 2013-12-25
 */
/*
 * -----------------------------------  BEGIN   --------------------------------------------------
 */
- (void)setBackgroundImageWithImageId:(NSNumber *)imageId storeTableType:(WebImageStoreTableType)storeTableType placeholderImage:(UIImage *)placeholder options:(WebImageOptions)options isRoundedRect:(BOOL)isRoundedRect roundedRectSize:(CGSize)roundedRectSize resize:(BOOL)resize square:(BOOL)square delegate:(id<ImageDownloaderDelegate>)delegate;

- (void)reSetNewImgBtn:(UIImage *)image fromOldImgBtn:(UIButton *)oldImgBtn square:(BOOL)square;
/*
 * -----------------------------------  END   --------------------------------------------------
 */

@end

/**
 * 方法描述: 设置协议，用于加载完成图片时刷新表视图
 * 输入参数: 无
 * 返回值: 无
 * 创建人: 张绍裕
 * 创建时间: 2013-12-30
 */
/*
 * -----------------------------------  BEGIN   --------------------------------------------------
 */
@protocol ImageDownloaderDelegate <NSObject>

/**
 * 方法描述: 设置协议，用于加载完成图片时刷新表视图
 * 输入参数: 无
 * 返回值: 无
 * 创建人: 张绍裕
 * 创建时间: 2013-12-30
 */
- (void)networkImageDidDownload;

@end
/*
 * -----------------------------------  BEGIN   --------------------------------------------------
 */
