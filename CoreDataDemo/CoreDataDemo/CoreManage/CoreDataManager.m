//
//  CoreDataManager.m
//  LearnDemo
//
//  Created by gaolili on 16/8/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "CoreDataManager.h"
#import "UserModel.h"

@implementation CoreDataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(instancetype)shareInstance{
    static CoreDataManager * _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[CoreDataManager alloc]init];
    });
    return _shareInstance;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    //  CoreDataBase 这块注意是 你创建的数据库名称
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataBase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //CoreDataDemoCoreData.sqlite : 注意是 项目名称+CoreData.sqlite
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataDemoCoreData.sqlite"];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.获取Documents路径
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (void)insertCoreData:(NSArray*)dataArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    for ( int i=0 ;i<dataArray.count ;i++) {
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

//查询
// 限定查询结果的数量
//setFetchLimit
// 查询的偏移量
//setFetchOffset
- (NSArray*)selectInTableName:(NSString *)tableName andPageSize:(int)pageSize andOffset:(int)currentPage
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    [fetchRequest setFetchLimit:pageSize];
    [fetchRequest setFetchOffset:currentPage];

    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
   
    return fetchedObjects;
}

- (NSArray*)selectInTableName:(NSString *)tableName andPageSize:(int)pageSize andOffset:(int)currentPage andCondition:(NSString *)condition{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
     [fetchRequest setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:context]];
    [fetchRequest setFetchLimit:pageSize];
    
    [fetchRequest setFetchOffset:currentPage];
    //设置条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
    fetchRequest.predicate = predicate;
    
    //查询
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];
    return ary;
}


//删除
-(void)deleteAllDataInTable:(NSString *)tableName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}

-(void)deleteDataInTable:(NSString *)tableName  andCondition:(NSString *)condition{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:tableName];
    //设置条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
    fetchRequest.predicate = predicate;
    
    //查询
    NSArray *ary = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error = nil;
    //查询
    if (!error && ary && [ary count])
    {
        for (NSManagedObject *obj in ary)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }
}



//更新 目前还没完善，
- (void)updateInTable:(NSString *)tableName  andlook:(NSString*)looksId  andOldValue:(NSString *)oldValue  andNewValue:(NSString*)newValue
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"looksId like[cd] %@",looksId];
    
    //首先你需要建立一个request
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:tableName inManagedObjectContext:context]];
    [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    //这里获取到的是一个数组，你需要取出你要更新的那个obj
    
//    Class cls = NSClassFromString(tableName);
//    for (cls * info in result) {
//        info.phone = islook;
//    }
    
    //保存
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}
@end
