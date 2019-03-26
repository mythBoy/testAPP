//
//  NSObject+Category.h
//  自己的扩张类
//
//  Created by mac iko on 13-9-19.
//  Copyright (c) 2013年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)


+ (NSString *)classString;
- (NSString *)classString;


- (void)associateValue:(id)value withKey:(void *)key;
- (void)weakAssoicateVaule:(id)value withKey:(void *)key;
- (id)accociatedVauleForKey:(void *)key;


- (BOOL)isVauleForKeyPath:(NSString *)keyPath equalToVaule:(id)value;
- (BOOL)isVauleForKeyPath:(NSString *)keyPath identicalToVaule:(id)value;
////用于取值   数据不规范状态下  返回空字符使用
//- (id)objectForKeyEmptyString:(NSString*)key;
//
////用于取值   数据不规范状态下  返回空对象使用
//- (id)objectForKeyEmptyObject:(NSString*)key;

+ (NSDictionary *)propertyAttributes;

- (void)logOnDealloc;
@end
