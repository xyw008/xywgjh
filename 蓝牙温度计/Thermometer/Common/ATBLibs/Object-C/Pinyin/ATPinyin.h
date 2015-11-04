//
//  ATPinyin.h
//  ATBLibs
//
//  Created by HJC on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATSingleton.h"
#import "ATPinyin+NSString.h"
#import <sqlite3.h>


@interface ATPinyin : ATSingleton
{
@private
    sqlite3*        _db;
    sqlite3_stmt*   _selectStmt;
    NSString*       _dbPath;
    int             _numberOfRetries;
}

+ (ATPinyin*) shared;
- (bool)      openDatabase:(NSString*)dbPath;
- (bool)      closeDatabase;

- (bool)      pinyinUpdateWithPath:(NSString*)path;

// 得到某个汉字的拼音, 如果没有拼音就返回NULL
- (NSString*) pinyinFromCharacter:(NSString*)c;
- (NSString*) traditionalFromSimplified:(NSString*)str;

@end



@interface ATPinyin(ATBPinyinAddtions)

// 得到字符串的拼音，拼音之间用separator隔开
- (NSString*) pinyinFromString:(NSString*)string separator:(NSString*)separator;

@end
