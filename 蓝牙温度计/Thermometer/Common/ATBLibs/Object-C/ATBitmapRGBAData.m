//
//  BitmapRGBA8Data.m
//  iOSUtils
//
//  Created by HJC on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBitmapRGBAData.h"


////////////////////////////////////////


static CGContextRef _NewBitmapRGBA8Context(void* bytes, size_t width, size_t height)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate((void*)bytes,
                                                 width,
                                                 height,
                                                 8,
                                                 width * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    return context;
}



//////////////////////////////////
@implementation ATBitmapRGBAData
@synthesize width = _width;
@synthesize height = _height;
@synthesize pixels = _pixels;


- (void) dealloc
{
    free(_pixels);
//    [super dealloc];
}



+ (id) dataWithCGImage:(CGImageRef)imageRef
{
    return [[self alloc] initWithCGImage:imageRef];
}


+ (id) dataWithBitmapData:(ATBitmapRGBAData*)data
{
    return [[self alloc] initWithBitmapData:data];
}



- (id) initWithCGImage:(CGImageRef)imageRef
{
    self = [super init];
    if (self)
    {
        _width = CGImageGetWidth(imageRef);
        _height = CGImageGetHeight(imageRef);
        NSInteger bytesLength = _width * _height * 4;
        _pixels = (unsigned int*)malloc(bytesLength);
        memset(_pixels, 0, bytesLength);
        
        CGContextRef context = _NewBitmapRGBA8Context(_pixels, _width, _height);
        CGRect drawRect = CGRectMake(0, 0, _width, _height);
        CGContextDrawImage(context, drawRect, imageRef);
        CGContextRelease(context);
    }
    return self;
}



- (CGContextRef) beginDraw
{
    return _NewBitmapRGBA8Context(_pixels, _width, _height);
}


- (void) endDraw:(CGContextRef)context
{
    CGContextRelease(context);
}


- (id)  initWithWidth:(NSInteger)width height:(NSInteger)height
{
    self = [super init];
    if (self)
    {
        _width = width;
        _height = height;
        NSInteger bytesLength = _width * _height * 4;
         _pixels = (unsigned int*)malloc(bytesLength);
        memset(_pixels, 0, bytesLength);
    }
    return self;
}


- (id) initWithBitmapData:(ATBitmapRGBAData*)data
{
    self = [super init];
    if (self)
    {
        _width = data->_width;
        _height = data->_height;
        NSInteger bytesLength = _width * _height * 4;
        _pixels = (unsigned int*)malloc(bytesLength);
        memcpy(_pixels, data->_pixels, bytesLength);
    }
    return self;
}


static void ImageDataReleaseCallback(void *info, const void *data, size_t size)
{
    free((void*)data);
}



- (CGImageRef) createImageRefCopyData:(BOOL)copyData
{
    void* buffer = _pixels;
    NSInteger bufferLength = _width * _height * 4;
    CGDataProviderReleaseDataCallback releaseDataCallBack = NULL;
    
    // 需要复制多一份数据
    if (copyData)
    {
        buffer = malloc(bufferLength);
        memcpy(buffer, _pixels, bufferLength);
        releaseDataCallBack = ImageDataReleaseCallback;
    }
    
    // 设置Bitmap信息
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, releaseDataCallBack);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * _width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = (kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // 创建Bitmap图片
    CGImageRef imageRef = CGImageCreate(_width, 
                                        _height, 
                                        bitsPerComponent, 
                                        bitsPerPixel, 
                                        bytesPerRow, 
                                        colorSpaceRef, 
                                        bitmapInfo, 
                                        provider, 
                                        NULL, 
                                        NO, 
                                        renderingIntent);
	
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    return imageRef;
}


- (UIImage*) convertToImageCopyData:(BOOL)copyData
{
    CGImageRef imageRef = [self createImageRefCopyData:copyData];
    UIImage* image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}



- (void) clearWithColor:(ATRGBA8)color
{
    unsigned int uint = UintFromRGBAColor(color);
    unsigned int* ptr = _pixels;
    unsigned int* endPtr = ptr + _width * _height;
    
    while (ptr != endPtr)
    {
        *ptr = uint;
        ptr++;
    }
}


- (ATRGBA8) colorAtPosX:(NSInteger)x posY:(NSInteger)y
{
    if (x < 0 || x >= _width || y < 0 || y >= _height)
    {
        return RGBAColorFromUint(0);
    }
    return RGBAColorFromUint(_pixels[_width * y + x]);
}



- (void) setColor:(ATRGBA8)color atPosX:(NSInteger)x posY:(NSInteger)y
{
    if (x < 0 || x >= _width || y < 0 || y >= _height)
    {
        return;
    }
    
    _pixels[_width * y + x] = UintFromRGBAColor(color);
}



