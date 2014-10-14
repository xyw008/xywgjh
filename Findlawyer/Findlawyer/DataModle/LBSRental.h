//
//  LBSRental.h
//  LBSYunDemo
//
//  Created by RetVal on 3/25/13.
//  Copyright (c) 2013 RetVal. All rights reserved.
//

#import <CoreLocation/CLLocation.h>

/*
 租房信息的载体
 */
@interface LBSRental : NSObject
#if TARGET_OS_IPHONE
@property (strong, nonatomic) UIImage *mainImage;           // 租房的缩略图
#endif
@property (strong, nonatomic) NSURL *mainImageURL;          // 缩略图的url
@property (strong, nonatomic) NSString *rentalName;         // 租房名称
@property (strong, nonatomic) NSString *rentalType;         // 租房类型
@property (strong, nonatomic) NSString *locationName;       // 地理信息
@property (strong, nonatomic) NSString *detail;             // 具体详细
@property (strong, nonatomic) NSString *districtName;       // 街道信息
@property (strong, nonatomic) NSURL *roomURL;

@property (assign, nonatomic) NSUInteger price;             // 租房价格
@property (assign, nonatomic) NSUInteger distance;          // 距离
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;    // 房屋坐标


- (id)initWithDataModel:(NSDictionary *)dataModel;          // 初始化
@end
