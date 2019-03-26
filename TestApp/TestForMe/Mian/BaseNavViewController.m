//
//  BaseNavViewController.m
//  TestForMe
//
//  Created by Dance on 2017/4/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseNavViewController.h"
#import "BaseViewController.h"
@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BaseViewController *vc = (BaseViewController *)viewController;
    NSString *classStr = NSStringFromClass([viewController class]);

     NSString *lastStr = classStr;
    if ( [classStr containsString:@"ViewController"] || [classStr containsString:@"viewController"] ||  [classStr containsString:@"viewcontroller"]) {
      lastStr =  [classStr substringWithRange:NSMakeRange(0, [classStr length] - [@"ViewController" length])];
    }
    if([classStr containsString:@"Controller"] || [classStr containsString:@"controller"]){
         lastStr =  [classStr substringWithRange:NSMakeRange(0, [classStr length] - [@"Controller" length])];
    }
    vc.title = lastStr;
    [super pushViewController:vc animated:YES];
}

@end
