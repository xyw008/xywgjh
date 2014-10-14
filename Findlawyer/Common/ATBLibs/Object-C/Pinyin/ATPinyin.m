//
//  ATPinyin.m
//  ATBLibs
//
//  Created by HJC on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATPinyin.h"




static sqlite3_stmt* prepareSql(NSString* sql, sqlite3* _db, int _numberOfRetries)
{
    if (!_db)
    {
        return NULL;
    }
    
    bool needRetry = true;
    int  rc = SQLITE_OK;
    sqlite3_stmt* pStmt = 0x00; 
    
    for (int idx = 0; idx <= _numberOfRetries && needRetry; idx++)
    {
        needRetry = false;
        rc = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &pStmt, 0);
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc)
        {
            needRetry = true;
            usleep(20);
        }
    }
    
    if (rc != SQLITE_OK)
    {
        sqlite3_finalize(pStmt);
        return NULL;
    }
    
    return pStmt;
}




@implementation ATPinyin
static ATPinyin* s_sharedPinyin = nil;

+ (ATSingleton*) shared
{
    [self generateInstanceIfNeed:&s_sharedPinyin];
    return s_sharedPinyin;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        _numberOfRetries = 2;
    }
    return self;
}


- (void) dealloc
{
    [self closeDatabase];
    [super dealloc];
}



- (bool) openDatabase:(NSString *)dbPath
{
    @synchronized(self)
    {
        if ([_dbPath isEqualToString:dbPath])
        {
            return false;
        }
        
        [self closeDatabase];
        [_dbPath release];
        
        [_dbPath release];
        _dbPath = [dbPath copy];
        
        int err = sqlite3_open([_dbPath UTF8String], &_db);
        if(err != SQLITE_OK) 
        {
            return false;
        }
        
        if (!_selectStmt)
        {
            NSString* sql = @"select pinyin from Characters where (simplified = ? OR traditional = ?)";
            _selectStmt = prepareSql(sql, _db, _numberOfRetries);
        }
    }
    
    return true;
}



static int bindTextsAndStep(sqlite3_stmt* stmt, NSString** texts, int count, int _numberOfRetries)
{
    int queryCount = sqlite3_bind_parameter_count(stmt);
    count = MIN(queryCount, count);
    
    for (int idx = 0; idx < count; idx++)
    {
        NSString* text = texts[idx];
        sqlite3_bind_text(stmt, idx + 1, [text UTF8String], -1, SQLITE_STATIC);
    }
    
    bool needRetry = true;
    int rc = SQLITE_ROW;
    
    needRetry = true;
    for (int idx = 0; needRetry && idx <= _numberOfRetries; idx++)
    {
        needRetry = false;
        rc = sqlite3_step(stmt);
        if (rc == SQLITE_BUSY || rc == SQLITE_LOCKED)
        {
            needRetry = true;
            if (SQLITE_LOCKED == rc)
            {
                rc = sqlite3_reset(stmt);
            }
            usleep(20);
        }
    }
    
    return rc;
}



