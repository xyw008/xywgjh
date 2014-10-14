//
//  NetItemList.h
//  PaintingBoard
//
//  Created by gnef_jp on 12-10-19.
//
//

#import <Foundation/Foundation.h>

@interface NetItem : NSObject
{
    
}

// 抽象函数
+ (id) initWithDict:(NSDictionary*)dict;
- (id) initWithDict:(NSDictionary*)dict;

- (void) refreshItem:(NetItem*)newItem;


@end


