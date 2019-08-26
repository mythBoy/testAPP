//
//  CircleViewController.m
//  TestForMe
//
//  Created by Music on 2019/8/26.
//  Copyright © 2019 Dance. All rights reserved.
//

#import "CircleViewController.h"

@interface CircleViewController ()
@property (nonatomic ,strong)NSTimer *timer;
@end

@implementation CircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"循环引用问题";
    
}


- (void)dealloc
{
    NSLog(@"CircleViewController----dealloc");
    
}

//测试1 有效
- (void)test1
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runTime:) userInfo:@{@"abc":@"bcd"} repeats:YES];
    
}
- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if(self.timer){
      [self.timer invalidate];
       NSLog(@"----%@",parent);
    }

  
}
- (void)runTime:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
}

@end
/*
 演练 定时器循环引用问题
 https://www.jianshu.com/p/ca579c502894
 
 // 方法 一
 //当一个视图控制器 添加或被删除,就是移动时候调用
 // 本例 1 进入添加到父控制器为 nav导航控制器 2 退出跟控制器为null  链接 https://blog.csdn.net/yongyinmg/article/details/40619727
 
 //方法 二
 
 
 */
