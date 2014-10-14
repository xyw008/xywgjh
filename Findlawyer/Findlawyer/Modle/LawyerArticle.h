//
//  LawyerArticle.h
//  Find lawyer
//
//  Created by macmini01 on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//
// 律师文章数据模型
#import <Foundation/Foundation.h>

@interface LawyerArticle : NSObject

@property (nonatomic,strong)NSString * strCateName;
@property (nonatomic) NSInteger  typeID;
@property (nonatomic,strong) NSArray * ariticleList;
@property (nonatomic)BOOL ifHaveLoaded;

@end
