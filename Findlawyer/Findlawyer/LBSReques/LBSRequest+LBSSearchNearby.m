//
//  LBSRequest+LBSSearchNearby.m
//  LBSYunDemo
//
//  Created by RetVal on 3/28/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//
#import "LBSRequestManager.h"
#import "LBSRequest+LBSSearchNearby.h"
#import <CoreLocation/CLLocation.h>
static NSString * const _baseAppendWithSkipFormat = @"%@=%@&"; // 单一参数
static NSString * const _baseAppendSignleFormat = @"%@=%@";
static NSString * const _baseAppendFormat = @"%@:%@"; // 多个参数
@implementation NSString (Location)

+ (NSString *)locationToString:(CLLocationCoordinate2D)coordinate2D
{
	return [NSString stringWithFormat:@"%f,%f", coordinate2D.latitude, coordinate2D.longitude];
}

+ (NSString *)locationToStringR:(CLLocationCoordinate2D)coordinate2D
{
    return [NSString stringWithFormat:@"%f,%f", coordinate2D.longitude, coordinate2D.latitude];
}

@end
@implementation LBSRequest (LBSSearchNearby)
+ (NSURL *)searchRegionBaseURL
{
	return [NSURL URLWithString:LBSRequestBaseURLString];
}

+ (LBSRequest *)RequestWithDistanceConfiguration:(NSDictionary *)info
{
	if (info == nil) return nil;
	NSString *location = [info objectForKey:kLBSRequestLocation];
	NSString *databox = [info objectForKey:kLBSRequestGeotable];
	NSString *ak = [info objectForKey:kLBSRequestPublicAPIKey];
	NSArray *filter = [info objectForKey:kLBSRequestFilter];
	if (location == nil || databox == nil || ak == nil) return nil;
	NSString *sn = [info objectForKey:kLBSRequestPrivateAPIKey];
	NSNumber *timestamp = [info objectForKey:kLBSRequestTimeStamp];
	if ((sn != nil && timestamp == nil) || (sn != nil && [timestamp intValue] == 0))
	{
		return nil;
	}
	if ([location length] > 25 ||
		[ak length] > 50 ||
		[databox length] > 50 ||
		[sn length] > 50)
		return nil;
	NSNumber *radius = [info objectForKey:kLBSRequestRadius];
	NSString *q = [info objectForKey:kLBSRequestQuery];

    NSMutableString *urlString = [[NSMutableString alloc] init];
    [urlString appendFormat:@"%@?", @"http://api.map.baidu.com/geosearch/v3/nearby"];
    [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestQuery, (q) ? q : @""];
    [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestLocation, location];
    if (radius)
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestRadius, radius];
    
    if (databox)
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestGeotable, databox];
    if (filter)
    {
        [urlString appendFormat:@"%@=", kLBSRequestFilter];
        for (NSString * filterMember in filter)
        {
            [urlString appendFormat:@"|%@", filterMember];
        }
        [urlString appendString:@"&"];
    }
    
    NSNumber *scope = [info objectForKey:kLBSRequestScope];
    if (scope)
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestScope, scope];
    NSNumber *page_index = [info objectForKey:kLBSRequestPageIndex];
    if (page_index)
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestPageIndex, page_index];
    NSNumber *page_size = [info objectForKey:kLBSRequestPageSize];
    if (page_size)
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestPageSize, page_size];

    [urlString appendFormat:_baseAppendSignleFormat, kLBSRequestPublicAPIKey, ak];
    if (sn)
    {
        [urlString appendString:@"&"];
        [urlString appendFormat:_baseAppendWithSkipFormat, kLBSRequestPrivateAPIKey, sn];
        [urlString appendFormat:_baseAppendSignleFormat, kLBSRequestTimeStamp, timestamp];
    }
    NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSLog(@"%@", url);
    LBSRequest *request = [[LBSRequest alloc]initWithURL: url];
    return request;
}
@end

@implementation LBSRequest (LBSLocation)

+ (void)updateCurrentLocationWithHandler:(void (^)(BMKUserLocation *))handler
{
	[[LBSRequestManager defaultManager] addRequest:[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestLocation]] locationUpdateComplete:handler];
}

@end