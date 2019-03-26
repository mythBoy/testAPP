//
//  AFNViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/14.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "AFNViewController.h"
#import "AFNetworking.h"
@interface AFNViewController ()
@property (nonatomic ,strong)UIProgressView *pro;
@end

@implementation AFNViewController
{
    NSURLSessionDownloadTask *_task;
}
- (void)viewDidLoad {
    [super viewDidLoad];
////    [self loadUrl];
//    UIProgressView* progressView = [ [ UIProgressView alloc ]
//                                    
////                                    initWithFrame:CGRectMake(150.0,20.0,130.0,30.0)];
//    self.pro= [[UIProgressView alloc]init];
////    self.pro.backgroundColor = [UIColor redColor];
//    //创建一个UIProgressView对象：_progressView
//    
//    self.pro.frame=CGRectMake(0,120,320,9);
//    
//    //设置它的位置及大小，它的高是默认的为9，可以写成0。
//    
//    self.pro.progressViewStyle=UIProgressViewStyleDefault;
//    
//    //设置它的风格，为默认的
//    
//    self.pro.trackTintColor= [UIColor blueColor];
//    
//    //设置轨道的颜色
//
//    self.pro.progressTintColor= [UIColor yellowColor];
//    
//    //设置进度的颜色
//    
//    self.pro.progress=0.0;
//    
//    //设置进度的初始值，即初始位置。范围是0.0-1.0
//    
//    [self.view addSubview:self.pro];
//    
    //把_progressView加入到view上
    
//    [self.pro release];
    
    //要记得release
    
//    [NSTimer scheduledTimerWithTimeInterval:0.5
//     
//                                    target:self
//     
//                                  selector:@selector(progressChanged:)
//     
//                                  userInfo:nil
//     
//                                   repeats:YES];
    
    //设置定时器
    [self task];

//  self.pro.trackTintColor= [UIColor blueColor];
//     self.pro.progressViewStyle=UIProgressViewStyleDefault;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
  self.pro.trackTintColor= [UIColor redColor];
}
- (UIProgressView *)pro
{
    if (!_pro) {
        _pro = [[UIProgressView alloc] initWithFrame:CGRectMake(0,120, 100, 9)];
  
        
        //设置它的位置及大小，它的高是默认的为9，可以写成0。
        
        _pro.progressViewStyle=UIProgressViewStyleDefault;
        
        //设置它的风格，为默认的
        
        _pro.trackTintColor= [UIColor blueColor];
        
        //设置轨道的颜色
        
        _pro.progressTintColor= [UIColor yellowColor];
        
        //设置进度的颜色
        
        _pro.progress = 0.0;
        
        //设置进度的初始值，即初始位置。范围是0.0-1.0
        
        [self.view addSubview:_pro];

        
    }
    return _pro;
}
//传图片流
- (void)postImages {
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
//    [manager POST:Period parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//     {
//         // 上传 多张图片
//         for(NSInteger i = 0; i < self.postImageArr.count; i++) {
//             
//             
//             NSData * imageData = UIImageJPEGRepresentation([self.postImageArr objectAtIndex: i], 0.5);
//             // 上传的参数名
//             
//             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//             formatter.dateFormat = @"yyyyMMddHHmmss";
//             NSString *str = [formatter stringFromDate:[NSDate date]];
//             NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//             [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:@"image/jpeg"];
//         }
//     }
//          success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         
//         NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//         NSLog(@"完成 %@", result);
//     }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"错误 %@", error.localizedDescription);
//     }];
//    
    
}
- (void)saveImage:(UIImage *)image
{
    
    NSString *url = @"";//放上传图片的网址
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];//初始化请求对象
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//设置服务器允许的请求格式内容
    
    //上传图片/文字，只能同POST
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        //对于图片进行压缩
        //UIImage *image = [UIImage imageNamed:@"111"];
        NSData *data = UIImageJPEGRepresentation(image, 0.1);
        //NSData *data = UIImagePNGRepresentation(image);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"1" fileName:@"image.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@, task = %@",responseObject,task);
        //        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //        NSLog(@"obj = %@",obj);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
}
- (void)loadUrl{//请求
// 1.创建AFN管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.利用AFN管理者发送请求
    NSDictionary *params = @{
                             @"username" : @"520it",
                             @"pwd" : @"520it"
                             };

    //http://120.25.226.186:32812/login
    //http://120.25.226.186:32812/login?pwd=520it&username=520it
    [manager GET:@"http://120.25.226.186:32812/login?pwd=520it&username=520it" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {//回调在主线程
//       id ddd =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"---请求成功-%@",task);
        NSLog(@"---%@", [responseObject class]);
//        NSLog(@"%@",ddd);
       

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败---%@", error);
    }];
}
//下载
-(NSURLSessionDownloadTask *)task{
    
    if (!_task) {
    
        AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"]];
        
        _task=[session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //下载进度
            NSLog(@"%@",downloadProgress);
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                self.pro.progress= downloadProgress.fractionCompleted;
                
            }];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            //下载到哪个文件夹
            NSString *cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            
            NSString *fileName=[cachePath stringByAppendingPathComponent:response.suggestedFilename];
            
            return [NSURL fileURLWithPath:fileName];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            //下载完成了
            NSLog(@"下载完成了 %@",filePath);
        }];
    }
    
    return _task;
}
@end
