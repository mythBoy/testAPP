//
//  NJWeibo.m
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "NJWeibo.h"

@implementation NJWeibo

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        /*
         @property (nonatomic, copy) NSString *text; // 内容 address
         @property (nonatomic, copy) NSString *icon; // 头像 thum
         @property (nonatomic, copy) NSString *name; // 昵称 merchant_name
         @property (nonatomic, copy) NSString *picture; // 配图  thumb
         */
//        [self setValuesForKeysWithDictionary:dict];
        
        
        self.text = dict[@"address"];
        self.icon = [testUtil isHttpNewProJ:dict[@"thum"]];
        
        self.name = dict[@"merchant_name"];
      
        self.picture = dict[@"thumb"] ?[testUtil isHttpNewProJ:dict[@"thumb"]] : nil;
       
       
        
        
    }
    return self;
}

+ (id)weiboWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
