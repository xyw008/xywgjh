//
//  FlaReader.m
//  SDKiOSLayerTest
//
//  Created by HJC on 12-11-22.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import "FlaReader.h"
#import "FlaDefinition.h"


@implementation FlaReader

static BOOL s_enableRetina = YES;
static CGFloat s_scale = 1.0;


+ (void) enableRetinaDisplay:(BOOL)enableRetina
{
    @synchronized(self)
    {
        s_enableRetina = enableRetina;
    }
}


+ (void) setScale:(CGFloat)scale
{
    @synchronized(self)
    {
        s_scale = scale;
    }
}



#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

+ (CGFloat) _retinaScale
{
    BOOL enableRetina = YES;
    @synchronized(self)
    {
        enableRetina = s_enableRetina;
    }
    
    CGFloat scale = 1.0;
    if (s_enableRetina)
    {
        scale = [UIScreen mainScreen].scale;
    }
    return scale;
}



+ (CGFloat) _imageScale
{
    @synchronized(self)
    {
        return s_scale;
    }
    return 1.0f;
}



+ (UIImage*) readImagePath:(NSString*)path error:(FlaError**)error
{
    FlaDefinition* define = [FlaDefinition loadFromPath:path error:error];
    if (define)
    {
        CGFloat scale = 1;
        BOOL    enableRetina = TRUE;
        @synchronized(self)
        {
            scale = s_scale;
            enableRetina = s_enableRetina;
        }
        return [define transToImageScale:scale enableRetinaDisplay:enableRetina];
    }
    return nil;
}


#endif

@end
