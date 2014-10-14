//
//  LBSLawfirm.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.

//律所数据模型

#import <Foundation/Foundation.h>

@interface LBSLawfirm : NSObject


@property (strong,nonatomic)  NSNumber *lfid;
@property (strong, nonatomic) NSNumber * memberCount;
@property (strong,nonatomic)  NSMutableArray *arImageUrlstrs;
@property (strong, nonatomic) UIImage  *mainImage;           // 律所缩略图
@property (strong, nonatomic) NSURL    *mainImageURL;   // 律所缩略图的url
@property (strong, nonatomic) NSString *name;               // 律所名称
@property (strong, nonatomic) NSString *detail;             // 具体详细
@property (strong, nonatomic) NSString *address;            // 具体地址
@property (strong, nonatomic) NSString *detailaddress;     // 具体详细地址
@property (strong, nonatomic) NSString *district;           // 律所地区
@property (strong, nonatomic) NSString *city;               // 律所城市
@property (strong, nonatomic) NSString *tel;                // 电话
@property (strong, nonatomic) NSString *fax;                // 律所传真
@property (strong, nonatomic) NSString *mailBox;            // 邮箱
@property (strong, nonatomic) NSMutableArray  *lawyerist;   // 律师列表


@property (assign, nonatomic) NSUInteger distance;                  // 距离
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;    // 律所坐标
- (id)initWithDataModel:(NSDictionary *)dataModel;                  // 初始化

@end
