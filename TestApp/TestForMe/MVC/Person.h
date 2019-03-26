//
//  Person.h
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"
#import "Man.h"
@interface Person : Man<NSCoding>
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,copy)NSString *height;
@property (nonatomic ,assign)int weight;
@property (nonatomic ,strong)Car *car;
/******解析使用****/
@property (nonatomic, copy) NSString *pid;
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *age;

//测试copy strong
@property (strong, nonatomic) NSArray *strBooks;
@property (copy, nonatomic) NSArray *copBooks;
@end
