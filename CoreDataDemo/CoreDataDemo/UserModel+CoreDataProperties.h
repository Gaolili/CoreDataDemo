//
//  UserModel+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by gaolili on 16/8/8.
//  Copyright © 2016年 Mac. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *phone;

@end

NS_ASSUME_NONNULL_END
