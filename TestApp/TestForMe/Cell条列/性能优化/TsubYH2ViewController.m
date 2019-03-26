//
//  TsubYH2ViewController.m
//  TestForMe
//
//  Created by Music on 2018/1/16.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "TsubYH2ViewController.h"
#import <mach/mach.h>
#import "NSString+TNSString.h"
__weak NSString *weak_String;
__weak NSString *weak_StringAutorelease;
__weak NSString *weak_Mid_String;

@interface TsubYH2ViewController ()

@end

@implementation TsubYH2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doSomething];
}
- (void)doSomething {
    NSMutableArray *collection = @[].mutableCopy;
   __weak  NSString *_str;
    for (int i = 0; i < 20000; i++) {
       
        NSLog(@"%@",_str);
        
       NSString  *str = [NSString stringWithFormat:@"hi + %d", i];
        _str = str;
//        [collection addObject:str];
         NSLog(@" eve内存 %@--- %f",str,getMemoryUsage());;// 内存持续飙升  27开始----》
    }
    NSLog(@"finished!");
}

- (void)doSomething1 {
    NSMutableArray *collection = @[].mutableCopy;
    
    __weak    NSString *_str ;
    for (int i = 0; i < 20000; i++) {
        
 
                @autoreleasepool {
                   
                    NSString  *str =   [NSString stringWithFormat:@"hi==== %d", i];
                    _str = str;
//                    [collection addObject:str];
                    NSLog(@" eve内存 %@--- %f",str,getMemoryUsage());
                }
       NSLog(@"%@",_str);
    }
    NSLog(@"finished!");
}


- (void)place1
{
    //autorelease 日常演练
    int lagerNum = 200000;
    for (int i= 0; i<lagerNum;i++) {
        @autoreleasepool {
            NSNumber *num = [NSNumber numberWithInt:i];
            NSString *str = [NSString stringWithFormat:@"%d ", i];
            [NSString stringWithFormat:@"%@%@", num, str];
    
            NSLog(@" eve内存 %d--- %f",i,getMemoryUsage());
            
            //        if (i == lagerNum - 5) {  // 获取到快结束时候的内存
            //            float memory = getMemoryUsage();
            //            NSLog(@" 内存 --- %f",memory);
            //        }
            
        }
    }
    
}
//打印内存
double getMemoryUsage(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self_, TASK_BASIC_INFO, (task_info_t)&info, &size);
    double memoryUsageInMB = kerr == KERN_SUCCESS ? (info.resident_size / 1024.0 / 1024.0) : 0.0;
    return memoryUsageInMB;
}

/*
 place1 演练
 结论
 @autoreleasepool ：作用避免内存峰值
 数据比较
 加上 @autoreleasepool 内存恒定在27
 不加上 @autoreleasepool  内存27起 匀速飙升 结束53
 
 结论：当出现大的for循环 且循环体内api为 @autorelease时候建议加autoreleasepoor
 且：autoreleasepool 不能优化所有的循环
 
 ******************* ******************* ******************* ******************* ******************* *******************
 引申：@autoreleasepool应用场景
 
 1> 大数字for循环时候，调用autorelease API方法时候，加入@autoreleasepool{}避免内存峰值
 例如：拼接字符串操作，stringWithFormat API创建字符串，临时变量被大量创建，持续开辟内存，内存持续飙升....for循环结束，对象才会销毁，此时加入@autoreleasepool 会有帮助
 如果字符串是alloc 出来的，非autorelease API 则 @autoreleasepool  是无效的
 
 2>
 */

@end





