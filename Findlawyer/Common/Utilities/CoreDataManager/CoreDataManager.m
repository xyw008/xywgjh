//
//  CoreDataManager
//  zmt
//
//  Created by admin on 13-4-10.
//  Copyright (c) 2013年 龚俊慧. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//托管对象上下文

@end

static CoreDataManager *staticCoreDataManager;

@implementation CoreDataManager

- (id)init
{
    if(self = [super init])
    {
        if (!self.managedObjectContext)
        {
            //指定存储数据文件(CoreData是建立在SQLite之上的,文件后缀名为:xcdatamodel)
            NSString *persistentStorePath = GetDocumentPathFileName(@"zmt.sqlite");
            
            //创建托管对象模型
            NSManagedObjectModel  *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            
            //创建持久化存储协调器,并使用SQLite数据库做持久化存储
            NSURL *storeUrl = [NSURL fileURLWithPath:persistentStorePath];
            NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
            
            NSError *error = nil;
            NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
            
            //创建托管对象上下文
            if (persistentStore && !error)
            {
                NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
                [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
                
                self.managedObjectContext = managedObjectContext;
            }
        }
    }
    return self;
}

+ (CoreDataManager *)shareCoreDataManagerManager
{
    if(nil == staticCoreDataManager)
    {
        staticCoreDataManager = [[CoreDataManager alloc] init];
    }
    return staticCoreDataManager;
}

- (id)createEmptyObjectWithEntityName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

- (NSArray *)getListWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptions entityName:(NSString *)entityName limitNum:(NSNumber *)limitNum
{
    NSError *error = nil;
    
    //创建取回数据请求
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    /*
    //设置要检索哪种类型的实体对象 为实体对象，这个通常与数据表同名
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];

    //设置请求实体
    [fetchRequest setEntity:entity];
     */
    
    //设置查询条件
    [fetchRequest setPredicate:predicate];
    
    //设置排序条件
    [fetchRequest setSortDescriptors:sortDescriptions];
    
    /*
    [fetchRequest setResultType:NSManagedObjectIDResultType];

    [fetchRequest setReturnsDistinctResults:YES];

    NSArray *array = [[NSArray alloc] initWithObjects:@"loginName", nil];
    [fetchRequest setPropertiesToFetch:array];
    */
     
    //查询条件的总数
    [fetchRequest setFetchLimit:[limitNum intValue]];
    
    //执行获取数据请求,返回数组
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchResult;
}

- (void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
    
    [self save];
}

- (void)removeAllObjectWithEntityName:(NSString *)entityName
{
    NSArray *allObjects = [self getListWithPredicate:nil sortDescriptors:nil entityName:entityName limitNum:nil];
    
    if (allObjects && 0 != allObjects.count)
    {
        for (NSManagedObject *object in allObjects)
        {
            [self.managedObjectContext deleteObject:object];
        }
        [self save];
    }
}

- (BOOL)save
{
    NSError *error = nil;
    
    return [self.managedObjectContext save:&error];
}

@end
