//
//  FlaDefinition.h
//  FlashIOSTest
//
//  Created by HJC on 13-1-30.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlaError.h"


//////////////////////////////////////////////////////////////////////

@interface FlaDefinition : NSObject
{
@private
    void*   _impl;
    CGRect  _bounds;
}
@property (nonatomic, readonly) CGRect      bounds; // 大小
@property (nonatomic, readonly) void*       impl;   // 内部使用
@property (nonatomic, readonly) NSArray*    stateNames;

// 内部实现时候使用
- (id) initWithImpl:(void*)impl;

// 从文件中载入
+ (id) loadFromPath:(NSString*)path error:(FlaError**)error;
+ (id) loadFromPath:(NSString *)path frameRate:(CGFloat*)frameRate error:(FlaError**)error;

// 不是角色返回null
- (FlaDefinition*) stateForName:(NSString*)name;
- (FlaDefinition*) stateForIndex:(NSInteger)index;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

// 转换成图片
// scale，       图片的缩放比例，比如原图是250 * 250, 缩放比设置为2, 载入的图片就变为 500 * 500
// enableRetina, 是否使用高清
- (UIImage*) transToImage;
- (UIImage*) transToImageScale:(CGFloat)scale;
- (UIImage*) transToImageScale:(CGFloat)scale enableRetinaDisplay:(BOOL)enableRetina;

#endif

@end
