//
//  ATBLibs+NSFileManager.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSFileManager(ATBLibsAddtions)

// 应用程序文档目录
+ (NSString*) documentPath;


// 资源目录
+ (NSString*) resourcePath;


// caches目录
+ (NSString*) cachesPath;


// 临时目录
+ (NSString*) temporaryPath;


// 如果filePath目录不存在, 就创建此目录, 失败返回FALSE
// 比如路径为　/Hello/Hi/OK/World, 如果当前之后路径　/Hello, 
// 就会连续创建目录　Hi, OK, World, 使得/Hello/Hi/OK/World存在
+ (BOOL) letDirectoryExistsAtPath:(NSString*)filePath;



// 使得文件名不重名
+ (NSString*) makeUniqueFileName:(NSString*)fileName basePath:(NSString*)basePath isDirectory:(BOOL)isDirectory;
+ (NSString*) makeUniqueFilePath:(NSString*)filePath isDirectory:(BOOL)isDirectory;


typedef enum
{
    ATFileType_None,
    ATFileType_Dir,
    ATFileType_Reg,
} ATFileType;
+ (void) fileTravelPath:(NSString*)basePath 
                  block:(BOOL(^)(NSString* refPath, NSString* name, ATFileType fileType))block; 

@end
