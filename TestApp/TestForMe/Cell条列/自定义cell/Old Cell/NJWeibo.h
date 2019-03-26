//
//  NJWeibo.h
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJWeibo : NSObject
@property (nonatomic, copy) NSString *text; // 内容 address
@property (nonatomic, copy) NSString *icon; // 头像 thum
@property (nonatomic, copy) NSString *name; // 昵称 merchant_name
@property (nonatomic, copy) NSString *picture; // 配图  thumb
@property (nonatomic, assign) BOOL vip;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)weiboWithDict:(NSDictionary *)dict;
@end
