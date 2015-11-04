//
//  NSFileManager+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by apple on 13-8-7.
//  Copyright (c) 2013年 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SSToolkitAdditions)


+ (NSString *)appPath;                      // 程序目录(Applications目录)，不能存任何东西
+ (NSString *)docPath;                      // 文档目录(Documents目录)，需要ITUNES同步备份的数据存这里
+ (NSString *)libPrefPath;                  // 配置目录(Library目录下的Preferences目录)，配置文件存这里
+ (NSString *)libCachePath;                 // 缓存目录(Library目录下的Caches目录)，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)tmpPath;                      // 临时目录(tmp目录)，APP退出后，系统可能会删除这里的内容
+ (NSString *)touch:(NSString *)path;       // 判断pah目录是否存在，如果不存在，则新建


/**
 *  在相应目录下创建一个文件夹。
 *  @param  folder:文件夹名。
 *  @param  path:文件夹所在路径。
 *  return  成功返回YES，失败返回NO。若已存在直接返回YES。
 */
+ (BOOL)createFolder:(NSString *)folder atPath:(NSString *)path;

/**
 *  保存文件到相应路径下。
 *  @param  data:要保存的数据。
 *  @param  name:要保存的文件名，如a.txt等。
 *  @param  path:文件保存的路径目录。
 *  return  成功返回YES，失败返回NO。
 */
+ (BOOL)saveData:(NSData *)data withName:(NSString *)name atPath:(NSString *)path;

/**
 *  查找并返回文件。
 *  @param  fileName:要查找的文件名。
 *  @param  path:文件所在的目录。
 *  return  成功返回文件，失败返回nil。
 */
+ (NSData *)findFile:(NSString *)fileName atPath:(NSString *)path;

/**
 *  删除文件。
 *  @param  fileName:要删除的文件名。
 *  @param  path:文件所在的目录。
 *  return  成功返回YES，失败返回NO。
 */
+ (BOOL)deleteFile:(NSString *)fileName atPath:(NSString *)path;

@end
