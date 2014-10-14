//
//  AppSmallUtils.m
//  PaintingBoard
//
//  Created by HJC on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppSmallUtils.h"
#import "Reachability.h"
#import "ATBitmapRGBAData.h"

CGAffineTransform CGRectTansformFrom(CGRect rect, CGRect fromRect)
{
    CGPoint pt0 = CGRectGetMiddle(rect);
    CGPoint pt1 = CGRectGetMiddle(fromRect);
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(pt1.x - pt0.x, pt1.y - pt0.y);
    CGFloat scaleX = CGRectGetWidth(fromRect) / CGRectGetWidth(rect);
    CGFloat scaleY = CGRectGetHeight(fromRect) / CGRectGetHeight(rect);
    
    trans = CGAffineTransformScale(trans, scaleX, scaleY);
    
    return trans;
}

BOOL isExistNetwork(void)
{
    BOOL isExistenceNetwork = FALSE;
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([r currentReachabilityStatus]) 
    {
        case NotReachable:
            isExistenceNetwork=FALSE;
            break;
            
        case ReachableViaWWAN:
            isExistenceNetwork=TRUE;
            break;
            
        case ReachableViaWiFi:
            isExistenceNetwork=TRUE;     
            break;
    }
    return isExistenceNetwork;
}






unsigned int ColorIntFromString(NSString* str)
{
    UIColor* color = [UIColor colorFromString:str];
    CGFloat red = 0, green = 0, blue = 0, alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    ATRGBA8 rgba;
    rgba.red = MIN(255, red * 255);
    rgba.green = MIN(255, green * 255);
    rgba.blue = MIN(255, blue * 255);
    rgba.alpha = MIN(255, alpha * 255);
    
    return UintFromRGBAColor(rgba);
}


NSString*  ColorStringFromInt(unsigned int color)
{
    ATRGBA8 rgba = RGBAColorFromUint(color);
	return [NSString stringWithFormat:
			@"#%02X%02X%02X", rgba.red, rgba.green, rgba.blue];	
}

///////////////////////////////
@implementation AppCommonTool

+ (NSString *) systemLanguage
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray	*languagesArr = [userDefault objectForKey:@"AppleLanguages"];
    if (languagesArr && [languagesArr count]>0)
    {
        NSString *languageStr = [languagesArr objectAtIndex:0];
        if([languageStr isEqualToString:@"en"])
            return @"en";
        else if([languageStr isEqualToString:@"zh-Hans"])
            return @"sn";
        else if([languageStr isEqualToString:@"zh-Hant"])
            return @"cn";
    }
    return @"en";
}


+ (void) _animationWarningNullText:(UIView*)view loopNum:(NSInteger)loopNum
{
    if (loopNum == 0)
    {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^(void)
     {
         if (loopNum%2 == 0)
         {
             view.backgroundColor = [[UIColor alloc] initWithRed:1.0
                                                            green:187.0 / 255.0
                                                             blue:187.0 / 255.0 
                                                            alpha:1.0];
         }
         else 
         {
             view.backgroundColor = [UIColor clearColor];
         }
     } completion:^(BOOL finished)
     {
         [AppCommonTool _animationWarningNullText:view loopNum:(loopNum - 1)];
     }
     ];
}

+ (void) warningNullText:(UIView*)view
{
    [AppCommonTool _animationWarningNullText:view loopNum:4];
}

@end

///////////////////////////////



@implementation UIView(_iOSUtils_Addtions)

- (UIButton*) buttonWithTouchUpInsideAction:(SEL)action
{
    for (UIButton* bt in self.subviews)
    {
        if ([bt isKindOfClass:[UIButton class]])
        {
            NSArray* array = [bt actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
            NSString* string = [array count] > 0 ? [array objectAtIndex:0] : nil;
            if (action == NSSelectorFromString(string))
            {
                return bt;
            }
        }
    }
    return nil;
}


- (UIButton*) buttonWithTag:(NSInteger)tag
{
    for (UIButton* bt in self.subviews)
    {
        if ([bt isKindOfClass:[UIButton class]])
        {
            if (bt.tag == tag)
            {
                return bt;
            }
        }
    }
    return nil;
}



@end

///////////////////////////////

@implementation UILabel (Lable_Height)

- (CGFloat)labelHeight
{
    return [self labelText:self.text width:self.width defaultHeight:self.height];
}

- (CGFloat)labelText:(NSString *)text width:(CGFloat)width defaultHeight:(CGFloat)height
{
    return [UILabel labelText:text width:width defaultHeight:height font:self.font];
}

+ (CGFloat)labelText:(NSString *)text width:(CGFloat)width defaultHeight:(CGFloat)height font:(UIFont *)font
{
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, height);
}

@end


///////////////////////////////

@implementation UIImage(_iOSUtils_Addtions)


- (NSArray*) imagesBySplitingColumn:(NSInteger)column row:(NSInteger)row
{
    NSMutableArray* images = [NSMutableArray array];
    
    CGFloat width = self.size.width / column;
    CGFloat height = self.size.height / row;
    
    for (int i = 0; i < row; i++) 
    {
        for (int j = 0; j < column; j++) 
        {
            CGRect rect = CGRectMake(j * width, i * height, width, height);
            UIImage* img = [self imageInRect:rect];
            [images addObject:img];
        }
    }
    
    return images;
}

@end


@implementation UIImageView (Image_Animation)

- (void) setImage:(UIImage *)image animation:(BOOL)animation
{
    self.alpha = 0.0f;
    self.image = image;
    [UIView animateWithDuration:0.5 animations:^(void){
        self.alpha = 1.0f;
    }];
}

@end


/////////////////////////////////////////////////////////////
@implementation UIView (Color_Point)

- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end


/////////////////////////////////////////////////////////////
@implementation UIImage (Color_Change)

- (UIImage*)changeImageWithColor:(UIColor*)color
{
	UIGraphicsBeginImageContext(self.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, self.CGImage);
    
    [color set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, self.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end


///////////////////////////////////////////////////////////////////////////
@implementation UIImage (Blur)
/*
- (UIImage *)boxblurImageWithBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 50);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        //perform convolution
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
*/
@end


/////////////////////////////////////////////////////////////
@implementation NSString(Network_Decode)
- (NSString*) networkDecode
{
    return [[self URLDecodedString] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
}

@end

/////////////////////////////////////////////////////////////
@implementation NSString(TimeStamp_Date)

- (NSDate*) ymdToDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [dateFormatter dateFromString:self];
    return dateFromString;
}

+ (NSString*) nowDateForFormat:(NSString*)format
{
    NSDate* date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format]; // @"yyyy-MM-dd HH:mm:ss"
    return [dateFormatter stringFromDate:date];
}

@end



