//
//  FlaReader.h
//  SDKiOSLayerTest
//
//  Created by HJC on 12-11-22.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlaError.h"


//////////////////////////////////////////////////////////////////////
@interface FlaReader : NSObject
{
}

// 是否使用高清, 默认为YES
+ (void) enableRetinaDisplay:(BOOL)enableRetina;


// 装入图片的缩放比例，默认为1.0
+ (void) setScale:(CGFloat)scale;


#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

// 如果设置了useRetina，会读取高清图
+ (UIImage*) readImagePath:(NSString*)path error:(FlaError**)error;


#endif


@end


