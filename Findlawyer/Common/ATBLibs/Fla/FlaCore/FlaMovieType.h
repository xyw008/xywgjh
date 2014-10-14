//
//  FlaMovieType.h
//  SceneEditor
//
//  Created by HJC on 13-1-9.
//  Copyright (c) 2013年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlaError.h"


typedef enum
{
    FlaMovieType_Null           = 0,        // 空定义
    FlaMovieType_Image          = 1,        // 图片
    FlaMovieType_Shape          = 2,        // 形状
    FlaMovieType_MorphShape     = 3,        // 形变
    FlaMovieType_Sprite         = 4,        // 动画
    FlaMovieType_Scene          = 5,        // 场景
    FlaMovieType_Role           = 6,        // 角色
    FlaMovieType_Font           = 7,        // 字体
    FlaMovieType_Text           = 8,        // 文字
} FlaMovieType;



@protocol FlaMovieInterface <NSObject>

// 从文件中载入影片，并返回帧率，frameRate表示1秒钟应该播放多少帧
+ (id) layerWithPath:(NSString*)filePath frameRate:(CGFloat*)frameRate error:(FlaError**)error;
+ (id) layerWithPath:(NSString*)filePath scale:(CGFloat)scale frameRate:(CGFloat*)frameRate error:(FlaError**)error;

- (void) stepFrame;
- (void) renderFrame;

- (void) gotoFirstFrame;

@end