- (bool) pinyinUpdateWithPath:(NSString*)path
{
    @synchronized(self)
    {
        if (!_db)
        {
            return false;
        }
        
        NSString* sql = @"insert or replace into Characters(simplified, traditional, pinyin) values(?, ?, ?)";
        sqlite3_stmt* pStmt = prepareSql(sql, _db, _numberOfRetries);
        
        NSString* string = [NSString stringWithContentsOfFile:path
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
        NSArray* array = [string componentsSeparatedByString:@"\n"];
        NSString* bindTexts[3];
        
        for (NSString* string in array)
        {
            if ([string hasPrefix:@"##"])
            {
                continue;
            }
            
            NSArray* record = [string componentsSeparatedByString:@"|"];
            if ([record count] == 3)
            {
                bindTexts[0] = [record objectAtIndex:0];
                bindTexts[1] = [record objectAtIndex:1];
                bindTexts[2] = [NSString pinyinFromQuickWriting:[record objectAtIndex:2]];
                bindTextsAndStep(pStmt, bindTexts, 3, _numberOfRetries);
                sqlite3_reset(pStmt);
            }
        }
        
        sqlite3_finalize(pStmt);
        return true;
    }
}




- (bool) closeDatabase
{
    @synchronized(self)
    {
        if (!_db) 
        {
            return true;
        }
        
        sqlite3_reset(_selectStmt);
        sqlite3_finalize(_selectStmt);
        _selectStmt = NULL;
        
        [_dbPath release];
        _dbPath = nil;
        
        bool triedFinalizingOpenStatements = false;
        bool needRetry = true;
        int  rc = SQLITE_OK;
        for (int idx = 0; idx <= _numberOfRetries && needRetry; idx++)
        {
            needRetry = false;
            rc = sqlite3_close(_db);
            if (rc == SQLITE_BUSY || rc == SQLITE_LOCKED)
            {
                needRetry = true;
                usleep(20);
                if (!triedFinalizingOpenStatements)
                {
                    triedFinalizingOpenStatements = true;
                    sqlite3_stmt *pStmt;
                    while ((pStmt = sqlite3_next_stmt(_db, 0x00)) !=0) 
                    {
                        sqlite3_finalize(pStmt);
                    }
                }
            }
        }
        
        if (rc == SQLITE_OK)
        {
            _db = NULL;
            return true;
        }
    }
    return false;
}



- (NSString*) pinyinFromCharacter:(NSString*)c
{    
    @synchronized(self)
    {
        if (!_db || !_selectStmt)
        {
            return NULL;
        }
        
        NSString* bindTexts[] = { c, c };
        int rc = bindTextsAndStep(_selectStmt, bindTexts, 2, _numberOfRetries);
        NSString* pinyin = NULL;
        if (rc == SQLITE_ROW)
        {
            pinyin = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(_selectStmt, 0)];
        }
        
        sqlite3_reset(_selectStmt);
        return pinyin;
    }
}



- (NSString*) traditionalFromSimplified:(NSString*)string
{
    @synchronized(self)
    {
        if (!_db)
        {
            return NULL;
        }
        
        NSString* sql = @"select traditional from Characters where (simplified = ?)";
        sqlite3_stmt* stmt = prepareSql(sql, _db, _numberOfRetries);
        
        NSMutableString* traditional = [NSMutableString stringWithCapacity:0];
        NSInteger length = [string length];
        
        for (NSInteger idx = 0; idx < length; idx++)
        {
            unichar c = [string characterAtIndex:idx];            
            NSString* result = [NSString stringWithCharacters:&c length:1];
            
            NSString* bindTexts = { result };
            int rc = bindTextsAndStep(stmt, &bindTexts, 1, _numberOfRetries);
            if (rc == SQLITE_ROW)
            {
                NSString* tmp = [NSString stringWithUTF8String:(const char*)sqlite3_column_text(stmt, 0)];
                [traditional appendString:tmp];
            }
            sqlite3_reset(stmt);
        }
        sqlite3_finalize(stmt);
        
        return traditional;
    }
}


@end



@implementation ATPinyin(ATBPinyinAddtions)

- (NSString*) pinyinFromString:(NSString*)string separator:(NSString*)separator
{
    NSMutableString* pinyin = [NSMutableString stringWithCapacity:0];
    NSInteger length = [string length];
    
    bool needAddSeparator = false;
    for (NSInteger idx = 0; idx < length; idx++)
    {
        unichar c = [string characterAtIndex:idx];
        if (needAddSeparator)
        {
            [pinyin appendString:separator];
            needAddSeparator = false;
        }
        
        NSString* result = [NSString stringWithCharacters:&c length:1];
        if (c > 256)
        {
            NSString* tmp = [self pinyinFromCharacter:result];
            if (tmp)
            {
                result = tmp;
                needAddSeparator = true;
            }
        }
        [pinyin appendString:result];
    }
    
    return pinyin;
}

@end
