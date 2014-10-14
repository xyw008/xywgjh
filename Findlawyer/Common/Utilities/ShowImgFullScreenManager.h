//
//  ShowImgFullScreenManager.h
//  zmt
//
//  Created by gongjunhui on 13-7-15.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowImgFullScreenManager : NSObject

/**
 * 方法描述: 全屏展示网络图片数组(用ID加载)
 * 输入参数: 图片ID数组
 * 返回值: UIScrollView
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (UIScrollView *)showImgFullScreenWithImgIds:(NSArray *)ImgIdsArray;

/**
 * 方法描述: 全屏展示网络图片数组(用URL加载)
 * 输入参数: 图片URL数组
 * 返回值: UIScrollView
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (UIScrollView *)showImgFullScreenWithImgUrls:(NSArray *)ImgUrlsArray;

@end
