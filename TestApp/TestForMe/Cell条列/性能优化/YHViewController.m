//
//  YHViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/14.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "YHViewController.h"
#import "TSubYHViewController.h"
#import "TsubYH2ViewController.h"
#import "TSubMRCViewController.h"

@interface YHViewController ()

@end

@implementation YHViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    
   
}
-(void)setYH
{
    
    self.baseDataArray = @[
                           @"性能优化",
                           @"AutoReleasePoor",
                           @"TSubMRCViewController"
                           ];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row ) {
        case 0:
        {
//       TSubYHViewController *sub =  [[TSubYHViewController alloc] init];
//       [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;

        case 1:
        {
           TsubYH2ViewController *sub =  [[TsubYH2ViewController alloc] init];
           [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;
        case 2:
        {
            TSubMRCViewController *sub =  [[TSubMRCViewController alloc] init];
            [self.navigationController pushViewController:sub animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
}
//void createString(void) {
//
//    NSString *string = [[NSString alloc] initWithFormat:@"Hello, World!"];    // 创建常规对象
//    NSString *stringAutorelease = [NSString stringWithFormat:@"Hello, World! Autorelease"]; // 创建autorelease对象
//    
//    weak_String = string;
//    weak_StringAutorelease = stringAutorelease;
//
//    NSLog(@"------in the createString()------");
//    NSLog(@"%@", weak_String);
//    NSLog(@"%@\n\n", weak_StringAutorelease);
//}


@end






