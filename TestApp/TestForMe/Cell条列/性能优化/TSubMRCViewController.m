//
//  TSubMRCViewController.m
//  TestForMe
//
//  Created by Music on 2018/1/16.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "TSubMRCViewController.h"

@interface TSubMRCViewController ()
{
    
  __weak  NSString *weak_String;
  __weak  NSString *weak_StringAutorelease;
}
@end

@implementation TSubMRCViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//
//            @autoreleasepool {
//                [self createString];
//                NSLog(@"------in the autoreleasepool------");
//                NSLog(@"%@===%lu", weak_String ,(unsigned long)[weak_String retainCount]);
//                NSLog(@"%@\n\n===%lu", weak_StringAutorelease,(unsigned long)[weak_String retainCount]);//
//
//
//            }
//            NSLog(@"------in the main()------");
//            NSLog(@"%@===%lu", weak_String,(unsigned long)[weak_String retainCount]);  //1 这厮没有为空
////            NSLog(@"%@===%lu", weak_StringAutorelease,(unsigned long)[weak_String retainCount]); //stringWithFormat 该API 调用了autorelease 所以poor 之后为空
//
//}
//
//- (void)createString
//{
//    NSString *string = [[NSString alloc] initWithFormat:@"Hello, World!"];    // 创建常规对象
//    NSString *stringAutorelease = [NSString stringWithFormat:@"Hello, World! Autorelease"]; // 创建autorelease对象
//
//    weak_String = string;
//    weak_StringAutorelease = stringAutorelease;
//
//    NSLog(@"------in the createString()------");
//    NSLog(@"%@===%lu", weak_String, (unsigned long)[weak_String retainCount]);   //1
//    NSLog(@"%@\n\n===%lu", weak_StringAutorelease,(unsigned long)[weak_String retainCount]);// 1
//
//}
///*
// 结论 api  带autorelease的方法，作用域结束不会释放，stringWithFormat 自动释放池结束才会销毁 例如 stringAutorelease
// */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    @autoreleasepool {
        [self createString];
        NSLog(@"------in the autoreleasepool------");
        NSLog(@"%@===", weak_String);
        NSLog(@"%@\n\n===", weak_StringAutorelease);//
        
        
    }
    NSLog(@"------in the main()------");
    NSLog(@"%@===", weak_String);  //1 这厮没有为空
                NSLog(@"%@===", weak_StringAutorelease); //stringWithFormat 该API 调用了autorelease 所以poor 之后为空
    
}

- (void)createString
{
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, World!"];    // 创建常规对象
    NSString *stringAutorelease = [NSString stringWithFormat:@"Hello, World! Autorelease"]; // 创建autorelease对象
    
    weak_String = string;
    weak_StringAutorelease = stringAutorelease;
    
    NSLog(@"------in the createString()------");
    NSLog(@"%@===", weak_String );   //1
    NSLog(@"%@\n\n===", weak_StringAutorelease);// 1
    
}
/*
 结论 api  带autorelease的方法，作用域结束不会释放，stringWithFormat 自动释放池结束才会销毁 例如 stringAutorelease
 */
@end
