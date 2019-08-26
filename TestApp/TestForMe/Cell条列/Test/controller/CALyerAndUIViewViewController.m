//
//  CALyerAndUIViewViewController.m
//  TestForMe
//
//  Created by Music on 2018/4/4.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "CALyerAndUIViewViewController.h"
#import "CALyerAndUIViewView.h"
@interface CALyerAndUIViewViewController()
@property (nonatomic ,strong)CALayer *mylayer;
@end
@implementation CALyerAndUIViewViewController
- (void)viewDidLoad
{
    [super viewDidLoad];


}
//- (void)testForLayer
//{
//
//    //    CALayer *layer = [[CALayer alloc] init];
//    //    layer.bounds = CGRectMake(0, 0, 80, 80);
//    //    layer.backgroundColor = [UIColor redColor].CGColor;
//    //    layer.position = CGPointMake(80, 80);
//    //    layer.anchorPoint = CGPointMake(0, 0);  // 默认值为0.5-0.5
//    //    layer.cornerRadius =20;
//    //    [self.view.layer addSublayer:layer];
//    //    NSLog(@"%@",NSStringFromCGPoint(layer.anchorPoint));
//    //    self.mylayer = layer;
//
//    CALyerAndUIViewView *view = [[CALyerAndUIViewView alloc] init];
//    view.frame = CGRectMake(100, 100, 100, 100);
//    view.backgroundColor = [UIColor redColor];
//
//    [self.view addSubview:view];
//    CALayer *l =  [[CALayer alloc] init];
//    l.position = CGPointMake(100, 100);
//    //    l.position = CGPointMake(150, 150);
//    l.anchorPoint = CGPointMake(1, 1);
//    l.bounds = CGRectMake(0, 0, 100, 100);
//    l.backgroundColor = [UIColor grayColor].CGColor;
//    [view.layer addSublayer:l ];
//}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //这尼玛叫隐示动画   就是自带动画的意思 没有很高级
////    self.mylayer.bounds = CGRectMake(0, 0, 200, 80);
////    self.mylayer.backgroundColor = [UIColor yellowColor].CGColor;
//
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.mylayer.bounds = CGRectMake(0, 0, 200, 80);
//    self.mylayer.backgroundColor = [UIColor yellowColor].CGColor;
//    [CATransaction commit];
//
//}
@end
