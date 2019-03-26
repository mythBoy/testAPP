//
//  CALyerAndUIViewView.m
//  TestForMe
//
//  Created by Music on 2018/4/8.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "CALyerAndUIViewView.h"
#import "CALyerAndUIViewLayer.h"
@implementation CALyerAndUIViewView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        CALyerAndUIViewLayer *layer = [[CALyerAndUIViewLayer alloc] init];
//        layer.frame
    }
    return self;
}
//-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//
//    NSLog(@"drawLayer---%@",layer.backgroundColor);
//}
//
//- (void)drawRect:(CGRect)rect {
//    NSLog(@"drawRect---%@",NSStringFromCGRect(rect));
//}

+(Class)layerClass
{
    NSLog(@"CALyerAndUIViewView=====layerClass");
    return [CALyerAndUIViewLayer class];
}
-(CGPoint)center
{
    NSLog(@"CALyerAndUIViewView=====center");
    return [super center];
    
}
-(void)setCenter:(CGPoint)center
{
    NSLog(@"CALyerAndUIViewView=====setCenter");
    [super setCenter:center];
    
}
-(void)setBounds:(CGRect)bounds
{
    NSLog(@"CALyerAndUIViewView=====setBounds");
    [super setBounds:bounds];
    
}
-(void)setFrame:(CGRect)frame
{
    NSLog(@"CALyerAndUIViewView=====setFrame");
    [super setFrame:frame];
}


@end