- (ATRGBA8) colorAtPos:(CGPoint)pt
{
    return [self colorAtPosX:pt.x posY:pt.y];
}


- (void)      setColor:(ATRGBA8)color atPos:(CGPoint)pt
{
    [self setColor:color atPosX:pt.x posY:pt.y];
}



static unsigned int _changeHue(unsigned int color, CGFloat newHue)
{
    RGBAColorUnion u;
    u.uint = color;
    
    float red = u.color.red;
    float green =  u.color.green;
    float blue =  u.color.blue;
    
    float maxC = red;
    float minC = green;
    if (red < green)
    {
        maxC = green;
        minC = red;
    }
    
    if (maxC < blue)
    {
        maxC = blue;
    }
    else if (minC > blue)
    {
        minC = blue;
    }
    float saturation = (maxC - minC) / maxC;
    float brightness = maxC;
    
    ////////////////////////    
    float hDiv60 = newHue / 60;
    int caseH = (int)hDiv60 % 6;
    
    float f = hDiv60 - caseH;
    
    switch (caseH)
    {
        case 0:
        {
            u.color.red = brightness;
            u.color.green = brightness * (1.0f - saturation * (1.0f - f));
            u.color.blue = brightness * (1.0f - saturation);
        }
            break;
            
        case 1:
        {
            u.color.red = brightness * (1.0f - saturation * f);
            u.color.green = brightness;
            u.color.blue = brightness * (1.0f - saturation);
        }
            break;
            
        case 2:
        {
            u.color.red = brightness * (1.0f - saturation);
            u.color.green = brightness;
            u.color.blue = brightness * (1.0f - saturation * (1.0f - f));
        }
            break;
            
        case 3:
        {
            u.color.red = brightness * (1.0f - saturation);
            u.color.green = brightness * (1.0f - saturation * f);
            u.color.blue = brightness;
        }
            break;
            
        case 4:
        {
            u.color.red = brightness * (1.0f - saturation * (1.0f - f));
            u.color.green = brightness * (1.0f - saturation);
            u.color.blue = brightness;
        }
            break;
            
        case 5:
        {
            u.color.red = brightness;
            u.color.green = brightness * (1.0f - saturation);
            u.color.blue = brightness * (1.0f - saturation * f);
        }
            break;
    }
    
    return u.uint;
}




- (void) changeHue:(CGFloat)newHue
{
    unsigned int* ptr = _pixels;
    unsigned int* endPtr = ptr + _width * _height;
    while (ptr != endPtr)
    {
        *ptr = _changeHue(*ptr, newHue);
        ptr++;
    }
}



- (void) makeGray
{
    unsigned int* ptr = _pixels;
    unsigned int* endPtr = ptr + _width * _height;
    
    RGBAColorUnion u;
    while (ptr != endPtr)
    {
        u.uint = *ptr;
        uint32_t gray = 0.3 * u.color.red + 0.59 * u.color.green + 0.11 * u.color.blue;
        u.color.red = gray;
        u.color.blue = gray;
        u.color.green = gray;
        *ptr = u.uint;
        ptr++;
    }
}


- (ATBitmapRGBAData*) bitmapDataWithRect:(CGRect)rect
{
    CGImageRef imageRef = [self createImageRefCopyData:NO];
    CGImageRef otherRef = CGImageCreateWithImageInRect(imageRef, rect);
    
    ATBitmapRGBAData* data = [[ATBitmapRGBAData alloc] initWithCGImage:otherRef];
    
    CGImageRelease(imageRef);
    CGImageRelease(otherRef);
    
    return data;
}


- (CGRect) opaqueBounds
{
    CGPoint minPt = CGPointZero;
    CGPoint maxPt = CGPointZero;
    BOOL firstTime = YES;
    
    for (int x = 0; x < _width; x++)
    {
        for (int y = 0; y < _height; y++)
        {
            ATRGBA8 color = RGBAColorFromUint(_pixels[_width * y + x]);
            if (color.alpha != 0)
            {
                if (firstTime)
                {
                    minPt.x = maxPt.x = x;
                    minPt.y = maxPt.y = y;
                }
                else
                {
                    minPt.x = MIN(minPt.x, x);
                    minPt.y = MIN(minPt.y, y);
                    maxPt.x = MAX(maxPt.x, x);
                    maxPt.y = MAX(maxPt.y, y);
                }
                firstTime = NO;
            }
        }
    }
    
    return CGRectMake(minPt.x, minPt.y, maxPt.x - minPt.x + 1, maxPt.y - minPt.y + 1);
}


@end
