//
//  ShowImgFullScreenManager.h
//  zmt
//
//  Created by gongjunhui on 13-7-15.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowLocalImgFullScreenManager : NSObject

/**
 * 方法描述: 全屏展示本地图片数组
 * 输入参数: 图片源数组,是否重设尺寸,是否多手势缩放
 * 返回值: UIScrollView
 * 创建人: 龚俊慧
 * 创建时间: 2013-11-27
 */
+ (UIScrollView *)showLocalImgFullScreenWithImgSource:(NSArray *)localImgsSourceArray resize:(BOOL)resize canZoom:(BOOL)canZoom;

@end
