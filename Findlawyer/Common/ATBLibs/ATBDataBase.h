//
//  ATBDataBase.h
//  PaintingBoard
//
//  Created by apple on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface ATBDataBase : NSObject
{
    sqlite3*    _sql;  
    NSString*   _dbName; 
}
@property (nonatomic)           sqlite3*     sql;  
@property (nonatomic, retain)   NSString*    dbName; 

- (id) initWithDbName:(NSString*)dbname;  
- (BOOL) openOrCreateDatabase:(NSString*)DbName;  
- (BOOL) createTable:(NSString*)sqlCreateTable;  
- (void) closeDatabase;  
- (BOOL) InsertTable:(NSString*)sqlInsert;  
- (BOOL) UpdataTable:(NSString*)sqlUpdata;  
- (NSArray*) querryTable:(NSString*)sqlQuerry;  
@end
