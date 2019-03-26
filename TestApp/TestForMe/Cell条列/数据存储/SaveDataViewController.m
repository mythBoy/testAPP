//
//  SaveDataViewController.m
//  TestForMe
//
//  Created by Dance on 2017/4/18.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "SaveDataViewController.h"
#import "Person.h"

@interface SaveDataViewController ()
@property (nonatomic ,assign)void (^testblock)(NSString *);
@end

@implementation SaveDataViewController
-(void)loadWithUrl:(NSString *)kUrlString
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < 100; i++) {
        dispatch_async(queue, ^{
            /*
             此时semaphore信号量的值如果 >= 1时：对semaphore计数进行减1,然后dispatch_semaphore_wait 函数返回。该函数所处线程就继续执行下面的语句。
             
             此时semaphore信号量的值如果=0：那么就阻塞该函数所处的线程,阻塞时长为timeout指定的时间，如果阻塞时间内semaphore的值被dispatch_semaphore_signal函数加1了，该函数所处线程获得了信号量被唤醒。然后对semaphore计数进行减1并返回，继续向下执行。 如果阻塞时间内没有获取到信号量唤醒线程或者信号量的值一直为0，那么就要等到指定的阻塞时间后，该函数所处线程才继续向下执行。
             
             执行到这里semaphore的值总是1
             */
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            /* 因为dispatch_semaphore_create创建的semaphore的初始值为1，执行完上面的
             dispatch_semaphore_wait函数之后，semaphore计数值减1会变为0，所以可访问array对象的线程只有1个，因此可安全地对array进行操作。
             */
            [array addObject:[NSNumber numberWithInteger:i]];
            
            /*
             对array操作之后，通过dispatch_semaphore_signal将semaphore的计数值加1，此时semaphore的值由变成了1，所处
             */
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    NSLog(@"主线程思密达!~ ");
   
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor whiteColor]];

    
    NSMutableString *str =  [[NSMutableString alloc] initWithFormat:@"123"];
    NSLog(@"%p",str);
    [str appendFormat:@"456"];
    NSLog(@"%p",str);
    UIImageView  *v= [[UIImageView alloc ] init];
    _testblock = ^(NSString *a){
        NSLog(@"%@",a);
        
    };
    NSLog(@"%@",_testblock);
    [self loadWithUrl:@""];

 
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
     NSLog(@"%@",_testblock);
      _testblock(@"adssad");
    
}
@end












/**  ==========================================================================================================================================================  **/
// super Self 调研

//- (Class)class
//{
//    return [BaseViewController class];
//}

//- (void)superWithSelfTest
//{
//    NSLog(@"%@",NSStringFromClass([self   class]));//1
//    NSLog(@"%@",NSStringFromClass([super  class]));//2
//
//    /*
//     本例总结
//
//     1 当前类 SaveDataViewController   重写class方法  返回  [BaseViewController class];
//     2 父类   bbbbViewController      未重写class方法，会调用[NSObject class]
//     3 接受者 都是self 运行时 代表当前类的对象
//     4 1 所以 1 打印当前类 - (Class)class 打印：BaseViewController
//     4 2 打印根类 [NSObject class] 方法   打印：SaveDataViewController
//
//     输出结果：
//     2018-03-19 10:25:22.725988+0800 TestForMe[2391:304351] BaseViewController
//     2018-03-19 10:25:22.726122+0800 TestForMe[2391:304351] SaveDataViewController
//     */
//
//    /*
//
//     ========================================
//
//     self/super 总结：
//
//     1》 self 调用当前类的方法 如果没有 去父类/根类中找
//     2》 super 调用父类的方法，如果没有 去父类/根类中找（去父类找，即使子类重写 不会改变）
//     ------------------------------------------------------
//     1: objc_msgSend(id self，SEL _cmd, ...) 。
//
//     //参数1：id self    接收者 （静态时 代表类 ，运行时 代表对象）
//     //参数2：SEL _cmd:  当前类方法
//     PS:当前 self 代表当前类的对象
//     ------------------------------------------------------
//     2: id objc_msgSendSuper( struct objc_super *super ,  SEL op, ...)
//
//     //参数1： super 结构体
//     struct objc_super {
//     id receiver;      //接收者
//     Class superClass; // superClass 指针指向父类 会从父类的方法列表中 调用方法
//     };
//     //参数2：SEL op:  当前类方法
//     PS: super：编译器指示符
//
//     */
//
//}
/**  ==========================================================================================================================================================  **/

//// 归档// 解档  NSKeyedArchiver// NSKeyedUnarchiver
//void  saveData()
//{
//
//
//    Person *p = [[Person alloc] init];
//
//    p.name = @"哈哈";
//    p.height = @"1999";
//    Car * c = [[Car alloc] init];
//    c.paizi = @"audi";
//    p.car = c;
//
//    //归档思密达
//    // 1 获取路径
//    NSString *lastPath =  [NSHomeDirectory() stringByAppendingPathComponent:@"mmm"];
//
//    //2 NSKeyedArchiver归档  写文件进沙盒
//    NSMutableData *data = [NSMutableData data];
//    [data writeToFile:lastPath atomically:YES];
//
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:p forKey:@"p"];
//
//    [archiver finishEncoding];
//
//
//
//    //3 NSKeyedUnarchiver解档  获取沙盒路径 读取文件
//
//    NSMutableData *data1 = [NSMutableData dataWithContentsOfFile:lastPath];
//
//    NSKeyedUnarchiver *arc =  [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
//    Person *p1 = [arc decodeObjectForKey:@"p"];
//    NSLog(@"%@",p1.car.paizi);
//
//    /*
//     1 模型实现nscoding协议，实现方法 设置对应的键对应的属性
//     2 设置路径 NSKeyedArchiver 归档 存储在data 中写进沙盒
//     3 获取data 从data中解档NSKeyUnarchiver
//     PS :NSKeyedArchiver 归档
//     1 以NSData封装路径 初始化归档器
//     2 以键存 “对象” 进归档器
//
//     NSKeyedUnarchiver 解档
//     1 以路径获取data 初始化解档器 NSKeyedUnarchiver
//     2 以键 获取对象
//     IO:以对象形式 存储
//     */
//}

