//
//  HUDViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "HUDViewController.h"
#import "MBProgressHUD.h"
@interface HUDViewController ()<MBProgressHUDDelegate>
{

}
@end

@implementation HUDViewController
{
    MBProgressHUD *HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"hud";
        self.view.backgroundColor = [UIColor clearColor];
        self.navigationController.view.backgroundColor = [UIColor grayColor];
  
    

    
 

}
- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL b = 0 ;
    if (b) {//1
          [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
    
           [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    b=!b;
}


@end
