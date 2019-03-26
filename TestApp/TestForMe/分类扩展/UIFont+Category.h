//
//  UIFont+Category.h
//  YuYu
//
//  Created by 1 on 16/11/17.
//  Copyright © 2016年 mac iko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Category)

/*
 设置字体大小
 */


+ (UIFont *)rewriteSystemFontOfSize:(CGFloat)fontSize; //以5为基准

+ (UIFont *)rewriteSystemFontOfSize6:(CGFloat)fontSize; //以6为基准

+ (UIFont *)rewriteBolderSystemFontOfSize:(CGFloat)fontSize; //以5为基准 粗体

+ (UIFont *)rewriteBolderSystemFontOfSize6:(CGFloat)fontSize; //以6为基准  粗体


@end
