//
//  ATBLibs+DataContainer.m
//  ATBLibs
//
//  Created by HJC on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+DataContainer.h"


@implementation NSMutableArray(ATBLibsAddtions)


- (void) moveObjectAtIndex:(NSInteger)atIndex toIndex:(NSInteger)toIndex
{
    NSObject* object = [self objectAtIndex:atIndex];
    [object retain];
    
    [self removeObjectAtIndex:atIndex];
    [self insertObject:object atIndex:toIndex];
    
    [object release];
}



- (void) reverseObjects
{
    NSInteger count = [self count];
    NSInteger halfCount = [self count] / 2;
    for (NSInteger idx = 0; idx < halfCount; idx++)
    {
        [self exchangeObjectAtIndex:idx withObjectAtIndex:(count - 1 - idx)];
    }
}


@end




@implementation NSArray(ATBLibsAddtions)

- (void) unpack:(id*)obj, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list vlist;
    va_start(vlist, obj);
    
    NSInteger idx = 0;
    NSInteger count = self.count;
    while (obj)
    {
        if (idx < count)
        {
            *obj = [self objectAtIndex:idx];
        }
        else
        {
            *obj = nil;
        }
        obj = va_arg(vlist, id*);
        idx++;
    }
    
    va_end(vlist);
}

@end



////////////////////////////////////////////////////////////////////////
@implementation NSMutableDictionary(ATBLibsSettings)

- (void) saveBool:(BOOL)value forKey:(NSString*)key
{
    [self setValue:[NSNumber numberWithBool:value] forKey:key];
}


- (BOOL) loadBoolForKey:(NSString*)key defaultValue:(BOOL)value
{
    NSNumber* num = [self objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num boolValue];
}


- (void) saveInteger:(NSInteger)value forKey:(NSString*)key
{
    [self setValue:[NSNumber numberWithInteger:value] forKey:key];
}


- (NSInteger) loadIntegerForKey:(NSString*)key defaultValue:(NSInteger)value
{
    NSNumber* num = [self objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num integerValue];
}



- (void) saveFloat:(float)value forKey:(NSString*)key
{
    [self setValue:[NSNumber numberWithFloat:value] forKey:key];
}


- (float) loadFloat:(NSString*)key defaultValue:(float)value
{
    NSNumber* num = [self objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num floatValue];
}


- (void) saveDouble:(double)value forKey:(NSString*)key
{
    [self setValue:[NSNumber numberWithDouble:value] forKey:key];
}


- (double) loadDouble:(NSString*)key defaultValue:(double)value
{
    NSNumber* num = [self objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num doubleValue];
}


- (void) saveString:(NSString*)value forKey:(NSString*)key
{
    [self setValue:value forKey:key];
}


- (NSString*) loadStringForKey:(NSString*)key defaultValue:(NSString*)value
{
    NSString* str = [self objectForKey:key];
    if (str == nil)
    {
        return value;
    }
    return str;
}

@end


/////////////////////////////////////////////////////////////////////////////////////
@implementation NSUserDefaults(ATBLibsSettings)


+ (void) saveBool:(BOOL)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:value]
                                             forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (BOOL) loadBoolForKey:(NSString*)key defaultValue:(BOOL)value
{
    NSNumber* num = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num boolValue];
}


+ (void) saveInteger:(NSInteger)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:value]
                                             forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSInteger) loadIntegerForKey:(NSString*)key defaultValue:(NSInteger)value
{
    NSNumber* num = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num integerValue];
}



+ (void) saveFloat:(float)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:value] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (float) loadFloat:(NSString*)key defaultValue:(float)value
{
    NSNumber* num = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (num == nil)
    {
        return value;
    }
    return [num floatValue];
}


+ (void) saveString:(NSString*)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSString*) loadStringForKey:(NSString*)key defaultValue:(NSString*)value
{
    NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (str == nil)
    {
        return value;
    }
    return str;
}

@end



