//
//  CoreDataManager.h
//  LearnDemo
//
//  Created by gaolili on 16/8/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define TableName @"UserModel"

@interface CoreDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(instancetype)shareInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/**
 *  插入数据
 *
 *  @param dataArray 将数据插入到对应的数据表里
 */
- (void)insertCoreData:(NSArray*)dataArray;
/**
 *  查询指定数据表里的数据
 *
 *  @param tableName   数据表名称
 *  @param pageSize    查询多少条
 *  @param currentPage 从多少条开始查找
 *
 *  @return 返回查找符合条件的数组
 */
- (NSArray*)selectInTableName:(NSString *)tableName andPageSize:(int)pageSize andOffset:(int)currentPage
;
/**
 *  查询指定数据表里的数据
 *
 *  @param tableName   数据表名称
 *  @param pageSize    查询多少条
 *  @param currentPage 从多少条开始查找
 *  @param condition   查找的条件
 *
 *  @return 返回查找符合条件的数组
 */
- (NSArray*)selectInTableName:(NSString *)tableName andPageSize:(int)pageSize andOffset:(int)currentPage andCondition:(NSString *)condition;
/**
 *  删除数据表里的全部数据
 *
 *  @param tableName 数据表名称
 */
- (void)deleteAllDataInTable:(NSString *)tableName;
/**
 *  删除数据表里的符合条件的数据
 *
 *  @param tableName 数据表名称
 *  @param condition 添加删除条件
 */
-(void)deleteDataInTable:(NSString *)tableName  andCondition:(NSString *)condition;


@end
