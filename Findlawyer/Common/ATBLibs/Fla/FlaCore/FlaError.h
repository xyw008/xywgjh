//
//  FlaError.h
//  SceneEditor
//
//  Created by HJC on 12-12-17.
//  Copyright (c) 2012年 HJC. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    FlaErrorCode_Success        =   0,      // 成功，无错误
    FlaError_ReadFileFails      =   1,      // 读取文件失败，有可能是权限不够或者无这个文件
    FlaError_WrongFormat        =   2,      // 错误格式
    FlaError_CheckMd5Fails      =   3,      // 文件可能经过修改或者不完整，导致md5检验失败
    FlaError_VersionIsTooHigh   =   4,      // 低版本的SDK不能读取高版本的格式
    FlaError_NoRootDefine,                  // 读取的文件中没有根节点
} FlaErrorCode;



@interface FlaError : NSObject
{
@private
    FlaErrorCode     _code;
}
@property (nonatomic, readonly) FlaErrorCode    code;

- (id) initWithCode:(FlaErrorCode)code;
+ (id) errorWithCode:(FlaErrorCode)code;

@end





