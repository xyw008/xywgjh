//
//  LBSDataCenter.m
//  LBSYunDemo
//
//  Created by RetVal on 3/29/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//
#include <libkern/OSAtomic.h>
#import "LBSDataCenter.h"
#import "LBSRental.h"
#import "LBSRequest.h"
#import "LBSRequest+LBSSearchNearby.h"
#import "LBSRequest+LBSSearchRegion.h"
#import "LBSRequestManager.h"
#import "FileManager.h"
static LBSDataCenter *__LSDefaultDataCenter = nil;
@interface LBSDataCenter ()
{
	NSString * _dataBoxIDStr;
	NSString * _cloudKey;
	
}
@property (strong, nonatomic) NSString * dataBoxIDStr;
@property (strong, nonatomic) NSString * cloudKey;

@end
@implementation LBSDataCenter


+ (id)defaultCenter
{
	return (__LSDefaultDataCenter) ? __LSDefaultDataCenter : [[self alloc] init];
}

- (id)init
{
	if (__LSDefaultDataCenter) return __LSDefaultDataCenter;
	if (self = [super init])
	{
		__LSDefaultDataCenter = self;
	}
	return self;
}

- (void)setDataBox:(NSUInteger)dataBoxID
{
	if (dataBoxID)
	{
		_dataBoxIDStr = [NSString stringWithFormat:@"%d", dataBoxID];
	}
}

- (void)setCloudKey:(NSString *)key
{
	if (_cloudKey) return;
	_cloudKey = key;
}

- (BOOL)isIphone5
{
#if TARGET_OS_IPHONE
	return UIScreen.mainScreen.bounds.size.height == 568;
#else
	return YES;
#endif
}

- (void)loadDataWithNearby:(CLLocationCoordinate2D)location radius:(NSUInteger)radius searchtype:(NSInteger)searchtype searchKye:(NSString *)searchkey index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
{
    NSMutableDictionary *property = [[NSMutableDictionary alloc] initWithCapacity:8];
	[property setObject:[NSNumber numberWithUnsignedInteger:radius] forKey:kLBSRequestRadius];
	[property setObject:LBSAppCloudKey forKey:kLBSRequestPublicAPIKey];
	//[property setObject:[NSNumber numberWithInt:2] forKey:kLBSRequestScope];
    if (searchkey.length >0 ) {
         [property setObject:searchkey forKey:kLBSRequestQuery];
    }
    if (searchtype == SearchHouse)//根据类型来选择搜索哪张表
    {
      [property setObject:@"71578" forKey:kLBSRequestGeotable];
    }
    else
    {
        [property setObject:@"71577" forKey:kLBSRequestGeotable];

    }
	
	[property setObject:[NSString locationToStringR:location] forKey:kLBSRequestLocation];
	if (index) [property setObject:[NSNumber numberWithUnsignedInteger:index] forKey:kLBSRequestPageIndex];
	if (pageSize > 50) pageSize = 50;
	if (pageSize) [property setObject:[NSNumber numberWithUnsignedInteger:pageSize] forKey:kLBSRequestPageSize];
	LBSRequest *request = [LBSRequest RequestWithDistanceConfiguration:property];
	[[LBSRequestManager defaultManager] addRequest:request pieceComplete:handler];
  
}

- (void)loadDataWithRegionSearchkey:(NSString *)searchkey  searchtype:(NSInteger)searchtype  index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
{
    
	if (searchkey == nil) return;
    
    // 得到选择的城市
    NSString * currentcity = [FileManager currentCity];
    
//    if (currentcity.length == 0) {
//       currentcity = @"深圳";
//    }
    
    currentcity = @"深圳";//默认城市是深圳

    NSMutableDictionary *property = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    if (searchkey.length >0) {
        [property setObject:searchkey forKey:kLBSRequestQuery];
    }
    
	[property setObject:currentcity forKey:kLBSRequestRegion];
	[property setObject:LBSAppCloudKey forKey:kLBSRequestPublicAPIKey];
	//[property setObject:[NSNumber numberWithInt:2] forKey:kLBSRequestScope];
    [property setObject:@"distance:1" forKey:kLBSRequestScope];
//	[property setObject:_dataBoxIDStr forKey:kLBSRequestGeotable];
    
    if (searchtype == SearchHouse) //根据类型来选择搜索哪张表
    {
        [property setObject:@"71578" forKey:kLBSRequestGeotable];
    }
    else
    {
        [property setObject:@"71577" forKey:kLBSRequestGeotable];
        
    }
    
	if (index) [property setObject:[NSNumber numberWithUnsignedInteger:index] forKey:kLBSRequestPageIndex];
	if (pageSize > 50) pageSize = 50;
	if (pageSize) [property setObject:[NSNumber numberWithUnsignedInteger:pageSize] forKey:kLBSRequestPageSize];
	
	LBSRequest *request = [LBSRequest RequestWithRegionConfiguration:property];
	NSLog(@"%@", request);
	[[LBSRequestManager defaultManager] addRequest:request pieceComplete:handler];
  
}


