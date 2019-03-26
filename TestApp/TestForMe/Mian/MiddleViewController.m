//
//  Middle]ViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/10.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "MiddleViewController.h"
#import "TTModel.h"
//#import "AFNHttpTool.h"
#import "AFNetworking.h"

@interface MiddleViewController ()
@property (nonatomic,strong)TTModel *tmodel;
@end

@implementation MiddleViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//     [self setUpBlock];
    [self setUpData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//block操练
- (void)setUpBlock
{
       self.tmodel = [[TTModel alloc] init];
    
       __weak TTModel *strongmodel = self.tmodel;
       self.tmodel.testBlock = ^{

        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
            
            [strongmodel test];
            
        });
    };
    
    self.tmodel.testBlock();

}
- (void)setUpData
{


    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };

    //http://120.25.226.186:32812/login
   //http://120.25.226.186:32812/login?pwd=520it&username=520it
    [manager GET:@"http://120.25.226.186:32812/login?pwd=520it&username=520it" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"---请求成功-%@",task);
         NSLog(@"---%@", responseObject);
         NSLog(@"---%@", [NSThread currentThread]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          NSLog(@"请求失败---%@", error);
    }];

}
- (void)dealloc
{
    NSLog(@"middleVc 被释放");
}
@end
