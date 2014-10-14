//
//  _FlaMovieUtils.m
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#import "_FlaMovieUtils.h"
#import "FlaError.h"
#import "fla_BinaryReader.h"



@implementation _FlaMovieUtils


+ (fla::DefinePtr) loadDefine:(NSString*)filePath frameRate:(CGFloat*)frameRate error:(FlaError**) error
{
    fla::BinaryReader reader;
    auto errorCode = reader.readFilePath([filePath UTF8String], false);
    
    if (errorCode != fla::Code_Success)
    {
        if (error)
        {
            *error = [FlaError errorWithCode:(FlaErrorCode)errorCode];
        }
        return fla::DefinePtr();
    }
    
    if (frameRate)
    {
        *frameRate = reader.frameRate();
    }
    
    auto root = reader.root();
    if (!root)
    {
        if (error)
        {
            *error = [FlaError errorWithCode:FlaError_NoRootDefine];
        }
    }
    return root;
}


@end
