//
//  TESTViewController.m
//  TestForMe
//
//  Created by Music on 2019/8/26.
//  Copyright © 2019 Dance. All rights reserved.
//

#import "TESTViewController.h"
#import "CircleViewController.h"
@interface TESTViewController ()

@end

@implementation TESTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseDataArray = @[@"循环运用问题",@"待定"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
       CircleViewController *circle = [[CircleViewController alloc] init];
        [self.navigationController pushViewController:circle animated:YES];
    }
}
@end
