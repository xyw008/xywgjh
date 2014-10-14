//
//  LBSRequest+LBSSearchNearby.h
//  LBSYunDemo
//
//  Created by RetVal on 3/28/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRequest.h"
#import <CoreLocation/CLLocation.h>
@interface NSString (Location)
+ (NSString *)locationToString:(CLLocationCoordinate2D)coordinate2D;
+ (NSString *)locationToStringR:(CLLocationCoordinate2D)coordinate2D;
@end

@interface LBSRequest (LBSSearchNearby)
+ (NSURL *)searchRegionBaseURL;
// 具体使用见
//- (void)loadDataWithNearby:(CLLocationCoordinate2D)location radius:(NSUInteger)radius index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
+ (LBSRequest *)RequestWithDistanceConfiguration:(NSDictionary *)info;
@end

@interface LBSRequest (LBSLocation)
+ (void)updateCurrentLocationWithHandler:(void(^)(CLLocation *location))handler;
@end