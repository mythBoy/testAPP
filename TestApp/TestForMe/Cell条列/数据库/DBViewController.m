//
//  DBViewController.m
//  TestForMe
//
//  Created by Music on 2018/3/23.
//  Copyright © 2018年 Dance. All rights reserved.
//  1 建立学生表 包括 1学号2姓名3年龄4性别
//  2 查出年龄在 年龄13的所有学生 （11-15）
//

#import "DBViewController.h"

@interface DBViewController ()

@end

@implementation DBViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // create
    NSString *createTable = @"create table if not exists stu_table (primarykey autoId not null,sid integer,name text default ’无名指‘,age interger,sex integet)";
   
    NSString *add    =  @"insert into stu_table (sid,name,age， )value ('101','张华'，20)";
    NSString *delete = @"delete from stu_table where name = '张华'";
    NSString *change = @"update stu_table name = '小美' where name = 小华'";
    NSString *select = @"selected sid,name,age from stu_table where sex = 0";
    
    NSString *sel = @"selected sid,name,sex from stu_table where age=13";
    
    
}
- (int)max:(int)x y:(int)y
{
    return x+y;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
  //create table if not exists 表名 (字段1 约束，字段2 约束)；

 // insert into tableName (字段，字段) value（字段1值，字段2值）;
 // delete from 表名 where 条件
 // update 表名 (字段1 = 修改值，字段2 = 修改值) where 条件
 // selected 查询的字段 from 表名 where 条件
