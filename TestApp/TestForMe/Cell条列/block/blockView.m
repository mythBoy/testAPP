//
//  blockView.m
//  TestForMe
//
//  Created by Music on 2018/4/10.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "blockView.h"

@implementation blockView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
        [btn setBackgroundColor:[UIColor grayColor]];
        [btn setTitle:@"点我" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

         [self addSubview:btn];
    }
    return self;
}
-(void)clickBtn:(UIButton *)btn
{
    NSLog(@"点击了 btn---%@---%d",self.delegate,[self respondsToSelector:@selector(blockViewClickBtn:)]);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(blockViewClickBtn:)]) {
        [self.delegate blockViewClickBtn:btn];
    }
    
}
@end
