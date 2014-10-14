//
//  FlaDefinition.m
//  FlashIOSTest
//
//  Created by HJC on 13-1-30.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#import "FlaDefinition.h"
#import "fla_DefineUtils.h"
#import "fla_BinaryReader.h"
#import "fla_DefineRole.h"
#import "fla_transToImage.h"



static fla::DefinePtr readDefine(NSString* path, FlaError** error, CGFloat* frameRate)
{
    fla::BinaryReader reader;
    int code = reader.readFilePath([path UTF8String], true);
    if (code != fla::Code_Success)
    {
        if (error)
        {
            *error = [FlaError errorWithCode:(FlaErrorCode)code];
        }
        return fla::DefinePtr();
    }
    
    if (!reader.root())
    {
        if (error)
        {
            *error = [FlaError errorWithCode:FlaError_NoRootDefine];
        }
    }
    
    if (frameRate)
    {
        *frameRate = reader.frameRate();
    }
    
    return reader.root();
}



@implementation FlaDefinition

- (void) dealloc
{
    if (_impl)
    {
        fla::Define* define = static_cast<fla::Define*>(_impl);
        define->release();
    }
    [super dealloc];
}


- (id) initWithImpl:(void*)impl
{
    if (!impl)
    {
        [self dealloc];
        return nil;
    }
    
    self = [super init];
    if (self)
    {
        _impl = impl;
        fla::Define* define = static_cast<fla::Define*>(_impl);
        define->retain();
        _bounds = CGRectNull;
    }
    return self;
}


- (CGRect) bounds
{
    if (CGRectIsNull(_bounds))
    {
        _bounds = fla::define_computeBounds(*static_cast<fla::Define*>(_impl));
    }
    return _bounds;
}



+ (id) loadFromPath:(NSString*)path error:(FlaError**)error
{
    return [self loadFromPath:path frameRate:NULL error:error];
}


+ (id) loadFromPath:(NSString *)path frameRate:(CGFloat*)frameRate error:(FlaError**)error
{
    fla::DefinePtr root = readDefine(path, error, frameRate);
    if (!root)
    {
        return nil;
    }
    return [[[FlaDefinition alloc] initWithImpl:root.get()] autorelease];
}


- (NSArray*) stateNames
{
    fla::Define* define = static_cast<fla::Define*>(_impl);
    if (!define || define->type() != fla::DefineType_Role)
    {
        return nil;
    }
    
    auto role = static_cast<fla::DefineRole*>(define);
    NSMutableArray* names = [NSMutableArray arrayWithCapacity:role->states().size()];
    for (auto& state : role->states())
    {
        NSString* n = [NSString stringWithCString:state.name().c_str() encoding:NSUTF8StringEncoding];
        [names addObject:n];
    }
    return names;
}


- (FlaDefinition*) stateForName:(NSString*)name
{
    fla::Define* define = static_cast<fla::Define*>(_impl);
    if (!define || define->type() != fla::DefineType_Role)
    {
        return nil;
    }
    
    auto role = static_cast<fla::DefineRole*>(define);
    auto state = role->findDefine([name UTF8String]);
    if (state)
    {
        return [[[FlaDefinition alloc] initWithImpl:state.get()] autorelease];
    }
    return nil;
}


- (FlaDefinition*) stateForIndex:(NSInteger)index
{
    fla::Define* define = static_cast<fla::Define*>(_impl);
    if (!define || define->type() != fla::DefineType_Role)
    {
        return nil;
    }
    
    auto role = static_cast<fla::DefineRole*>(define);
    auto state = role->states()[index].define();
    if (state)
    {
        return [[[FlaDefinition alloc] initWithImpl:state.get()] autorelease];
    }
    return nil;
}


#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

// 转换成图片
// scale，       图片的缩放比例，比如原图是250 * 250, 缩放比设置为2, 载入的图片就变为 500 * 500
// enableRetina, 是否禁用高清
- (UIImage*) transToImage
{
    return [self transToImageScale:1 enableRetinaDisplay:YES];
}


- (UIImage*) transToImageScale:(CGFloat)scale
{
    return [self transToImageScale:scale enableRetinaDisplay:YES];
}


- (UIImage*) transToImageScale:(CGFloat)scale enableRetinaDisplay:(BOOL)enableRetina
{
    CGFloat retinaScale = 1.0;
    if (enableRetina)
    {
        retinaScale = [UIScreen mainScreen].scale;
    }
    
    fla::Define* define = static_cast<fla::Define*>(_impl);
    auto imageHolder = fla::define_transToImage(*define, scale * retinaScale);
    UIImage* image = [UIImage imageWithCGImage:imageHolder.get()
                                         scale:retinaScale
                                   orientation:UIImageOrientationUp];
    return image;
}

#endif


@end
