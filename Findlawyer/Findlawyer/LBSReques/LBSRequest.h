//
//  LBSRequest.h
//  LBSYunDemo
//
//  Created by RetVal on 3/26/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

@class LBSRental, LBSRequest;
/*
 *LBSRequestHandler 用于处理LBSManager所返回的信息
 *数据从LBS云返回解析后，每个对象会一次回调LBSRequestHandler，当dataModel为nil时为结束
 *如果没有数据或者出错，dataModel也为nil, 建议当发现dataModel为nil时，检查LBSRequest的error属性是否被设置
 */
typedef void (^LBSRequestHandler)(LBSRequest *request, id dataModel);
@interface LBSRequest : NSObject
{
	@private
	id _reserved;
}
@property (strong, nonatomic) NSError * error;					// 这个请求出错信息
@property (assign, nonatomic) NSUInteger availableItemCount;	// 这个请求所能返回的条目总数
@property (strong, nonatomic) id userInfo;
@property (strong, nonatomic, readonly) NSURL * requestURL;		// 这个请求对应的URL
+ (void)RequestWithURL:(NSURL *)requestURL handler:(void(^)(LBSRequest *request, NSArray * dataModels))handler;

- (id)initWithURL:(NSURL *)requestURL;
- (NSArray *)requestWithError:(NSError **)error;
- (void)requestWithHandler:(LBSRequestHandler)handler;
@end

FOUNDATION_EXPORT NSString * const kLBSRequestQuery;		// NSString
FOUNDATION_EXPORT NSString * const kLBSRequestRegion;	// NSString
FOUNDATION_EXPORT NSString * const kLBSRequestFilter;	// NSArray (NSString)
FOUNDATION_EXPORT NSString * const kLBSRequestGeotable;	// NSString
FOUNDATION_EXPORT NSString * const kLBSRequestSortby;	// NSString

FOUNDATION_EXPORT NSString * const kLBSRequestPublicAPIKey;	// NSString
FOUNDATION_EXPORT NSString * const kLBSRequestPrivateAPIKey; // NSString
FOUNDATION_EXPORT NSString * const kLBSRequestTimeStamp;		// NSNumber(int)

FOUNDATION_EXPORT NSString * const kLBSRequestScope;		// NSNumber (uint32)
FOUNDATION_EXPORT NSString * const kLBSRequestPageIndex; // NSNumber (uint32)
FOUNDATION_EXPORT NSString * const kLBSRequestPageSize;	// NSNumber (uint32)
FOUNDATION_EXPORT NSString * const kLBSRequestRadius;	// NSNumber (uint32)
FOUNDATION_EXPORT NSString * const kLBSRequestLocation;	// NSString (locationToString)

FOUNDATION_EXPORT NSString * const kLBSRequestUpdateLocation; // NSString (transfer to NSURL by caller)