//
//  FlaDefinitionCollection.m
//  FlashCocos2dTest
//
//  Created by HJC on 13-2-25.
//
//

#import "FlaDefinitionCollection.h"
#import "fla_BinaryReader.h"


@implementation FlaDefinitionCollection


- (void) dealloc
{
    [_nameDict release];
    [_definitions release];
    [_rootDefinition release];
    [super dealloc];
}



+ (id) loadFromPath:(NSString*)path error:(FlaError**)error
{
    return [self loadFromPath:path frameRate:NULL error:error];
}



+ (id) loadFromPath:(NSString *)path frameRate:(CGFloat*)frameRate error:(FlaError**)error
{
    fla::BinaryReader reader;
    int code = reader.readFilePath([path UTF8String], true);
    if (code != fla::Code_Success)
    {
        if (error)
        {
            *error = [FlaError errorWithCode:(FlaErrorCode)code];
        }
        return nil;
    }
    
    if (frameRate)
    {
        *frameRate = reader.frameRate();
    }
    
    FlaDefinitionCollection* collection = [[[FlaDefinitionCollection alloc] init] autorelease];
    [collection __loadFromReader:reader];
    return collection;
}



- (void) __loadFromReader:(const fla::BinaryReader&)reader
{
    auto& dict = reader.dict();
    if (_definitions == nil)
    {
        _definitions = [[NSMutableArray alloc] initWithCapacity:dict.size()];
    }
    
    if (_nameDict == nil)
    {
        _nameDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    [_definitions removeAllObjects];
    [_nameDict removeAllObjects];
    
    for (auto& def : dict)
    {
        FlaDefinition* defintion = [[[FlaDefinition alloc] initWithImpl:def.second.get()] autorelease];
        if (defintion)
        {
            [_definitions addObject:defintion];
            if (def.second->name().size() > 0)
            {
                NSString* name = [NSString stringWithUTF8String:def.second->name().c_str()];
                [_nameDict setValue:defintion forKey:name];
            }
        }
    }
    
    auto root = reader.root();
    [_rootDefinition release];
    _rootDefinition = nil;

    if (root)
    {
        _rootDefinition = [[FlaDefinition alloc] initWithImpl:root.get()];
    }
}


- (FlaDefinition*) definitionForName:(NSString*)name
{
    return [_nameDict objectForKey:name];
}

@end
