//
//  CALyerAndUIViewLayer.m
//  TestForMe
//
//  Created by Music on 2018/4/8.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "CALyerAndUIViewLayer.h"

@implementation CALyerAndUIViewLayer

- (void)setFrame:(CGRect)frame
{
    NSLog(@"CALyerAndUIViewLayer=====setFrame--%@",NSStringFromCGRect(frame));
    [super setFrame:frame];
    
}
-(void)setAnchorPoint:(CGPoint)anchorPoint
{
    NSLog(@"CALyerAndUIViewLayer=====setAnchorPoint--%@",NSStringFromCGPoint(anchorPoint));
    [super setAnchorPoint:anchorPoint];
}
-(void)setPosition:(CGPoint)position
{
    NSLog(@"CALyerAndUIViewLayer=====setPosition--%@",NSStringFromCGPoint(position));
    [super setPosition:position];
}
- (void)setBounds:(CGRect)bounds
{
    NSLog(@"CALyerAndUIViewLayer=====setBounds--%@",NSStringFromCGRect(bounds));
    [super setBounds:bounds];
}
- (CGPoint)position
{
    NSLog(@"CALyerAndUIViewLayer=====position");
    return [super position];
}
-(CGRect)bounds
{
    NSLog(@"CALyerAndUIViewLayer=====bounds");
    return [super bounds];
}
@end
