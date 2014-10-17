//
//  LBSRequest.m
//  LBSYunDemo
//
//  Created by RetVal on 3/26/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRequest.h"
#import "LBSRental.h"
#import "LBSDataCenter.h"

NSString * const kLBSRequestQuery = @"q";
NSString * const kLBSRequestRegion = @"region";
NSString * const kLBSRequestFilter = @"filter";
NSString * const kLBSRequestGeotable = @"geotable_id";
NSString * const kLBSRequestSortby = @"sortby";

NSString * const kLBSRequestPublicAPIKey = @"ak";
NSString * const kLBSRequestPrivateAPIKey = @"sn";
NSString * const kLBSRequestTimeStamp = @"timestamp";

NSString * const kLBSRequestScope = @"scope";
NSString * const kLBSRequestPageIndex = @"page_index";
NSString * const kLBSRequestPageSize = @"page_size";

NSString * const kLBSRequestRadius = @"radius";
NSString * const kLBSRequestLocation = @"location";


NSString * const kLBSRequestUpdateLocation = @"com.baidu.location.update";
@implementation LBSRequest (keyForRoot)
+ (NSUInteger)keyForSize:(NSDictionary *)rentalInfo
{
	return [[rentalInfo objectForKey:@"size"] unsignedIntegerValue];
}

+ (NSUInteger)keyForStatus:(NSDictionary *)rentalInfo
{
    if ([[rentalInfo objectForKey:@"status"] isSafeObject])
    {
        return [[rentalInfo objectForKey:@"status"] unsignedIntegerValue];
    }
    return NSNotFound;
}

+ (NSUInteger) keyForTotalCount:(NSDictionary *)rentalInfo
{
	return [[rentalInfo objectForKey:@"total"] unsignedIntegerValue];
}

+ (NSUInteger) keyForType:(NSDictionary *)rentalInfo
{
	return [[rentalInfo objectForKey:@"type"] unsignedIntegerValue];
}

+ (NSArray *) keyForContents:(NSDictionary *)rentalInfo
{
	return [rentalInfo objectForKey:@"contents"];
}

+ (NSArray *) keyForLawFirm:(NSDictionary *)rentalInfo
{
	return [rentalInfo objectForKey:@"LawFirm"];
}

@end

@interface LBSRequest()
{
	@private
	LBSRequestHandler _handler;
}
@end

@implementation LBSRequest
+ (NSArray *)RequestWithURL:(NSURL *)requestURL withError:(NSError **)error
{
	NSArray* objects = nil;
	if (requestURL == nil) return objects;
	NSDictionary* rentalInfo = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:requestURL] options:NSJSONReadingAllowFragments error:error];
	if (rentalInfo)
	{
		
	}
	return objects;
}

+ (void)RequestWithURL:(NSURL *)requestURL handler:(void (^)(LBSRequest *request, NSArray * rentals))handler
{
	
}

- (id)initWithURL:(NSURL *)requestURL
{
	if ((self = [super init]))
	{
		_reserved = requestURL;
	}
	return self;
}

- (NSArray *)requestWithError:(NSError **)error
{
	NSMutableArray *dataModels = nil;
	if (_reserved)
	{
		NSData *data = [NSData dataWithContentsOfURL:_reserved];
		NSLog(@"get data!");
		if (data == nil) return dataModels;
		NSDictionary* dataInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
		if (dataInfo)
		{
			if (0 == [LBSRequest keyForStatus:dataInfo])
			{
				// success
            
				_availableItemCount = [LBSRequest keyForTotalCount:dataInfo];
				NSArray *contents = [LBSRequest keyForContents:dataInfo];
				if (contents == nil || [contents count] == 0) return nil;
				dataModels = [NSMutableArray arrayWithCapacity:[contents count]];
				for (NSDictionary *object in contents)
				{
					[dataModels addObject:object];
				}
				NSLog(@"localize finished DEPRECATED");
			}
          
		}
	} 
	return dataModels;
}

- (void)requestWithHandler:(LBSRequestHandler)handler
{
	if (_reserved)
	{
		_handler = handler;
		NSLog(@"send request!");
		[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:_reserved] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
			self.error = err;
			if (data == nil)
			{
				NSLog(@"data is nil");
				if (err) NSLog(@"%@", err);
                _handler(self, nil);
				return ;
			}
			
			NSLog(@"get data!");
			NSError *error;
			NSDictionary *modelInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
			self.error = error;
			if (modelInfo)
			{
				if (0 == [LBSRequest keyForStatus:modelInfo])
				{
					// success
					_availableItemCount = [LBSRequest keyForTotalCount:modelInfo];
					NSArray *contents = [LBSRequest keyForContents:modelInfo];
					if (contents == nil || [contents count] == 0)
					{
						_handler(self, nil);
						return ;
					}
#define MODE 0
#if (MODE >= 3)
					dispatch_group_t _grounp = dispatch_group_create();
					dispatch_queue_t _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
#elif (MODE >= 2)
					dispatch_queue_t _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
#endif
					NSUInteger idx = 0;
					for (id object in contents)
					{
#if (MODE >= 3)
						dispatch_group_async(_grounp, _queue, ^{
							_handler(self, object);
						});
#elif (MODE >= 2)
						dispatch_sync(_queue, ^{
							_handler(self, object);
						});
#elif (MODE >= 1)
						_handler(self, object);
#elif (MODE == 0)
						_handler(self, object);
#endif
						idx++;
					}
					
#if (MODE >= 3)
					dispatch_group_wait(_grounp, DISPATCH_TIME_FOREVER);
					dispatch_release(_grounp);
#endif
#if (MODE > 0)
					dispatch_sync(_queue, ^{
						_handler(self, nil);
						NSLog(@"localize finished");
					});
#else
					_handler(self, nil);
					NSLog(@"localize finished");
#endif
				}
                
			}

		}];
	}
	return;
}

- (NSURL *)requestURL
{
	return [_reserved copy];
}

- (void)dealloc
{
	
}

- (NSString *)description
{
	if (_reserved)
		return [NSString stringWithFormat:@"%@ - <%@>", NSStringFromClass([self class]), _reserved];
	return [super description];
}
@end