- (void)loadDataWithNearby:(CLLocationCoordinate2D)location radius:(NSUInteger)radius index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
{
	NSMutableDictionary *property = [[NSMutableDictionary alloc] initWithCapacity:8];
	[property setObject:[NSNumber numberWithUnsignedInteger:radius] forKey:kLBSRequestRadius];
	[property setObject:_cloudKey forKey:kLBSRequestPublicAPIKey];
	[property setObject:[NSNumber numberWithInt:2] forKey:kLBSRequestScope];
	[property setObject:_dataBoxIDStr forKey:kLBSRequestGeotable];
	[property setObject:[NSString locationToStringR:location] forKey:kLBSRequestLocation];
	if (index) [property setObject:[NSNumber numberWithUnsignedInteger:index] forKey:kLBSRequestPageIndex];
	if (pageSize > 50) pageSize = 50;
	if (pageSize) [property setObject:[NSNumber numberWithUnsignedInteger:pageSize] forKey:kLBSRequestPageSize];
	LBSRequest *request = [LBSRequest RequestWithDistanceConfiguration:property];
	[[LBSRequestManager defaultManager] addRequest:request pieceComplete:handler];
}



- (void)loadDataWithRegionName:(NSString *)regionName priceRange:(NSRange)priceRange rentalType:(NSUInteger)type index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
{
	static NSString * const _kLSDaypriceFormat = @"dayprice:%d,%d";
	static NSString * const _kLSRentalTypeFromat = @"leasetype:%d,%d";
	if (regionName == nil) return;
	NSMutableDictionary *property = [[NSMutableDictionary alloc] initWithCapacity:4];
	[property setObject:regionName forKey:kLBSRequestQuery];
	[property setObject:@"北京" forKey:kLBSRequestRegion];
	[property setObject:_cloudKey forKey:kLBSRequestPublicAPIKey];
	[property setObject:[NSNumber numberWithInt:2] forKey:kLBSRequestScope];
	[property setObject:_dataBoxIDStr forKey:kLBSRequestGeotable];
	NSString *priceStr = nil;
	NSString *typeStr = nil;
	if (priceRange.length != 0)
	{
		priceStr = [NSString stringWithFormat:_kLSDaypriceFormat, priceRange.location, priceRange.length];
	}
	
	if (type)
	{
		typeStr = [NSString stringWithFormat:_kLSRentalTypeFromat, type, type];
	}
	NSArray *filters = nil;
	if (priceStr && typeStr)
		filters = [NSArray arrayWithObjects:priceStr, typeStr, nil];
	else if (priceStr && nil == typeStr)
	{
		filters = [NSArray arrayWithObject:priceStr];
	}
	else if (typeStr && nil == priceStr)
	{
		filters	= [NSArray arrayWithObject:typeStr];
	}
	if (filters) [property setObject:filters forKey:kLBSRequestFilter];
	if (index) [property setObject:[NSNumber numberWithUnsignedInteger:index] forKey:kLBSRequestPageIndex];
	if (pageSize > 50) pageSize = 50;
	if (pageSize) [property setObject:[NSNumber numberWithUnsignedInteger:pageSize] forKey:kLBSRequestPageSize];
	
	LBSRequest *request = [LBSRequest RequestWithRegionConfiguration:property];
	NSLog(@"%@", request);
	[[LBSRequestManager defaultManager] addRequest:request pieceComplete:handler];
}
@end
