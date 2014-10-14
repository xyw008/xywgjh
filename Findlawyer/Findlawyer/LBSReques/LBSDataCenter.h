//
//  LBSDataCenter.h
//  LBSYunDemo
//
//  Created by RetVal on 3/29/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "LBSRequest.h"
/*LBSDataCenter
 *
 */
@class LBSRequestManager;
@interface LBSDataCenter : NSObject

@property (nonatomic) NSInteger requestiMode;
+ (id)defaultCenter;

//setDataBox: 设置app的databox序号
- (void)setDataBox:(NSUInteger)dataBoxID;

//setCloudKey: 设置app的ak
- (void)setCloudKey:(NSString *)key;

// 用于ui适配，判断是否是iPhone5
- (BOOL)isIphone5;

//加载周边信息
/*@param location 希望得到信息的中心坐标
 *@param raduis 中心半径
 *@param index 信息的页号
 *@param pageSize 每页的信息量
 *@param searchType 搜索类型
 *@param searchType 搜索类型
 *@param handler 以信息单元为单位，每个单元都会被这个handler处理一次，详见LSRequest.h中对LBSRequestHandler的描述
 
 */
- (void)loadDataWithNearby:(CLLocationCoordinate2D)location radius:(NSUInteger)radius searchtype:(NSInteger)searchtype searchKye:(NSString *)searchkey index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler;

//在某个城市范围内搜索关键字

 /*@param searchtype 搜索类型
 *@param searchkey 搜索关键字
 *@param index 信息的页号
 *@param pageSize 每页的信息量
 *@param handler 以信息单元为单位，每个单元都会被这个handler处理一次，详见LSRequest.h中对LBSRequestHandler的描述
 */
- (void)loadDataWithRegionSearchkey:(NSString *)searchkey  searchtype:(NSInteger)searchtype  index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler;

//加载周边信息
/*@param location 希望得到信息的中心坐标
 *@param raduis 中心半径
 *@param index 信息的页号
 *@param pageSize 每页的信息量
 *@param handler 以信息单元为单位，每个单元都会被这个handler处理一次，详见LSRequest.h中对LBSRequestHandler的描述
 */

- (void)loadDataWithNearby:(CLLocationCoordinate2D)location radius:(NSUInteger)radius index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler;


//多重过滤返回信息
/*@param regionName 希望得到区域的名称
 *@param priceRange 价格区间
 *@param rentalType 租房的类型
 *@param index 信息的页号
 *@param pageSize 每页的信息量
 *@param handler 以信息单元为单位，每个单元都会被这个handler处理一次，详见LSRequest.h中对LBSRequestHandler的描述
 */
- (void)loadDataWithRegionName:(NSString *)regionName priceRange:(NSRange)priceRange rentalType:(NSUInteger)type index:(NSUInteger)index pageSize:(NSUInteger)pageSize pieceComplete:(LBSRequestHandler)handler;

@end
