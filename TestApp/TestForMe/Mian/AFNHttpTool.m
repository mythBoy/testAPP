//
//  AFNHttpTool.m
//  TestForMe
//
//  Created by Dance on 2017/3/10.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "AFNHttpTool.h"
#import "AFNetworking.h"
@implementation AFNHttpTool
+ (void)GetWithUrl:(NSString *)urlStr paramers:(NSMutableDictionary *)paramers  success:(success)success
{
    // 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.利用AFN管理者发送请求
    //    NSDictionary *params = @{
    //                             @"username" : @"520it",
    //                             @"pwd" : @"520it"
    //                             };
    
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
@end
