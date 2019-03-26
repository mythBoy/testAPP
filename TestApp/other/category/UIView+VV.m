//
//  UIView+VV.m
//  CifcoMedia
//
//  Created by Music on 16/10/28.
//  Copyright © 2016年 liudou. All rights reserved.
//

#import "UIView+VV.h"

@implementation UIView (VV)
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

@end
