//
//  TSubYHViewController.m
//  TestForMe
//
//  Created by Music on 2018/1/16.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "TSubYHViewController.h"
#import "NSObject+TPerson.h"
#import "UIImageView+WebCache.h"

@interface TSubYHViewController ()

@end

@implementation TSubYHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"性能优化";
    [self sdImage];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test1
{
    NSObject *p = [[NSObject alloc] init];
    p.name =@"你好";
    NSLog(@"%@",p.name);
    
}
- (void)test{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(80, 80, 20, 20)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    //    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 30, 30)] CGPath];
    ////   UIImage * image = [UIImage imageWithContentsOfFile:@""];
    //   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //
    //    UIImage *image = [UIImage imageNamed:@"check_green"];
    //    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSNull null]];
    NSLog(@"%@",array);
}

- (void)sdImage
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:imageView];
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(imageView.frame)+10, 100, 100)];
    [self.view addSubview:imageView1];
    
    NSString *url =  @"https://admin.jrtoo.com/Yuyu/Uploads/cloud/photo.jpg";
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"timg.jpeg"] options:SDWebImageRefreshCached];
    
    NSString *url1 =  @"https://admin.jrtoo.com/Yuyu/Uploads/cloud/photo/2017/12/25/5a405c9277818.jpg";
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"timg.jpeg"] options:SDWebImageRefreshCached];
    
}


@end
