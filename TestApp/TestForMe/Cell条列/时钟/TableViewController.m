//
//  TableViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/9.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "TableViewController.h"
#define kScreenSize [UIScreen mainScreen].bounds.size
@interface TableViewController ()
@property (nonatomic ,strong)NSTimer *timer;
@end
/*
 runLoop 使用
 */
@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"table";
    self.tableView.tableHeaderView = [self setUpHeadView];
  self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(runTimer) userInfo:@{@"1":@"abc"} repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];


  
}
- (void)runTimer
 {
     NSLog(@"开启----runTimer");
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = @"abc";
    
    return cell;
}

- (UIView *)setUpHeadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    view.backgroundColor = [UIColor redColor];
    return view;
}
- (void)viewDidDisappear:(BOOL)animated
{
    if (nil != _timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)dealloc
{
   NSLog(@"runtime over");
//    [self.timer invalidate];
//    self.timer = nil;
}

@end
