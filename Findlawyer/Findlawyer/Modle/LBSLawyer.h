//
//  LBSLawyer.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.

// 律师数据模型

#import <Foundation/Foundation.h>

@interface LBSLawyer : NSObject

@property (strong, nonatomic) NSNumber *lfid;
@property (strong, nonatomic) NSNumber *lawerid;
@property (strong, nonatomic) NSDictionary *dicImageUrlstrs;   //图片字典
@property (strong, nonatomic) UIImage  *mainImage;             // 律师缩略图
@property (strong, nonatomic) NSURL    *mainImageURL;          // 律师缩略图的url
@property (strong, nonatomic) NSString *name;                  // 律师名称
@property (strong, nonatomic) NSString *detail;                // 具体详细
@property (strong, nonatomic) NSString *address;               // 具体地址
@property (strong, nonatomic) NSString *district;              // 律师地区
@property (strong, nonatomic) NSString *city;                  // 律师城市
@property (strong, nonatomic) NSString *certificateNo;         // 执业证号
@property (strong, nonatomic) NSString *specialArea;           // 专业领域
@property (strong, nonatomic) NSString *lawfirmName;           // 律所名称
@property (strong, nonatomic) NSNumber *isPhoto;
@property (strong, nonatomic) NSString *tel;                // 电话
@property (strong, nonatomic) NSString *fax;                // 律所传真
@property (strong, nonatomic) NSString *mailBox;
@property (strong, nonatomic) NSString *mobile;

@property (assign, nonatomic) double distance;                      // 距离
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;    // 律师坐标

@property (nonatomic, assign) BOOL isShowMapLawyerAnnotationPaopaoView; // 是否弹出地图上的律师annotation的泡泡视图

- (id)initWithDataModel:(NSDictionary *)dataModel;                  // 初始化

@end
