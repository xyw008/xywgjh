//
//  LBSRequestManager.h
//  LBSYunDemo
//
//  Created by RetVal on 3/27/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//
@class LBSRental, CLLocation;
#include "LBSRequest.h"

@interface LBSRequestManager : NSObject


+ (id)defaultManager;
/*
 *向LBSRequestManager加入一条请求
 *addRequest:complete:	收到数据并且本地化后，将内容放入contents, 回调handler
 *
 *addRequest:pieceComplete: 收到数据并且本地化后，将逐条信息放入dataModel后调用handler (稍微变的方便些，不用每次在回调做循环处理)
 *
 *addRequest:locationUpdateComplete: 这条请求必须是[[LBSRequest alloc] initWithURL:[NSURL URLWithString:kLBSRequestUpdateLocation]], 当返回获得地理信息后返回location, 如果为nil为出错
 *
 *addRequest:dataComplete: 发起一条异步请求，将数据(NSData *)放入dataModel并回调handler
 */
- (void)addRequest:(LBSRequest *)request complete:(void(^)(LBSRequest *request, NSArray *contents))handler;
- (void)addRequest:(LBSRequest *)request pieceComplete:(LBSRequestHandler)handler;
- (void)addRequest:(LBSRequest *)request locationUpdateComplete:(void(^)(BMKUserLocation *location))handler;
- (void)addRequest:(LBSRequest *)request dataComplete:(LBSRequestHandler)handler;
@end
