//
//  LBSSharedData.m
//  LBSYunDemo
//
//  Created by RetVal on 4/3/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSSharedData.h"
#import "LBSLawfirm.h"
#import "LBSLawyer.h"
static LBSSharedData * __LSSharedDataInstance = nil;
@interface LBSSharedData()
{
	id _result;
}
@property (strong, atomic, getter = lastResult) id result;
@end
@implementation LBSSharedData
+ (id)sharedData
{
	if (__LSSharedDataInstance) return __LSSharedDataInstance;
	__LSSharedDataInstance = [[[self class] alloc] init];
	return __LSSharedDataInstance;
}

- (id)lastResult
{
	return _result;
}

- (void)setResult:(id)result
{
	_result = result;
}
@end

@implementation LBSLocationAnnotation

- (id)initWithLawfirm:(LBSLawfirm *)Lawfirm
{
	if (self = [super init])
	{
		_lawfirm = Lawfirm;
	}
	return self;
}

- (NSString *)title
{
	return _lawfirm.name;
}

- (NSString *)subtitle
{
	return _lawfirm.address;
}

- (CLLocationCoordinate2D)coordinate
{
	return _lawfirm.coordinate;
}
@end

@implementation LBSLawyerLocationAnnotation

- (id)initWithLawyer:(LBSLawyer *)Lawyer
{
	if (self = [super init])
	{
		_lawyer = Lawyer;
	}
	return self;
}

- (NSString *)title
{
	return _lawyer.name;
}

- (NSString *)subtitle
{
	return _lawyer.address;
}

- (CLLocationCoordinate2D)coordinate
{
	return _lawyer.coordinate;
}
@end

