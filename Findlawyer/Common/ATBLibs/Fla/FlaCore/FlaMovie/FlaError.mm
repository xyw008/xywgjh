//
//  FlaError.m
//  SceneEditor
//
//  Created by HJC on 12-12-17.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import "FlaError.h"
#import "fla_Error.h"


@implementation FlaError


- (id) init
{
    return [self initWithCode:FlaErrorCode_Success];
}


- (id) initWithCode:(FlaErrorCode)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}


+ (id) errorWithCode:(FlaErrorCode)code
{
    return [[[self alloc] initWithCode:code] autorelease];
}


- (NSString*) description
{
    if (_code == FlaError_NoRootDefine)
    {
        return @"no root define";
    }
    
    std::string desc = fla::descriptionFromCode((fla::ErrorCode)_code);
    return [NSString stringWithUTF8String:desc.c_str()];
}


@end
