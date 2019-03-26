//
//  NewWeiBo.h
//  TestForMe
//
//  Created by Music on 2018/3/12.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewWeiBo.h"

@interface NewWeiBo : NSObject
/**
 *  头像的frame
 */
@property (nonatomic, assign) CGRect iconF;
/**
 *  昵称的frame
 */
@property (nonatomic, assign) CGRect nameF;
/**
 *  vip的frame
 */
@property (nonatomic, assign) CGRect vipF;
/**
 *  正文的frame
 */
@property (nonatomic, assign) CGRect introF;
/**
 *  配图的frame
 */
@property (nonatomic, assign) CGRect pictrueF;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  模型数据
 */
@property (nonatomic, strong) NSDictionary *dict;



//@property (nonatomic, copy) NSString *text; // 内容 address
//@property (nonatomic, copy) NSString *icon; // 头像 thum
//@property (nonatomic, copy) NSString *name; // 昵称 merchant_name
//@property (nonatomic, copy) NSString *picture; // 配图  thumb
//@property (nonatomic, assign) BOOL vip;

//- (id)initWithDict:(NSDictionary *)dict;
//+ (id)weiboWithDict:(NSDictionary *)dict;

@end
