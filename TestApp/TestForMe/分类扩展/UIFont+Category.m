//
//  UIFont+Category.m
//  YuYu
//
//  Created by 1 on 16/11/17.
//  Copyright © 2016年 mac iko. All rights reserved.
//

#import "UIFont+Category.h"

#define RETIO kScreenSize.width/320.0

#define RETIO6 kScreenSize.width/375.0

@implementation UIFont (Category)

+ (UIFont *)rewriteSystemFontOfSize:(CGFloat)fontSize{
    
    
    return [UIFont systemFontOfSize:fontSize*RETIO];
    
    
}

+ (UIFont *)rewriteSystemFontOfSize6:(CGFloat)fontSize{
    
    
    return [UIFont systemFontOfSize:fontSize*RETIO6];
    
    
}

//以5为基准 粗体
+ (UIFont *)rewriteBolderSystemFontOfSize:(CGFloat)fontSize{
    return [UIFont boldSystemFontOfSize:fontSize*RETIO];
}

//以6为基准 粗体
+ (UIFont *)rewriteBolderSystemFontOfSize6:(CGFloat)fontSize{
    return [UIFont boldSystemFontOfSize:fontSize*RETIO6];
}


@end
