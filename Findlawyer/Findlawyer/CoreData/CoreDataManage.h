//
//  CoreDataManage.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//
// 用来管理数据库，暂时还没用到
#import <Foundation/Foundation.h>

@interface CoreDataManage : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, nonatomic) NSInteger uid;
@property (readonly, nonatomic) BOOL upgrading;

+ (CoreDataManage *)sharedCoreDataMg;

//- (void)upgrade; // 升级数据库
- (void)saveContext;


@end

