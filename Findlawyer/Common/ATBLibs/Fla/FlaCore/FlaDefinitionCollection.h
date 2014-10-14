//
//  FlaDefinitionCollection.h
//  FlashCocos2dTest
//
//  Created by HJC on 13-2-25.
//
//

#import <Foundation/Foundation.h>
#import "FlaError.h"
#import "FlaDefinition.h"


@interface FlaDefinitionCollection : NSObject
{
@private
    NSMutableArray*         _definitions;
    NSMutableDictionary*    _nameDict;
    FlaDefinition*          _rootDefinition;
}
@property (nonatomic, readonly) NSArray*        definitions;
@property (nonatomic, readonly) FlaDefinition*  rootDefinition;


+ (id) loadFromPath:(NSString*)path error:(FlaError**)error;
+ (id) loadFromPath:(NSString *)path frameRate:(CGFloat*)frameRate error:(FlaError**)error;

- (FlaDefinition*) definitionForName:(NSString*)name;

@end
