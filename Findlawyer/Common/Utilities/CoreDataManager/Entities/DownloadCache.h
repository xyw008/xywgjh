//
//  DownloadCache.h
//  zmt
//
//  Created by gongjunhui on 13-9-3.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadCache : NSManagedObject

/// 被缓存的日期
@property (nonatomic, retain) NSDate * cacheDate;
/// 缓存有效期
@property (nonatomic, retain) NSNumber * expiresInSeconds;
/// 过期日期
@property (nonatomic, retain) NSDate * expiryDate;
/// 缓存内容
@property (nonatomic, retain) NSData * contentData;
/// key值
@property (nonatomic, retain) NSString * key;

@end
