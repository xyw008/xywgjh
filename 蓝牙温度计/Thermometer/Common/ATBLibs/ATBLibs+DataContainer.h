//
//  ATBLibs+DataContainer.h
//  ATBLibs
//
//  Created by HJC on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMutableArray(ATBLibsAddtions)

// 将索引为atIndex的项移动toIndex
- (void) moveObjectAtIndex:(NSInteger)atIndex toIndex:(NSInteger)toIndex;

// 将数组翻转
- (void) reverseObjects;

@end




@interface NSArray(ATBLibsAddtions)

// 从数组中取出数据
- (void) unpack:(id __strong *)obj, ... NS_REQUIRES_NIL_TERMINATION;

@end




//////////////////////////////////////////////////////////////////
@interface NSMutableDictionary(ATBLibsSettings)

- (void) saveBool:(BOOL)value forKey:(NSString*)key;
- (BOOL) loadBoolForKey:(NSString*)key defaultValue:(BOOL)value;

- (void) saveInteger:(NSInteger)value forKey:(NSString*)key;
- (NSInteger) loadIntegerForKey:(NSString*)key defaultValue:(NSInteger)value;

- (void) saveFloat:(float)value forKey:(NSString*)key;
- (float) loadFloat:(NSString*)key defaultValue:(float)value;

- (void) saveDouble:(double)value forKey:(NSString*)key;
- (double) loadDouble:(NSString*)key defaultValue:(double)value;

- (void) saveString:(NSString*)value forKey:(NSString*)key;
- (NSString*) loadStringForKey:(NSString*)key defaultValue:(NSString*)value;

@end



@interface NSUserDefaults(ATBLibsSettings)

+ (void) saveBool:(BOOL)value forKey:(NSString*)key;
+ (BOOL) loadBoolForKey:(NSString*)key defaultValue:(BOOL)value;

+ (void) saveInteger:(NSInteger)value forKey:(NSString*)key;
+ (NSInteger) loadIntegerForKey:(NSString*)key defaultValue:(NSInteger)value;

+ (void) saveFloat:(float)value forKey:(NSString*)key;
+ (float) loadFloat:(NSString*)key defaultValue:(float)value;

+ (void) saveString:(NSString*)value forKey:(NSString*)key;
+ (NSString*) loadStringForKey:(NSString*)key defaultValue:(NSString*)value;

@end

////////////////////////////////////////////////////////////////////////


