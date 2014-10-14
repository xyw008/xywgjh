//
//  LBSRequest+LBSSearchRegion.h
//  LBSYunDemo
//
//  Created by RetVal on 3/27/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import "LBSRequest.h"

@interface LBSRequest (LBSSearchRegion)
+ (NSURL *)searchRegionBaseURL;
/*
 支持组合搜索 具体用法见
 - (void)loadDataWithRegionName:(NSString *)regionName priceRange:(NSRange)priceRange rentalType:(NSUInteger)type index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler
 */
+ (LBSRequest *)RequestWithRegionConfiguration:(NSDictionary *)info;

@end
