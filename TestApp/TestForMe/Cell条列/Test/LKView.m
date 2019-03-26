//
//  LKView.m
//  TestForMe
//
//  Created by Music on 2018/3/28.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "LKView.h"

@implementation LKView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
//    UIBezierPath* aPath = [UIBezierPath bezierPathWithRect:CGRectMake(20, 220, 100, 50)]; // 1.创建图形相应的UIBezierPath对象 绘制举行曲线
    UIBezierPath* aPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 220, 100, 100)]; //绘制圆形曲线
    
    // 3.设置一些修饰属性
    aPath.lineWidth = 8.0;//线宽
    aPath.lineCapStyle = kCGLineCapRound;//
    aPath.lineJoinStyle = kCGLineCapRound;
    UIColor *color = [UIColor colorWithRed:0 green:0 blue:0.7 alpha:1];//颜色设置
//    UIColor *color = [UIColor redColor];
    [color set];
    
    [aPath stroke]; // 4.渲染，完成绘制

}


@end
