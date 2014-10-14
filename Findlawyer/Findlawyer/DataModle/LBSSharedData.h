//
//  LBSSharedData.h
//  LBSYunDemo
//
//  Created by RetVal on 4/3/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LBSLawfirm;
@class LBSLawyer;

@interface LBSSharedData : NSObject
+ (id)sharedData;
@property (assign, atomic) NSUInteger regionIdx;
@property (assign, atomic) NSUInteger priceRangeIdx;
@property (assign, atomic) NSUInteger rentalTypeIdx;
@property (assign, atomic) NSUInteger locationTypeIdx;

@property (assign, atomic) NSUInteger currentIndex;
@property (assign, atomic) NSUInteger currentPageSize;
@property (assign, atomic) CLLocationCoordinate2D currentCoordinate2D;
- (id)lastResult;
- (void)setResult:(id)result;

@end

@interface LBSLocationAnnotation : NSObject<BMKAnnotation>

@property (strong, nonatomic) LBSLawfirm *lawfirm;
- (id)initWithLawfirm:(LBSLawfirm *)Lawfirm;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end



@interface LBSLawyerLocationAnnotation : NSObject<BMKAnnotation>

@property (strong, nonatomic) LBSLawyer *lawyer;

- (id)initWithLawyer:(LBSLawyer *)lawyer;
- (CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;

@end


