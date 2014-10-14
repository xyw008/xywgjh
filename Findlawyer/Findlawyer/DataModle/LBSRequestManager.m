//
//  LBSRequestManager.m
//  LBSYunDemo
//
//  Created by RetVal on 3/27/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRequestManager.h"
#import "LBSRental.h"
#import "LBSRequest.h"
#import "Reachability.h"
#include <dispatch/dispatch.h>
#include <libkern/OSAtomic.h>
#import <CoreLocation/CoreLocation.h>
static LBSRequestManager * __requestDefaultManager;
@interface LBSRequestManager() <CLLocationManagerDelegate>
{
	dispatch_queue_t _requestSendQueue;
	CLLocationManager *_manager;
	NSMutableArray *_locationRequests;
	OSSpinLock _locationRequestsLock;
	
	NSMutableArray *_requestsSaveQueue;
	
	Reachability * _reachability;
	NetworkStatus _networkStatus;
}
@property (strong, nonatomic) NSMutableArray *locationRequests;
@end

@implementation LBSRequestManager
+ (id)defaultManager
{
	if (__requestDefaultManager) return __requestDefaultManager;
	return __requestDefaultManager = [[LBSRequestManager alloc]init];
}

- (id)init
{
	if (__requestDefaultManager) return __requestDefaultManager;
	if ((self = [super init]))
	{
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkNetworkStatus:)name:kReachabilityChangedNotification object:nil];
		_reachability = [Reachability reachabilityForInternetConnection];
		[_reachability startNotifier];
		_networkStatus = [_reachability currentReachabilityStatus];
		_requestSendQueue = dispatch_queue_create("com.baidu.requestQueue.private", nil);
		if (_requestSendQueue == nil) return nil;
		_manager = [[CLLocationManager alloc] init];
		[_manager setDelegate:self];
		_locationRequests = [[NSMutableArray alloc] init];
		_requestsSaveQueue = [[NSMutableArray alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_removeRequestFromSaveQueueNotification:) name:@"ls.request.complete" object:nil];
	}
	return self;
}

- (void)checkNetworkStatus:(NSNotification *)notification
{
	Reachability* curReach = [notification object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	_networkStatus = [curReach currentReachabilityStatus];
}

- (void)addRequest:(LBSRequest *)request complete:(void (^)(LBSRequest *request, NSArray * contents))handler
{
	if (_networkStatus == NotReachable)
	{
		request.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
		handler(request, nil);
		return;
	}
	dispatch_sync(_requestSendQueue, ^{
		NSError * error = nil;
		handler(request, [request requestWithError:&error]);
	});
}

- (void)_removeRequestFromSaveQueueNotification:(NSNotification *)notification
{
	[_requestsSaveQueue removeObject:[[notification userInfo] objectForKey:@"ls.request.complete"]];
}

- (void)addRequest:(LBSRequest *)request pieceComplete:(LBSRequestHandler)handler
{
	if (_networkStatus == NotReachable)
	{
		request.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
		handler(request, nil);
		return;
	}
	[request requestWithHandler:handler];
	return;
}

- (void)addRequest:(LBSRequest *)request dataComplete:(LBSRequestHandler)handler
{
	if (_networkStatus == NotReachable)
	{
		request.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
		handler(request, nil);
		return;
	}
	dispatch_async(_requestSendQueue, ^{
		NSURL *url = [request requestURL];
		if (url == nil) {
			handler(request, nil);
			NSLog(@"requestURL is nil");
			return;
		}
		[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
										   queue:[NSOperationQueue mainQueue]
							   completionHandler:^(NSURLResponse *response, NSData *data, NSError *err)
		{
			//NSData *data = [NSData dataWithContentsOfURL:[request requestURL]];
			if (data == nil)
			{
				NSLog(@"data is nil");
				handler(request, nil);
				return;
			}
			//NSLog(@"handle data");
			handler(request, data);
			handler(request, nil);
			return;
		}];
	});
}

- (void)addRequest:(LBSRequest *)request locationUpdateComplete:(void(^)(CLLocation *location))handler
{
	if (_networkStatus == NotReachable)
	{
		request.error = [NSError errorWithDomain:NSOSStatusErrorDomain code:0 userInfo:nil];
		handler(nil);
		return;
	}
	if ([request.requestURL isEqual:[NSURL URLWithString:kLBSRequestUpdateLocation]])
	{
		OSSpinLockLock(&_locationRequestsLock);
		[_locationRequests addObject:handler];
		OSSpinLockUnlock(&_locationRequestsLock);
		[_manager startUpdatingLocation];
		
		return;
	}
	handler(nil);
}

- (void)dealloc
{
//#if TARGET_OS_IPHONE
//	if (_requestSendQueue) dispatch_release(_requestSendQueue);
//#endif
	_requestSendQueue = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	void(^handler)(CLLocation *location);
	OSSpinLockLock(&_locationRequestsLock);
	for (handler in _locationRequests)
	{
		handler([locations lastObject]);
	}
	[_locationRequests removeAllObjects];
	OSSpinLockUnlock(&_locationRequestsLock);
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	void(^handler)(CLLocation *location);
	OSSpinLockLock(&_locationRequestsLock);
	for (handler in _locationRequests)
	{
		handler(nil);
	}
	[_locationRequests removeAllObjects];
	OSSpinLockUnlock(&_locationRequestsLock);
	[manager stopUpdatingLocation];
}
@end