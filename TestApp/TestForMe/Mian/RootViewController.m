//
//  RootViewController.m
//  TestForMe
//
//  Created by Dance on 2017/6/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "RootViewController.h"
#import "NSObject+TPerson.h"
@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *titsArray;
@property (nonatomic ,strong)NSMutableArray *vcsArray;

@property (nonatomic, retain, readwrite) NSArray *urls;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpData];
  
}
- (void)setUpUI
{
    self.navigationItem.title = @"Root";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_tableView];
}
- (void)setUpData
{
    _titsArray = @[@"C language",@"Data Storage",@"Test",@"Memory Management",@"Algorithm 排序",@"RunTime",@"Performance 优化",@"Multithreading线程",@"block",@"cache",@"Timer",@"自定义Cell",@"数据库"].mutableCopy;
    _vcsArray =@[@"AboutCViewController",@"SaveDataViewController",@"CALyerAndUIViewViewController",@"NCViewController",@"SFViewController",@"",@"YHViewController",@"DXCViewController",@"block2ViewController",@"CacheTableViewController",@"TableViewController",@"NewViewController",@"DBViewController"].mutableCopy;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _vcsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IA = @"1234567";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:IA];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IA];
    }
    cell.textLabel.text = _titsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *classStr = _vcsArray[indexPath.row];
    if (classStr.length) {
     Class class=   NSClassFromString(classStr);
     UIViewController *vc = [[class alloc] init];
     [self.navigationController pushViewController:vc animated:YES];
    }
  
  
   
}
@end

//**************************************************************************************************************************************************************************************//

#import "testUtil.h"
#import "UIImageView+WebCache.h"
@interface LearnViewController() <NSMachPortDelegate>
@property (atomic,strong) NSMutableArray* NotArray;
@property (nonatomic) NSLock*         NotLock;
@property (nonatomic) NSMachPort*     NotPort;
@property (nonatomic ,strong)UIImageView *imageView;
@end

@implementation LearnViewController
{
    int _ticketCount;//总票数
    
    int _soldCount;//已经卖了多少张票
    
    NSLock *_lock;//数据锁
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self xctb2];
   
   
}



// <<<<<<<====================
/**  ============================= <# 线程同步 # > ============================= **/
- (void)xctb1
{
   _NotLock = [[NSLock alloc] init];
    NSMutableArray *obj = @[@1,@2,@3].mutableCopy;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @synchronized(obj) {

       
            NSLog(@"需要线程同步的操作1 开始==%@",obj);
            sleep(3);
     
            [obj removeObject:@1];
      
            NSLog(@"需要线程同步的操作1 结束==%@",obj);

        }
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        @synchronized(obj) {

            [obj addObject:@4];
    

            NSLog(@"需要线程同步的操作2==%@",obj);
        }
  
    });
    /*
     这个例子的  给对象obj 加锁；保证一条A执行完，才执行B线程，A/B线程保持同步执行，非异步
     注意  @synchronized(obj) 是锁住这个对象，当对象在不同的 A线程被操作完成后，才会操作B中的
    */
}
- (void)xctb2
{
    _NotLock = [[NSLock alloc] init];
    NSMutableArray *obj = @[@1,@2,@3].mutableCopy;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
        [_NotLock lock];
        NSLog(@"需要线程同步的操作1 开始==%@",obj);
        sleep(3);
        
        [obj removeObject:@1];
        
        NSLog(@"需要线程同步的操作1 结束==%@",obj);
        [_NotLock unlock];
      
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
     
        [_NotLock lock];
        [obj addObject:@4];
        
        NSLog(@"需要线程同步的操作2==%@",obj);
        [_NotLock unlock];
    });
    /*
     这个例子的  给对象obj 加锁；保证一条A执行完，才执行B线程，A/B线程保持同步执行，非异步
     注意 lock 锁方法
     */
}


/*
 总结： 线程同步，为了解决多个线程同时访问一块资源，所以让线程同步执行，一个一个来，
 */
/**  ======================================================================= **/



/**  ============================= 线程之间通信 ============================= **/


-(void)setUpUI
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    [self.view addSubview:_imageView];
    _imageView.backgroundColor = [UIColor grayColor];
    
    NSURL *url = [NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/e4dde71190ef76c666af095f9e16fdfaaf516741.jpg"];
    [self performSelectorInBackground:@selector(backTherad:) withObject:url];
    
}
- (void)backTherad:(NSURL *)url
{
  NSData *data =  [NSData dataWithContentsOfURL:url];
    NSLog(@"%ld",data.length);
   UIImage *image = [UIImage imageWithData:data];
    [self performSelector:@selector(mainThread:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
    NSLog(@"看看谁先打印");
    
}
- (void)mainThread:(UIImage *)image
{
    [_imageView setImage:image];
    

}
 /*
 总结
 [self performSelector:@selector(mainThread:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
 通过 performselected方法，【 参数：1方法 2传递对象Nsobject 3 线程 4 是否阻塞当前线程（举例 如果后面有句话，yes 先执行maintherd方法内的在执行后面的代码，no先执行maintherd后面的代码，在执行maintherd）】
 1 切换当前线程到其他线程 onThread：thread，
 2 传递数据：withObject：nsobject
 */
/**  =============================   线程之间通信   ============================= **/


/**  =============================     反射     ============================= **/
- (void)fanshe
{
    // oc反射 例子  1 通过字符串转 class类名  2通过类名转字符串
    Class class =  NSClassFromString(@"testUtil");
    testUtil  *ss =[[class alloc] init];
    
    Class  kk =    [ss class];
    NSString *className = NSStringFromClass(kk);
    NSLog(@"%@",className);
    //oc反射 通过字符串可以获取类名; 通过类名打印字符串
    
   
    
}
/*
 总结
    // oc反射 例子  1 通过字符串转 class类名  2通过类名转字符串
 */
/**  ============================= 反射 ============================= **/
@end






