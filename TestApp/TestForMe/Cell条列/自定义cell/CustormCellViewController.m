//
//  CustormCellViewController.m
//  TestForMe
//
//  Created by Music on 2018/3/12.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "CustormCellViewController.h"
#import "NJViewController.h"
@interface CustormCellViewController ()

@end

@implementation CustormCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NJViewController *nj = [[NJViewController alloc] init];
//    self.view = nj.view;
    [self.view  addSubview:nj.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
