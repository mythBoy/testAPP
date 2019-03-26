//
//  BaseViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BaseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil //实例化控制器调用
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
   
//        [self logOnDealloc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

//    self.title = [self getTit];
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
//    NSLog(@"%s,%@",__FUNCTION__,parent);
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
//    NSLog(@"%s,%@",__FUNCTION__,parent);
    self.navigationController.navigationBarHidden = NO;
    if(!parent){
//        NSLog(@"页面pop成功了");
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
//- (NSString *)getTit
//{
//    NSString *tit = NSStringFromClass([self class]);
//    if ([tit containsString:@"ViewController"]) {
//     tit =   [tit substringWithRange:NSMakeRange(0, tit.length- @"ViewController".length)];
//    }
//    return tit;
//}
/********************************************************************************************************************************************************/
- (void)setShowTableView:(BOOL)showTableView
{
    _showTableView = showTableView;
    if (showTableView  == YES) {
        [self.view addSubview:self.baseTableView];
    }
    
}
- (UITableView *)baseTableView
{
    if (_baseTableView == nil) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) style:UITableViewStylePlain];
        self.baseTableView.delegate = self;
        self.baseTableView.dataSource = self;
    }
    return _baseTableView;
}
- (void)setBaseDataArray:(NSArray *)baseDataArray
{
    _baseDataArray = baseDataArray;
     self.showTableView = YES;
    [self.baseTableView reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.baseDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    id obj =  self.baseDataArray[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = obj;
    }else{
        
        cell.textLabel.text = @"未知";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *class =  self.baseDataArray[indexPath.row];
    if(class){
      Class cla = NSClassFromString(class);
    
       BaseViewController *vc = [[cla alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)dealloc
{
    NSLog(@"dealloc---%@",NSStringFromClass(self.class));
    
}
@end

















