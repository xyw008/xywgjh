//
//  UIImage+Scale.m
//  ECiOS
//
//  Created by qinwenzhou on 14-1-5.
//  Copyright (c) 2014年 qwz. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage (Scale)

+ (UIImage *)scaleImage:(UIImage *)originImage toSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [originImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)originImage toNewSize:(CGFloat)newSize
{
    // Set the scale size by origin image.
    CGFloat originSize = MAX(originImage.size.width, originImage.size.height);
    CGFloat scaleToSize = MIN(newSize, originSize);
    CGFloat w = originImage.size.width  * scaleToSize / originSize;
    CGFloat h = originImage.size.height * scaleToSize / originSize;
    
    if (originImage.size.width < scaleToSize && originImage.size.height < scaleToSize)
    {
        w = originImage.size.width;
        h = originImage.size.height;
    }
    
    // Scale.
    return [UIImage scaleImage:originImage toSize:CGSizeMake(w, h)];
}

+ (UIImage *)scaleImage:(UIImage *)originImage withCompressionQuality:(CGFloat)compressionQuality
{
    NSData *compressedData = UIImageJPEGRepresentation(originImage, compressionQuality);
    return [UIImage imageWithData:compressedData];
}

@end
