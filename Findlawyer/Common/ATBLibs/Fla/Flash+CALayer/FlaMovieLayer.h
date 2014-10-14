//
//  FlaMovieLayer.h
//  FlashExporter
//
//  Created by HJC on 12-9-25.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "FlaError.h"
#import "FlaMovieType.h"
#import "FlaDefinition.h"

////////////////////////////////////////////////////////////////////////////////
// 当影片播放完之后会收到通知，包括子movie
// 比如 movie A 有两帧，movie A 包含子movie B, B有十帧，所以2帧之后，会收到A的通知，
// 十帧之后会收到B的通知
@class FlaMovieLayer;
@protocol FlaMovieLayerDelegate <NSObject>
@optional
- (void) FlaMovieLayerDidFinishMovie:(FlaMovieLayer*)layer;
@end


/* 
 如果是角色，可能有多个状态
 */
@class __FlaMovieImpl;
@interface FlaMovieLayer : CALayer<FlaMovieInterface>
{
@private
    __FlaMovieImpl*             _impl;
    NSInteger                   _curFrame;
    CGFloat                     _movieScale;
    CGFloat                     _ratio;             //! 用于支持形变
    id<FlaMovieLayerDelegate>   _movieDelegate;
    NSMutableArray*             _subMoviewLayers;
}
@property (nonatomic, assign)   FlaDefinition*    definition;
@property (nonatomic, assign)   CGFloat           movieScale;
@property (nonatomic, assign)   id                movieDelegate;
@property (nonatomic, assign)   BOOL              ignoreAutoStepFrame;  // 上一层调用stepframe的时候，是否也调用stepframe
@property (nonatomic, readonly) FlaMovieType      movieType;
@property (nonatomic, readonly) NSString*         movieName;        // 定义的名字
@property (nonatomic, readonly) NSString*         stateName;        // 状态的名字
@property (nonatomic, assign)   CGPoint           centerPoint;      // 中心点
@property (nonatomic, readonly) CGSize            movieSize;        // 大小


// 从文件中载入影片，并返回帧率，frameRate表示1秒钟应该播放多少帧
+ (id) layerWithPath:(NSString*)filePath frameRate:(CGFloat*)frameRate error:(FlaError**)error;
+ (id) layerWithPath:(NSString*)filePath scale:(CGFloat)scale frameRate:(CGFloat*)frameRate error:(FlaError**)error;


- (id) initWithDefinition:(FlaDefinition*)define scale:(CGFloat)scale;
- (id) initWithDefinition:(FlaDefinition*)define;

+ (id) layerWithDefinition:(FlaDefinition*)define scale:(CGFloat)scale;
+ (id) layerWithDefinition:(FlaDefinition*)define;


// 进入下一帧
- (void) stepFrame;


- (void) renderFrame;


// 切换到第一帧
- (void) gotoFirstFrame;


// 改变角色的状态
- (BOOL) changeState:(NSString*)state;
- (BOOL) changeStateIndex:(NSInteger)index;


// 点击测试
- (CALayer*) hitTest:(CGPoint)p;


@end



//////////////////////////////////////////////////////////////////////////////


@interface CALayer(FlaMovieLayerFinder)

/*
 查找 superlayer，包括自身和，superlayer的superlayer, 找到第一个就会停止,
 比如通过名字查找
 A(名字为a), B(名字为b), C(名字为c)， 其中 A包含B, B包含C
 这样 C调用
 findSuperMovieLayer:^BOOL(FlaMovieLayer* layer)
 {
 return [layer.name isEqualToString:@"a"];
 }，
 返回A图层，
 
 调用
 
 findSuperMovieLayer:^BOOL(FlaMovieLayer* layer)
 {
 return [layer.name isEqualToString:@"c"];
 }，
 返回C图层，
 */
- (FlaMovieLayer*) findSuperMovieLayer:(BOOL(^)(FlaMovieLayer* layer))block;


// 通过名字查找很常见
- (FlaMovieLayer*) findSuperMovieLayerNamed:(NSString*)name;


// 查找子图层
- (FlaMovieLayer*) findSubMovieLayer:(BOOL(^)(FlaMovieLayer* layer))block;
- (FlaMovieLayer*) findSubMovieLayerNamed:(NSString*)name;


@end







