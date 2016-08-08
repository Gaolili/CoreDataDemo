//
//  ViewController.m
//  CoreDataDemo
//
//  Created by gaolili on 16/8/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"
#import "UserModel+CoreDataProperties.h"
#import "CoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setTitle:@"add" forState:UIControlStateNormal];
    add.backgroundColor = [UIColor redColor];
    [add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:add];
    
    add.frame = CGRectMake(20, 100, 60, 30);
    
    UIButton * delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"delete" forState:UIControlStateNormal];
    delete.backgroundColor = [UIColor redColor];
    [delete addTarget:self action:@selector(deleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:delete];
    delete.frame = CGRectMake(110, 100, 60, 30);
    
    
    UIButton * allDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [allDelete setTitle:@"allDelete" forState:UIControlStateNormal];
    allDelete.backgroundColor = [UIColor redColor];
    [allDelete addTarget:self action:@selector(allDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [allDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:allDelete];
    allDelete.frame = CGRectMake(200, 100, 80, 30);
}


- (void)addBtn{
    CoreDataManager * dataManager = [CoreDataManager shareInstance];
    
    UserModel * model = [NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:dataManager.managedObjectContext];
    model.name = @"gaolili";
    model.age = @(22);
    model.address = @"beijin";
    model.phone = @"183103464595";
    
    UserModel * model2 = [NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:dataManager.managedObjectContext];
    model2.name = @"傻瓜";
    model2.age = @(22);
    model2.address = @"beijin";
    model2.phone = @"183103464595";
    
    
    NSLog(@"沙盒路径为：%@",NSHomeDirectory());
    
    // 插入
    [dataManager insertCoreData:@[model,model2]];
    
    NSArray * selectArray = [dataManager selectInTableName:@"UserModel" andPageSize:10 andOffset:0 andCondition:@"name='gaolili'"];
    
    NSLog(@"查询一数组有%lu",(unsigned long)selectArray.count);
    
}


-(void)deleteBtn{
    CoreDataManager * dataManager = [CoreDataManager shareInstance];
    [dataManager deleteDataInTable:@"UserModel" andCondition:@"name='gaolili'"];
}

- (void)allDeleteBtn{
    CoreDataManager * dataManager = [CoreDataManager shareInstance];
    [dataManager deleteAllDataInTable:@"UserModel"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
