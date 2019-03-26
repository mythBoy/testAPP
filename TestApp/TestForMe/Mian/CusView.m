//
//  CusView.m
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "CusView.h"

@implementation CusView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tag = 111;
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(pass:)]) {
        [_delegate pass:(int)self.tag];
    }
}
@end
