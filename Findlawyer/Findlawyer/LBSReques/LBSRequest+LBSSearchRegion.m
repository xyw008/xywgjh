//
//  LBSRequest+LBSSearchRegion.m
//  LBSYunDemo
//
//  Created by RetVal on 3/27/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRequest+LBSSearchRegion.h"
static NSString * const _baseAppendWithSkipFormat = @"%@=%@&"; // 单一参数
static NSString * const _baseAppendSignleFormat = @"%@=%@";
static NSString * const _baseAppendFormat = @"%@:%@"; // 多个参数
@implementation LBSRequest (LBSSearchRegion)

+ (NSURL *)searchRegionBaseURL
{
	return [NSURL URLWithString:LBSRequestBaseURLString];
}

+ (LBSRequest *)RequestWithRegionConfiguration:(NSDictionary *)info
{
	if (info == nil) return nil;
	NSString *databox = [info objectForKey:kLBSRequestGeotable];
	NSString *ak = [info objectForKey:kLBSRequestPublicAPIKey];
	NSArray *filter = [info objectForKey:kLBSRequestFilter];
	NSString *region = [info objectForKey:kLBSRequestRegion];
    NSString * sortby = [info objectForKey:kLBSRequestSortby];
	if (databox == nil || ak == nil || region == nil) return nil;
	NSString *sn = [info objectForKey:kLBSRequestPrivateAPIKey];
	NSNumber *timestamp = [info objectForKey:kLBSRequestTimeStamp];
	if ((sn != nil && timestamp == nil) || (sn != nil && [timestamp intValue] == 0))
	{
		return nil;
	}
	if ([ak length] > 50 ||
		[region length] > 50 ||
		[databox length] > 50 ||
		[sn length] > 50)
		return nil;
	NSString *q = [info objectForKey:kLBSRequestQuery];
    NSMutableString *v2String = [[NSMutableString alloc] init];
    [v2String appendFormat:@"%@?", @"http://api.map.baidu.com/geosearch/v3/local"];
    [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestQuery, (q) ? q : @""];
    [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestRegion, region];
    //        [v2String appendFormat:@"%@=", kLBSRequestFilter];
    if (databox)
        [v2String appendFormat:_baseAppendWithSkipFormat, @"geotable_id", databox];
    if (filter)
    {
        [v2String appendFormat:@"%@=LFId:", kLBSRequestFilter];
        
        [v2String appendFormat:@"[%@]", [filter componentsJoinedByString:@","]];
        [v2String appendString:@"&"];
        
        /*
        [v2String appendFormat:@"%@=", kLBSRequestFilter];
        for (NSString * filterMember in filter)
        {
            [v2String appendFormat:@"|%@", filterMember];
        }
        [v2String appendString:@"&"];
         */
    }
    NSNumber *scope = [info objectForKey:kLBSRequestScope];
    if (scope)
        [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestScope, scope];
    NSNumber *page_index = [info objectForKey:kLBSRequestPageIndex];
    if (page_index)
        [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestPageIndex, page_index];
    NSNumber *page_size = [info objectForKey:kLBSRequestPageSize];
    if (page_size)
        [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestPageSize, page_size];
    
    if (sortby) {
        [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestSortby, sortby];
    }
    [v2String appendFormat:_baseAppendSignleFormat, kLBSRequestPublicAPIKey, ak];
    if (sn)
    {
        [v2String appendString:@"&"];
        [v2String appendFormat:_baseAppendWithSkipFormat, kLBSRequestPrivateAPIKey, sn];
        [v2String appendFormat:_baseAppendSignleFormat, kLBSRequestTimeStamp, timestamp];
    }
    //        NSLog(@"%@", [v2String stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]);
    NSURL * url = [NSURL URLWithString:[v2String stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSLog(@"%@", url);
    LBSRequest *request = [[LBSRequest alloc]initWithURL: url];
    return request;
}
@end
