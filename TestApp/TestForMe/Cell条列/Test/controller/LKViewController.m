//
//  LKViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/28.
//  Copyright © 2017年 Dance. All rights reserved.
//
//  镂空效果

const NSString *str = @"asdsadsad";
#import "LKViewController.h"
#define SCREEN_WIDTH kScreenSize.width
#define SCREEN_HEIGHT kScreenSize.height
#import <AVFoundation/AVFoundation.h>
#import "Person.h"
#import "LKView.h"
@interface LKViewController ()

@property (copy ,nonatomic)NSString *cStr;
@property (strong ,nonatomic)NSString *sStr;
@property (strong, nonatomic)UIImageView *titleBack;


@property (nonatomic,weak)   id weakPoint;
@property (nonatomic,assign) id assignPoint;
@property (nonatomic,strong) id strongPoint;
@property (nonatomic ,strong)LKView *lkview;
@end

@implementation LKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"镂空";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.lkview = [[LKView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.lkview];

//    [self addMask];
    [self huatu];
}
-(void)huatu
{
    //1.创建自定义的layer
         CALayer *layer=[CALayer layer];
         //2.设置layer的属性
         layer.backgroundColor=[UIColor brownColor].CGColor;
         layer.bounds=CGRectMake(0, 0, 200, 150);
         layer.anchorPoint=CGPointZero;
         layer.position=CGPointMake(100, 100);
         layer.cornerRadius=20;
         layer.shadowColor=[UIColor blackColor].CGColor;
         layer.shadowOffset=CGSizeMake(10, 20);
         layer.shadowOpacity=0.6;
    
         [layer setNeedsDisplay];
        //3.添加layer
         [self.view.layer addSublayer:layer];
//    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 220, 100, 100)]; //绘制圆形曲线
//
//    // 3.设置一些修饰属性
//    aPath.lineWidth = 8.0;//线宽
//    aPath.lineCapStyle = kCGLineCapRound;//
//    aPath.lineJoinStyle = kCGLineCapRound;
//    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1];//颜色设置
//    //    UIColor *color = [UIColor redColor];
//    [color set];
//
//    [aPath stroke]; // 4.渲染，完成绘制
//    [self.view addSubview:aPath];
    
}


- (void)addMask{//圆形

    //给self.view添加黑色uiview蒙版
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenSize.width-100, kScreenSize.height-200)];
    
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view addSubview:backgroundView];
    
    
    // 绘制路径  创建一个全屏大的path 里边小圆path
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 64+10, kScreenSize.width-20, kScreenSize.height-20-64)];
    //添加圆形
    [path appendPath:
    [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x,self.view.center.y - 25)
                                
                                                             radius:50
                                
                                                         startAngle:0
                                
                                                           endAngle:2 *M_PI
                                
                                                          clockwise:NO]
     ];
    //绘制矩形
    [path appendPath:
     [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 350, SCREEN_WIDTH - 100, 100) cornerRadius:0] bezierPathByReversingPath]
     ];  //Reversing 反转
   //test
  
    //添加矩形
     UIBezierPath *jx =  [UIBezierPath bezierPathWithRect:CGRectMake(10,64, 50, 50)];
    [path appendPath:[jx bezierPathByReversingPath]];
    
     UIBezierPath *kk =  [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kScreenSize.width-10-50,64, 50, 50) cornerRadius:0 ]bezierPathByReversingPath];
  
     [path appendPath:kk];

 
    
    // 设置mask
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];//Shape 塑造
    
    shapeLayer.path = path.CGPath;
    
    backgroundView.layer.mask = shapeLayer;//mask 遮盖
    /*
     原理：创建
     1 给self.view 添加黑色uiview蒙版
     2 设置 uiview对象的.layer.mask属性。
     2-1 layer.mask 需要赋值一个layer对象（子类UIShapeLayer对象）
     2-2 设置 UIShapeLayer对象  绘制对象.path（贝塞尔路径）
     
     
     0 思路：蒙版.layer.mask = layer对象
     1 创建蒙版
     2 绘制贝塞尔路径 添加反转图形（叠加部分会镂空）
     3 创建layer(CAShapeLayer子类).path = 贝塞尔路径.path
     4 设置 蒙版.layer.mask = layer对象
     */
    
    
    


}

- (void)addMask1
{
    
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds cornerRadius:0];
    // 绘制镂空圆形路径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(180,kScreenSize.height-180,150,150)];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
    fillLayer.fillColor = [UIColor grayColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
}


- (void)testForweak {
    [super viewDidLoad];
    
    self.strongPoint = [NSDate date];
    NSLog(@"strong属性：%@",self.strongPoint);
    
    self.weakPoint = self.strongPoint;
    self.assignPoint = self.strongPoint;
    
    self.strongPoint = nil;  //指向变量设置为空！
    NSLog(@"weak属性：%@",self.weakPoint);  //weak 修饰变量 不会出现野指针错误
//        NSLog(@"assign属性：%@",self.assignPoint);// assign 修饰变量 出现野指针错误崩溃！！！！
}
#pragma MARK 测试 日常 copy 和strong 的区别
- (void)copyWithStrongMethod1
{
    NSMutableArray *books = [@[@"book1"] mutableCopy];
    Person *person = [[Person alloc] init];
    person.strBooks = books;
    person.copBooks = books;
    [books addObject:@"book2"];
    NSLog(@"bookArray1:%@",person.strBooks);
    NSLog(@"bookArray2:%@",person.copBooks);
}
- (void)copyWithStrongMethod2
{
    NSMutableString *str = @"abc".mutableCopy;
    
    self.cStr = str;
    self.sStr = str;
//    str = @"asdsad".mutableCopy;不行
    [str appendString:@" 123"];
   
    NSLog(@"str1===%@ str2===%@", self.cStr, self.sStr); // str1:hello world str2:hello
}
- (void)copyWithStrongMethod3
{
        NSMutableString *a = [NSMutableString stringWithFormat:@"abc"];
        //    self.cStr = a;
        self.sStr = a;
        a = @"234".mutableCopy;
        //    NSLog(@"%@",self.cStr);
        NSLog(@"%@",self.sStr);
    
        NSMutableString *str = [NSMutableString stringWithString:@"hello"];
}

@end
