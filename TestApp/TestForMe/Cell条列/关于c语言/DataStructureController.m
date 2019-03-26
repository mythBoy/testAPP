//
//  DataStructureController.m
//  TestForMe
//
//  Created by Show on 2019/3/25.
//  Copyright © 2019 Dance. All rights reserved.
//


#import "DataStructureController.h"

//标准定义  [10.1]
struct student {
    int age;
    int height;
    char name[10];

};

@interface DataStructureController ()

@end

@implementation DataStructureController

// 方法一 先定义 后实例化
void demo1()
{
    struct person{
        int age;
        int height;
        char name[10];
    };
    
    struct dog xiaoming = {17,180,"xiaoming"};
    hony = xiaoming;//这样的 不能再去实例化

}

// 方法二 定义+实例化   [10.2]
struct dog {
    int age;
    int height;
    char name[10];
    
}hony = {5,110,"hony"};

- (void)viewDidLoad
{
    [super viewDidLoad];
    //引用
    // 1 结构体 .语法直接引用
    struct dog dabai = {3,90,"dabai"};
    dabai.age = 4;
    printf("-->1--年龄=%d-高度=%d-名字=%s\n",dabai.age,dabai.height,dabai.name);
    
    // 2 结构体指针  -> (*结构体指针) 引用
    struct dog *dogPoint = &dabai;
    printf("-->2--年龄=%d-高度=%d-名字=%s\n",(*dogPoint).age,(*dogPoint).height,(*dogPoint).name);
    printf("-->3--年龄=%d-高度=%d-名字=%s\n",dogPoint->age,dogPoint->height,dogPoint->name);

    
}

@end



// 备注
/*
  [10.1]
 !!!  Flexible array member 'name' with type 'char []' is not at the end of struct
      成员name类型为chars的可变数组 不在结构体的最后面.
struct student {
    //    char name[]; // 放着还不行 啧啧!!
    int age;
    int height;

    
};

*/


/*
 [10.2]
 !!! 这种声明的对象 只能赋值 不能初始化
 struct dog {
 int age;
 int height;
 char name[10];
 
 }hony;
 
 
 struct dog xiaoming = {17,180,"xiaoming"};
 hony = xiaoming;
 //    {17,180,"xiaoming"};
 */
