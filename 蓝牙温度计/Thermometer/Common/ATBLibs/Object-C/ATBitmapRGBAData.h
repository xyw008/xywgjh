//
//  BitmapRGBA8Data.h
//  iOSUtils
//
//  Created by HJC on 11-9-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


// 颜色结构, 各分量在0到255之间
typedef struct
{
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
} ATRGBA8;



typedef union
{
    ATRGBA8       color;
    unsigned int    uint;
} RGBAColorUnion;


// 颜色结构和整数之间的转换
inline static unsigned int UintFromRGBAColor(ATRGBA8 color)
{
    RGBAColorUnion u;
    u.color = color;
    return u.uint;
}

inline static ATRGBA8 RGBAColorFromUint(unsigned int uint)
{
    RGBAColorUnion u;
    u.uint = uint;
    return u.color;
}


////////////////////////////////
// 可以使用此类，将UIImage转成bitmap数据点，之后就可以直接操作颜色数据
// 比如判断某点颜色是否透明等
@interface ATBitmapRGBAData : NSObject 
{
@private
    unsigned int*       _pixels;
    NSInteger           _width;
    NSInteger           _height;
}
@property (nonatomic, readonly) unsigned int*   pixels; // 原始的数据点
@property (nonatomic, readonly) NSInteger       width;
@property (nonatomic, readonly) NSInteger       height;

+ (id) dataWithCGImage:(CGImageRef)imageRef;
+ (id) dataWithBitmapData:(ATBitmapRGBAData*)data;

- (id)  initWithCGImage:(CGImageRef)imageRef;
- (id)  initWithBitmapData:(ATBitmapRGBAData*)data;
- (id)  initWithWidth:(NSInteger)width height:(NSInteger)height;


- (CGContextRef) beginDraw;
- (void) endDraw:(CGContextRef)context;

// 转成图片，copyData表示是否需要复制一份数据点
// 有时候并不需要复制数据点的，比如转成图片用于绘画
- (UIImage*) convertToImageCopyData:(BOOL)copyData;
- (CGImageRef) createImageRefCopyData:(BOOL)copyData;

// 取得对应位置的颜色值
- (ATRGBA8) colorAtPosX:(NSInteger)x posY:(NSInteger)posY;
- (ATRGBA8) colorAtPos:(CGPoint)pt;

- (void) setColor:(ATRGBA8)color atPos:(CGPoint)pt;
- (void) setColor:(ATRGBA8)color atPosX:(NSInteger)x posY:(NSInteger)posY;

// 清除颜色
- (void) clearWithColor:(ATRGBA8)color;

// 改变色相
- (void) changeHue:(CGFloat)newHue;

// 转成灰度
- (void) makeGray;


- (ATBitmapRGBAData*) bitmapDataWithRect:(CGRect)rect;

// 不透明的矩形
- (CGRect)            opaqueBounds;

@end
