//
//  block2ViewController.m
//  TestForMe
//
//  Created by Music on 2017/7/20.
//  Copyright © 2017年 Dance. All rights reserved.
//
// 获取Documents文件路径
#define kDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kCachesPath    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#import "block2ViewController.h"
#import "block1ViewController.h"
#import "blockView.h"
@interface block2ViewController ()<blockViewDelegate>
@property (nonatomic ,assign)void(^myBlock)(NSString *);
@end

@implementation block2ViewController
-(void)viewDidLayoutSubviews
{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

   blockView *view = [[blockView alloc] initWithFrame:self.view.frame];
    view.delegate = self;
    [self.view addSubview:view];
}
-(void)blockViewClickBtn:(UIButton *)btn
{
    NSLog(@"block2ViewController 传递成功");
    
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController pushViewController:[[block1ViewController alloc] init] animated:YES];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
//
//-(void) setUpDB
//{
//    NSArray *paths = @[@"597e99afad42b(6).jpg",@"597e99afad42b(1).jpg",@"597e99afad42b(2).jpg",@"597e99afad42b(3).jpg"];
//    NSArray *sortArray = [paths sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {//日期排序
//        //        NSString *firstUrl = [downloadDirectories stringByAppendingPathComponent:obj1];
//        //        NSString *secondUrl = [downloadDirectories stringByAppendingPathComponent:obj2];
//        //        NSDictionary *fistInfo = [manager attributesOfItemAtPath:firstUrl error:nil];
//        //        NSDictionary *secondInfo = [manager attributesOfItemAtPath:secondUrl error:nil];
//        //        id firstDate = [fistInfo objectForKey:NSFileCreationDate];
//        //        id secondDate = [secondInfo objectForKey:NSFileCreationDate];
//        return [obj1 compare:obj2];
//    }];
//    NSLog(@"%@",sortArray);
//
//}
////  创建文件
//- (void)createFile
//{
//
//
//    //  拼接路径
//    NSString *filePath = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
//    NSLog(@"%@",filePath);
//    //  获取 操作文件对象
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//
//    //  withIntermediateDirectories
//    //  YES 如果不存在 创建 可以覆盖 反之 不可以覆盖(创建失败)
//    BOOL isCreateFile = [fileManger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//
//    NSLog(@"%d",isCreateFile);
//
//}
//
////  移动
//- (void)moveFile
//{
//    //  拼接老路径
//    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
//    //  拼接新路径
//    NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download"];
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//
//
//    BOOL isMoved = [fileManger moveItemAtPath:old toPath:new error:nil];
//    NSLog(@"%d",isMoved);
//
//}
////  复制
//- (void)copyFile
//{
//    //  拼接老路径
//    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
//    //  拼接新路径
//    NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download"];
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//
//    BOOL isCopy = [fileManger copyItemAtPath:new toPath:old error:nil];
//    NSLog(@"%d",isCopy);
//
//}
////  删除
//- (void)deleteFile
//{
//    //  拼接新路径
//    NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download"];
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//
//    BOOL isDelete = [fileManger removeItemAtPath:new error:nil];
//    NSLog(@"%d",isDelete);
//
//
//}
////  是否存在
//- (void)isExistFile
//{
//    //  拼接老路径
//    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
//    NSFileManager *fileManger = [NSFileManager defaultManager];
//
//    BOOL isExist = [fileManger fileExistsAtPath:old];
//    NSLog(@"%d",isExist);
//}
@end
