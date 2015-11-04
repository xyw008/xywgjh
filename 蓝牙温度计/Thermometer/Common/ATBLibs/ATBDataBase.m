//
//  ATBDataBase.m
//  PaintingBoard
//
//  Created by apple on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATBDataBase.h"

@implementation ATBDataBase
@synthesize sql = _sql;
@synthesize dbName = _dbName;

- (id) initWithDbName:(NSString*)dbname  
{  
    self = [super init];  
    if (self != nil) 
    {  
        if ([self openOrCreateDatabase:dbname]) 
        {  
            [self closeDatabase];  
        }  
    }  
    return self;  
}  
- (id) init  
{  
    NSAssert(0,@"Never Use this.Please Call Use initWithDbName:(NSString*)");  
    return nil;  
}  
- (void) dealloc  
{  
    _sql = nil;  
//    SafelyRelease(&_dbName);  
//    [super dealloc];
}

//创建数据库  
-(BOOL)openOrCreateDatabase:(NSString*)dbName  
{  
    self.dbName = dbName;  
    NSArray *path =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);  
    NSString *documentsDirectory = [path objectAtIndex:0];  
    
    if (sqlite3_open([[documentsDirectory stringByAppendingPathComponent:dbName] UTF8String],&_sql) !=SQLITE_OK)
    {  
        NSLog(@"创建数据库失败");  
        return    NO;  
    }  
    return YES;  
}  

//创建表  
- (BOOL)createTable:(NSString*)sqlCreateTable  
{  
    if (![self openOrCreateDatabase:_dbName])
    {  
        return NO;  
    }  
    char *errorMsg;  
    if (sqlite3_exec (_sql, [sqlCreateTable UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK)  
    {  
        NSLog(@"创建数据表失败:%s", errorMsg);  
        return NO;  
    }  
    [self closeDatabase];  
    return YES;  
}  

//关闭数据库  
- (void)closeDatabase  
{  
    sqlite3_close(_sql);   
}  

//insert
- (BOOL)InsertTable:(NSString*)sqlInsert  
{  
    if (![self openOrCreateDatabase:_dbName])
    {  
        return NO;  
    }  
    char* errorMsg = NULL;  
    if (sqlite3_exec(_sql, [sqlInsert UTF8String],0, NULL, &errorMsg) ==SQLITE_OK)
    {  
        [self closeDatabase];  
        return YES;
    }  
    else 
    {  
        printf("更新表失败:%s",errorMsg);  
        [self closeDatabase];  
        return NO;  
    }  
    return YES;  
}  

//updata  
- (BOOL)UpdataTable:(NSString*)sqlUpdata
{  
    if (![self openOrCreateDatabase:_dbName]) 
    {  
        return NO;  
    }  
    char *errorMsg;  
    if (sqlite3_exec (_sql, [sqlUpdata UTF8String],0, NULL, &errorMsg) !=SQLITE_OK)  
    {  
        [self closeDatabase];  
        return YES;  
    }
    else 
    {  
        return NO;  
    }  
    
    return YES;  
}  
//select  
-(NSArray*)querryTable:(NSString*)sqlQuerry  
{  
    if (![self openOrCreateDatabase:_dbName]) 
    {  
        return nil;  
    }  
    int row = 0;  
    int column = 0;  
    char*    errorMsg = NULL;  
    char**    dbResult = NULL;  
    NSMutableArray*    array = [[NSMutableArray alloc] init];  
    if (sqlite3_get_table(_sql, [sqlQuerry UTF8String], &dbResult, &row,&column,&errorMsg ) == SQLITE_OK)
    {  
        if (0 == row) 
        {  
            [self closeDatabase];  
            return nil;  
        }  
        
        int index = column;  
        for (int i =0; i < row ; i++ )
        {    
            NSMutableDictionary*    dic = [[NSMutableDictionary alloc] init];  
            for (int j =0 ; j < column; j++ ) 
            {  
                if (dbResult[index]) 
                {  
                    NSString*    value = [[NSString alloc] initWithUTF8String:dbResult[index]];  
                    NSString*    key = [[NSString alloc] initWithUTF8String:dbResult[j]];  
                    [dic setObject:value forKey:key];  
//                    [value release];  
//                    [key release];  
                }
                index ++;  
            }   
            [array addObject:dic];  
//            [dic release];  
        }
    }
    else 
    {  
        printf("%s",errorMsg);  
        [self closeDatabase];  
        return nil;  
    }  
    [self closeDatabase];
    return array;
//    return [array autorelease];
}
@end
