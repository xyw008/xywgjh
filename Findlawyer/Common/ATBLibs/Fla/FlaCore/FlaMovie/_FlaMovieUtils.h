//
//  _FlaMovieUtils.h
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fla_Define.h"



@class FlaError;
@interface _FlaMovieUtils : NSObject
{
}

+ (fla::DefinePtr) loadDefine:(NSString*)filePath frameRate:(CGFloat*)frameRate error:(FlaError**) error;

@end
