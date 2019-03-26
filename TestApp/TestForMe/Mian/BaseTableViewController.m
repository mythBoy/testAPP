//
//  BaseTableViewController.m
//  TestForMe
//
//  Created by Dance on 2017/7/7.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titArrays = [NSMutableArray arrayWithObjects:@"跳转1",@"跳转2",@"跳转...", nil];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
//- (void)setTitArrays:(NSMutableArray *)titArrays
//{
//  
//    _titArrays = titArrays;
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titArrays.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *abc = @"abc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:abc];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:abc];
    }
    cell.textLabel.text = _titArrays[indexPath.row];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([_delegate respondsToSelector:@selector(baseTableViewController:didSelectRowAtIndexPath:andTitArrays:)]) {
        [self baseTableViewController:self didSelectRowAtIndexPath:indexPath andTitArrays:_titArrays];
//    }
    if (_didSelectRowAtIndexPathBlock) {
        _didSelectRowAtIndexPathBlock(indexPath,_titArrays);
    }
}
- (void)baseTableViewController:(BaseTableViewController *)basetableView didSelectRowAtIndexPath:(NSIndexPath *)path andTitArrays:(NSArray *)titArrays
{

}
-(void)dealloc
{
    NSLog(@"delloc---%@",NSStringFromClass([self class]));
}
@end
