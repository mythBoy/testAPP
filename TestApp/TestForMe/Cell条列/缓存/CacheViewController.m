//
//  CacheViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/9.
//  Copyright © 2017年 Dance. All rights reserved.
//
// 缓存演练
#import "CacheViewController.h"
#import "block2ViewController.h"
#import "MJExtension.h"
@interface CacheViewController ()<NSCacheDelegate,UIScrollViewDelegate>
// 缓存的容器
@property (nonatomic, strong) NSCache *myCache;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation CacheViewController
{
    NSCache *_cache;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    extern NSString *kkk;
    NSLog(@"%@",kkk);
//    extern NSString *lll;
//    NSLog(@"%@",lll);
//    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTest];
//   _cache = [[NSCache alloc] init];
//    [self myCache];
}
-(NSCache *)myCache
{
    if (_myCache == nil) {
        _myCache = [[NSCache alloc] init];
        
        /**  NSCache类以下几个属性用于限制成本
         NSUInteger totalCostLimit  "成本" 限制，默认是0（没有限制）
         NSUInteger countLimit  数量的限制  默认是0 （没有限制）
         
         // 设置缓存的对象，同时指定限制成本
         -(void)setObject:(id) obj  forKey:(id) key cost:(NSUInteger) g
         */
        
        // 设置数量限额。一旦超出限额，会自动删除之前添加的东西
        _myCache.countLimit = 30;  // 设置了存放对象的最大数量
        _myCache.delegate = self;
    }
    return _myCache;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    for (int i =0 ; i< 30; i++) {
//        // 向缓存中添加对象
//        NSString *str = [NSString stringWithFormat:@"hello - %d", i];
//
//
//        [self.myCache setObject:str forKey:@(i)]; // @(i) 相当于  [NSNumber numberWith......]
//    }
//
//    for (int i=0 ; i< 30; i++) {
//
//        NSString * obj = [self.myCache objectForKey:@(i)];
//        NSData * dd = [obj dataUsingEncoding:NSUTF8StringEncoding];
//
//        NSLog(@"读取前一百条--%@---%lu", [self.myCache objectForKey:@(i)],(unsigned long)dd.length);
//    }
//}


// NSCache的代理方法只有一个
//  告诉即将要被删除的对象
-(void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    // 此代理方法主要用于程序员的测试
    NSLog(@"要删除的对象obj-------------%@", obj);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)setUpTest
{
    
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,100, kScreenSize.width, 130)];
//    _scrollView.backgroundColor = [UIColor grayColor];
//    //    _scrollView.delegate = self;
//    _scrollView.contentSize   = CGSizeMake(kScreenSize.width*3, 130);
//
//        _scrollView.contentOffset = CGPointMake(0, 0);
//    //    _scrollView.pagingEnabled = YES;
//    [self.view addSubview:_scrollView];
//
////        NSArray *array = @[@"mask.jpg",@"titleBack",@"title"];
//
//        for (int i =0; i<3; i++) {
////            NSString *str = [NSString stringWithFormat:@"%@",array[i]];
//
//            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenSize.width, 0, kScreenSize.width, 130)];
//            img.backgroundColor = GetRandomColor;
////            img.image = [UIImage imageNamed:str];
//            [_scrollView addSubview:img];
//        }
//
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,30, kScreenSize.width, 200)];
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    _scrollView.contentSize = CGSizeMake(kScreenSize.width*3, 400);
    
    
    NSArray *array = @[@"mask.jpg",@"titleBack",@"title"];
            for (int i =0; i<3; i++) {
                NSString *str = [NSString stringWithFormat:@"%@",array[i]];
    
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenSize.width+10, 10, kScreenSize.width, 200)];
//                img.backgroundColor = GetRandomColor;
                img.image = [UIImage imageNamed:str];
                [_scrollView addSubview:img];
            }
    const int a = 20;
    
    NSLog(@"%d",a);
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static int num;
    num++;

    NSLog(@"%d",num);//123456789  一直增加
}
@end

/******CacheTableViewController***********CacheTableViewController***********CacheTableViewController***********CacheTableViewController***********CacheTableViewController*****/
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#define YJYUrlPath @"https://admin.jrtoo.com/cifcogroup/application/web/index.php?r=meeting/meeting-list&device=ios&user=fe93c9c14cb5abdc91eee320e6549de8d1f9c4b1-d2eee2a7e69421f6a789516052ab6510d55961ad&deviceuuid=d41d8cd98f00b204e9800998ecf8427e7b787756-394e22c60ff8e4ed71faa3d62e5af3b4b3caeb05&ver=0.3903&userId=25026405&size=6&cate_id=1&app_id=10002"
#import "CacheCell.h"
#import "CacheModel.h"


@interface CacheTableViewController()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CacheTableViewController
{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setUpUI];
    [self  loadDataWithOnLine];
//    [self loadDataWithLocolFile];
    
    
   
   

}
- (NSMutableArray *)datArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)setUpUI
{
//    _dataArray = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)loadDataWithOnLine
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    typeof (self)weakSelf = self;
    [manager GET:YJYUrlPath parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"==downloadProgress==%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSLog(@"%@---%@",responseObject,task);
        if ([responseObject[@"status"] intValue] ==1) {
            
            weakSelf.dataArray = responseObject[@"msg"][@"data"];
            [weakSelf.tableView reloadData];
        }else{
            NSLog(@"获取失败");
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@---%@",error,task);
    }];
 
}
-(NSMutableArray *)dataArray
{
    if (_dataArray==nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}
- (void)loadDataWithLocolFile
{
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"products.plist" ofType:nil];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:fullPath]];//字典数组
//    CacheModel *model = [[CacheModel alloc] init];
    for (NSDictionary *dict in array) {
      CacheModel *model =   [CacheModel initWithDict:dict];
        [self.dataArray addObject:model];
    }

//   self.dataArray = [CacheModel mj_objectArrayWithKeyValuesArray:array];
 
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *ID = @"ABC";
    CacheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CacheCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    cell.model =   self.dataArray[indexPath.row];
   
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ABC";
    CacheCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CacheCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    cell.model =   self.dataArray[indexPath.row];
   return  cell.cellHeight;
//    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    block2ViewController *block = [[block2ViewController alloc] init];
//    [self.navigationController pushViewController:block animated:YES];
}
- (void)asd
{
    NSString *cre = @"creat table if not exist _studentDB (id primary key not null,sid integer,name text,age integet default 0)";
    NSString *z = @"insert into _studentDB (sid,name,age) value (123,'小华',19)";
    NSString *s = @"delete from _studentDB where name = '小华'";
    NSString *g = @"update from _studentDB set age = 20 where name = '小华'";
    NSString *c = @"seleted *from _student";
    NSString *c1 = @"selected *from _student where age = '18'";
    
}
@end


