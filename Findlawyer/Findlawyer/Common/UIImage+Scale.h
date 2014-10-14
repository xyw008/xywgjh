//
//  UIImage+Scale.h
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

+ (UIImage *)scaleImage:(UIImage *)originImage withCompressionQuality:(CGFloat)compressionQuality;
+ (UIImage *)scaleImage:(UIImage *)originImage toSize:(CGSize)newSize;
@end
