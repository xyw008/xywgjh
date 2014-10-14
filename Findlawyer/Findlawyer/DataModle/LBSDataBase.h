//
//  LBSDataBase.h
//  LBSYunDemo
//
//  Created by RetVal on 3/24/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Foundation/Foundation.h>
/*LBSDataBase
 *处理LBSCoreDataInfo中的内容
 */
@interface LBSDataBase : NSObject
+ (id)sharedInstance;
- (NSUInteger)numberOfAllItems;
- (NSUInteger)indexOfItem:(NSString*)item;
- (NSArray *)itemsNames;
- (NSArray*)placeNames;
- (NSArray*)priceRanges;
- (NSArray*)rentalTypes;
- (NSArray*)nearbyRadius;
@end

FOUNDATION_EXPORT const NSUInteger kLBSPlaceIndex;
FOUNDATION_EXPORT const NSUInteger kLBSPriceIndex;
FOUNDATION_EXPORT const NSUInteger kLBSRentalIndex;
FOUNDATION_EXPORT const NSUInteger kLBSNearbyIndex;