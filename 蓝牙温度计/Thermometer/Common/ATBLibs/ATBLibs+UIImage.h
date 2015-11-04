//
//  ATBLibs+UIImage.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(ATBLibsAddtions)

//给图片加圆角
+ (id)createRoundedRectImage:(UIImage*)image roundedRectSize:(CGSize)roundedRectSize;

// 将图片转称位图模式
- (UIImage*) transToBitmapImage;
- (UIImage*) transToBitmapImageWithSize:(CGSize)size;

//改变图片大小
- (UIImage *)resize:(CGSize)newSize;

// 将图片转称灰度图
- (UIImage*) transToGrayImage;


// 从名字读入图片
+ (UIImage*) imageNamed:(NSString *)name useCache:(BOOL)useCache;


// 生成一副单色的图片
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor*)color size:(CGSize)size;


- (UIImage*) imageInRect:(CGRect)rect;



// 一张图片，单独保留绘画的部分
- (UIImage*) imageByKeepingDrawBlock:(void(^)(CGContextRef context, CGRect rect))block;


// 一张图片，清除掉绘画的部分
- (UIImage*) imageByClearingDrawBlock:(void(^)(CGContextRef context, CGRect rect))block;


@end
