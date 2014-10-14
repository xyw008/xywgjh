//
//  ATSingleton.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
在程序中有时需要唯一的类实例，这称之为单件,用法例子
 
 @interface HttpDownloadManager : ATSingleton
 
 @implementation HttpDownloadManager
 static HttpDownloadManager* s_downloadManager = nil;
 + (HttpDownloadManager*) sharedManager
 {
    [self generateInstanceIfNeed:&s_downloadManager];
    return s_downloadManager;
 }
 @end
*/

@interface ATSingleton : NSObject 
{
}

- (id)      copyWithZone:(NSZone *)zone;
- (id)      retain;
- (void)    release;
- (id)      autorelease;
- (NSUInteger)retainCount;

// 如果实例为空，就需要生成实例
+ (void)  generateInstanceIfNeed:(NSObject**)sharedInstance;

@end
