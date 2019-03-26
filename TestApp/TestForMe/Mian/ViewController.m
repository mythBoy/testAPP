//
//  ViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/8.
//  Copyright © 2017年 Dance. All rights reserved.
//


#import "ViewController.h"
#import "TableViewController.h"
#import "MiddleViewController.h"
#import "Person.h"
#import <objc/runtime.h>
#define JR_COUNT 10
#import "CusView.h"
@interface ViewController ()<CusViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"main";
    self.view.backgroundColor = [UIColor grayColor];
    //
    CusView *a =  [[CusView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];a.delegate = self;
    a.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:a];
//    [self MMMMMM];
    
  
}

//选择排序
- (void)choicePaiXu
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@49,@27,@65,@97,@76,@12,@38,nil];
    
    
    for (int i=0; i<array.count; i++) {
        
        for (int j=i+1; j<array.count; j++) {
            
            if (array[i]>array[j]) {
                
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                
            }
            
        }
         NSLog(@"第%d趟--%@",i+1,array);
    }
    
    NSLog(@"%@",array);
//    NSLog(@"%@",array);
}
/*    316254
 136254   0
 126354   1
 123654   2
 123456   3
 123456   4
 123456   5
 */
- (void)maopaiPaixu
{
    NSMutableArray * array1 =[[NSMutableArray alloc]initWithObjects:@"5",@"1",@"6",@"4" ,@"2",@"3",nil];
    
    //冒泡
    
    for (int i =0; i< array1.count-1; i++) {//循环4次 0、1、2/3
//
        for (int j =0; j< array1.count-1-i; j++) {//i= 0 循环count= 5-1-0 = 4
            

//             NSLog(@"--wai --当i=%d--j=%d-\n%@",i,j,array1);
//             NSLog(@"==比较%@和%@",array1[j],array1[j+1]);
            if(([array1[j] compare:array1[j+1]]) == NSOrderedDescending){//两者比较 =降序 前后>后者 j大 j+1小
               
                [array1 exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                
//                NSLog(@"--内--当i=%d--j=%d-\n%@",i,j,array1);
                
                
            }
            
        }
    }

    NSLog(@"%@",array1);
}


/*
//i= 0 j=0 循环count= 5-1-0 = 4次
 取出 array1[0] compare:array1[0+1] 5/1 比较 交换后 得到 15642
 i= 0 j =1 循环count= 5-1-0 = 4次
 取出 array1[1] compare:array1[1+1] 5/6 比较 交换后 得到 15642
 i= 0 j =2 循环count= 5-1-0 = 4次
 取出 array1[2] compare:array1[2+1] 6/4 比较 交换后 得到 15462
 i= 0 j =3 循环count= 5-1-0 = 4次
 取出 array1[3] compare:array1[3+1] 6/4 比较 交换后 得到 15426

 i= 1 j =0 循环count= 5-1-1 = 3次
 取出 array1[0] compare:array1[0+1] 1/5 比较 交换后 得到 15426
 i= 1 j =1 循环count= 5-1-1 = 3次  比较j j+1
 取出 array1[1] compare:array1[1+1] 5/4 比较 交换后 得到 14526
 i= 1 j =2 循环count= 5-1-1 = 3次  比较j j+1
 取出 array1[2] compare:array1[2+1] 5/2 比较 交换后 得到 14256
 
 i= 2 j =0 循环count= 5-1-2 = 2次  比较j j+1
 取出 array1[0] compare:array1[0+1] 1/4 比较 交换后 得到 14256
 i= 2 j =1 循环count= 5-1-2 = 2次  比较j j+1
 取出 array1[1] compare:array1[1+1] 4/2 比较 交换后 得到 12456
 
 
 i= 3 j =1 循环count= 5-1-3 = 1次  比较j j+1
 取出 array1[0] compare:array1[0+1] 1/2 比较 交换后 得到 12456
 
 */




- (void)mao
{
    
    NSMutableArray *array = @[@"5",@"3",@"6",@"2",@"1",@"4"].mutableCopy;
    for (int j= 0; j<array.count-1; j++) {
  
    
        for (int i= 0; i<array.count-1; i++) {

            NSNumber *num1 =  [NSNumber numberWithInt:[array[i] intValue]];
            NSNumber *num2 =  [NSNumber numberWithInt:[array[i+1] intValue]];
            
            if ( [num1 compare:num2]  == NSOrderedDescending) {//
                [array exchangeObjectAtIndex:i withObjectAtIndex:i+1];
            }
         NSLog(@"第%d趟-%@",j,array);
           
        }
//         NSLog(@"第%d趟-%@",j,array);
    }
    NSLog(@"%@",array);
}


- (void)chiceMMM
{
    NSMutableArray *array = @[@49 ,@27 ,@65 ,@97 ,@76 ,@12 ,@38].mutableCopy;// count =7

    //
    for (int i = 0; i < array.count - 1; i++) {   //比较的趟数  循环6次  0-5
        int minIndex = i;//查找最小值 0
                for (int j = minIndex +1; j < array.count; j++ ) {
                     NSLog(@"比较%d和%d",[array[minIndex] intValue], [array[j] intValue]);
                    if ([array[minIndex] intValue] > [array[j] intValue]) {
                        minIndex = j;
                        NSLog(@"i==%d--j==mid=%d",i,j);
                    }
                }
                //如果没有比较到最后还剩余一个数,那么就执行下面的操作
                if (minIndex != i) {
                    //交换数据
                    [array exchangeObjectAtIndex:minIndex withObjectAtIndex:i];
                    NSLog(@"%@ %@ %@ %@ %@ %@ %@",array[0],array[1],array[2],array[3],array[4],array[5],array[6]);
                }
        NSLog(@"第%d趟%@",i+1,array);
    }
    NSLog(@"%@",array);


}

/*
 i = 0  j=1 比较49 27 minindex = 1
 z
 
 
 
 */



 //gcd 几个操作结束后 统一操作
- (void)DXCForGCD
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    

    dispatch_group_async(group, queue, ^{
        NSLog(@"11111--%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
         NSLog(@"2222----%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
         NSLog(@"3333----%@",[NSThread currentThread]);
    });
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
           NSLog(@"finish----%@",[NSThread currentThread]);
    });
       
    });
}

