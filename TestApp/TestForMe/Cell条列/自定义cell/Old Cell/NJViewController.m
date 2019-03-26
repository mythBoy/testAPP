//
//  NJViewController.m
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "NJViewController.h"
#import "NJWeibo.h"
#import "NJWeiboCell.h"
#import "NJWeiboFrame.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define YJYUrlPath @"https://admin.jrtoo.com/cifcogroup/application/web/index.php?r=meeting/meeting-list&device=ios&user=fe93c9c14cb5abdc91eee320e6549de8d1f9c4b1-d2eee2a7e69421f6a789516052ab6510d55961ad&deviceuuid=d41d8cd98f00b204e9800998ecf8427e7b787756-394e22c60ff8e4ed71faa3d62e5af3b4b3caeb05&ver=0.3903&userId=25026405&size=6&cate_id=1&app_id=10002"

@interface NJViewController ()
@property (nonatomic, strong) NSArray *statusFrames;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation NJViewController

//隐藏状态栏
//- (BOOL) prefersStatusBarHidden
//{
//    return YES;
//}
#pragma mark - 数据源方法
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"old";
    [self loadData];
    
}
#pragma mark - 懒加载
- (void )loadData
{
    
    
    if (_statusFrames == nil) {
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        
        typeof (self)weakSelf = self;
        [manager GET:YJYUrlPath parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
            //            NSLog(@"==downloadProgress==%@",downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@---%@",responseObject,task);
            if ([responseObject[@"status"] intValue] ==1) {
                
                weakSelf.dataArray = responseObject[@"msg"][@"data"];
               
                NSMutableArray *models = [NSMutableArray arrayWithCapacity:weakSelf.dataArray.count]; //创建模型数组
                for (NSDictionary *dict in weakSelf.dataArray) {
                    NJWeibo *weibo = [NJWeibo weiboWithDict:dict];
                    
                    // 根据模型数据创建frame模型
                    NJWeiboFrame *wbF = [[NJWeiboFrame alloc] init];
                    wbF.weibo = weibo;// 目的：缓存
                    
                    [models addObject:wbF];
                }
                self.statusFrames  =  models; // 获取模型数组 // models数组包含所有frame模型（包含 1模型数据 2所有控件的高度 3cell高度）
                [weakSelf.tableView reloadData];
            }else{
                NSLog(@"获取失败");
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@---%@",error,task);
        }];
        
        
        
        
    }
    //PS:缓存了数据和尺寸
    /*
     模型：frame 包含模型 个控件尺寸
     */
    
}
#pragma mark - 懒加载
//- (NSArray *)statusFrames
// {
//    if (_statusFrames == nil) {
//        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"products.plist" ofType:nil];
//        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];//获取缓存数组
//
//        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];//创建模型数组
//           for (NSDictionary *dict in dictArray) {
//               // 创建模型
//               NJWeibo *weibo = [NJWeibo weiboWithDict:dict];
//              // 根据模型数据创建frame模型
//               NJWeiboFrame *wbF = [[NJWeiboFrame alloc] init];
//                wbF.weibo = weibo;
//
//               [models addObject:wbF];//获取模型数组
//                 }
//
//              self.statusFrames = [models copy];
//           }
//   return _statusFrames;
// }


- (void)writeTofile:(id)products
{
//    NSArray *products = @[
//                          @{@"icon" : @"liantiaobao", @"title" : @"链条包"},
//                          @{@"icon" : @"shoutibao", @"title" : @"手提包"},
//                          @{@"icon" : @"danjianbao", @"title" : @"单肩包"},
//                          @{@"icon" : @"shuangjianbao", @"title" : @"双肩包"},
//                          @{@"icon" : @"xiekuabao", @"title" : @"斜挎包"},
//                          @{@"icon" : @"qianbao", @"title" : @"钱包"}
//                          ];
    
    NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachePatch stringByAppendingPathComponent:@"products.plist"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [products writeToURL:fileUrl atomically:YES];

//    [products writeTofile:(id)];
    
  
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NJWeiboCell *cell = [NJWeiboCell cellWithTableView:tableView];
    // 3.设置数据
    cell.weiboFrame = self.statusFrames[indexPath.row];
    
    // 4.返回
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"heightForRowAtIndexPath");
    // 取出对应航的frame模型
    NJWeiboFrame *wbF = self.statusFrames[indexPath.row];
    NSLog(@"height = %f", wbF.cellHeight);
    return wbF.cellHeight;
}

/*
 这么设计的思想是 高度，数据提前缓存
 
 1 获取数据 缓存高度（cell 控件高度） 缓存数据 reloaddata
 2 heightForRowAt 设置行高 赋值
 3 cellForRow  cell的模型赋值操作 （包含数据赋值 高度赋值）
 */
@end







