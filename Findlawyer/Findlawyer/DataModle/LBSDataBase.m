//
//  LBSDataBase.m
//  LBSYunDemo
//
//  Created by RetVal on 3/24/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSDataBase.h"

static LBSDataBase* __LSDataBaseInstance = nil;
/**************************************************/
static const NSString* kLBSItem = @"LBSItem";
static const NSString* kLBSItemNames = @"names";
static const NSString* kLBSItemIndexNumber = @"indexes";
/**************************************************/
static const NSString* kLBSPlace = @"LBSPlace";
static const NSString* kLBSPlacesNames = @"names";

/**************************************************/
static const NSString* kLBSPrice = @"LBSPrice";
static const NSString* kLBSPriceRanges = @"ranges";

/**************************************************/
static const NSString* kLBSRental = @"LBSRentalMode";
static const NSString* kLBSRentalTypes = @"types";

/**************************************************/
static const NSString* kLBSNearby = @"LBSNearby";
static const NSString* kLBSNearbyRadius = @"radius";

const NSUInteger kLBSPlaceIndex = 0;
const NSUInteger kLBSPriceIndex = 1;
const NSUInteger kLBSRentalIndex = 2;
const NSUInteger kLBSNearbyIndex = 3;

@interface LBSDataBase()
{
	NSDictionary* _coreInformation;
}
@end

@implementation LBSDataBase
+ (id)sharedInstance
{
	if (__LSDataBaseInstance) return __LSDataBaseInstance;
	return __LSDataBaseInstance = [[self alloc] init];
}

- (id)init
{
	if ((self = [super init]))
	{
		_coreInformation = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LBSCoreDataInfo" ofType:@"plist"]];
	}
	return self;
}

- (NSUInteger)numberOfAllItems
{
	return [[[_coreInformation objectForKey:kLBSItem] objectForKey:kLBSItemNames] count];
}

- (NSUInteger)indexOfItem:(NSString*)item;
{
	return [((NSNumber*)([[[_coreInformation objectForKey:kLBSItem] objectForKey:kLBSItemIndexNumber] objectAtIndex:[[[_coreInformation objectForKey:kLBSItem] objectForKey:kLBSItemNames] indexOfObject:item]])) unsignedIntegerValue];
}

- (NSArray *)itemsNames
{
	return [[_coreInformation objectForKey:kLBSItem] objectForKey:kLBSItemNames];
}

- (NSArray *)placeNames
{
	return [[_coreInformation objectForKey:kLBSPlace] objectForKey:kLBSPlacesNames];
}

- (NSArray *)priceRanges
{
	return [[_coreInformation objectForKey:kLBSPrice] objectForKey:kLBSPriceRanges];
}

- (NSArray *)rentalTypes
{
	return [[_coreInformation objectForKey:kLBSRental] objectForKey:kLBSRentalTypes];
}

- (NSArray *)nearbyRadius
{
	return [[_coreInformation objectForKey:kLBSNearby] objectForKey:kLBSNearbyRadius];
}
@end