- (void)MMMMMM
{
    NSMutableArray *array = @[@6,@5,@1,@4,@11,@2,@110,@90].mutableCopy;
    for (int i = 0; i<array.count-1; i++) {
        for (int j=0; j<array.count-1-i; j++) {

                if ([array[j] compare:array[j+1]] == NSOrderedDescending) {
                    [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }

        }
    }
    NSLog(@"%@",array);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSMutableArray *array =  @[@24, @17, @85, @13, @9, @54, @76, @45, @5, @63].mutableCopy;
//    for (int i = 0; i<array.count-1; i++) {//8
//        for (int j=0; j<array.count-1-i; j++) {
//            if ([array[j] compare:array[j+1] ] == NSOrderedDescending) {//前大
//                [array exchangeObjectAtIndex:j+1 withObjectAtIndex:j];
//            }
//        }
//    }
//    NSLog(@"===%@",array);
;
}

//- (NSDictionary *)zhuan
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    unsigned int outCount = 0;
//    Ivar * ivars = class_copyIvarList([Person class], &outCount);
//    for (unsigned int i = 0; i < outCount; i ++) {
//        Ivar ivar = ivars[i];
//        const char * name = ivar_getName(ivar);//实例变量名称
//        const char * type = ivar_getTypeEncoding(ivar);//实例变量类型
//        
//        NSString *typeStr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];//实例变量类型
//        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];//实例变量名称
//        NSString *insName = [nameStr substringFromIndex:1];//实力变量名称 去_
//        
//        if ([typeStr  isEqualToString:@"i"]) {
//            dict[insName] = [[NSNumber alloc] initWithInt:];
//        }
//        NSLog(@"类型为 %s 的 %s ",type, name);
//        
//    }
//    free(ivars);
//    
//    
//    return dict;
//}



@end
