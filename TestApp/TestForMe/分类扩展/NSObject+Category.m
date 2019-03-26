//
//  NSObject+Category.m
//  自己的扩张类
//
//  Created by mac iko on 13-9-19.
//  Copyright (c) 2013年 mac iko. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>



static char __logDeallocAssociatedKey__;

@interface LogDealloc : NSObject
@property (nonatomic, copy) NSString *message;
@end

@implementation LogDealloc
- (void)dealloc
{
    NSLog(@"dealloc :%@",self.message);
}
@end



@implementation NSObject (Category)

+ (NSString *)classString
{
    return NSStringFromClass([self class]);
}

- (NSString *)classString
{
    return NSStringFromClass([self class]);
}


- (void)associateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weakAssoicateVaule:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)accociatedVauleForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}


- (BOOL)isVauleForKeyPath:(NSString *)keyPath equalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        id objectValue = [self valueForKeyPath:keyPath];
        return ([objectValue isEqual:value] || ((objectValue == nil) && (value == nil)));
    }
    return NO;
}

- (BOOL)isVauleForKeyPath:(NSString *)keyPath identicalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        return ([self valueForKeyPath:keyPath] == value);
    }
    return NO;
}

+ (NSDictionary *)propertyAttributes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int count = 0;
    objc_property_t *properies = class_copyPropertyList(self, &count);
    
    for (int i = 0  ; i < count; i ++)
    {
        objc_property_t property = properies[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [dictionary setObject:attribute forKey:name];
    }
    free(properies);
    
    if ([dictionary count] > 0) {
        return dictionary;
    }
    return nil;
}
//- (id)objectForKeyEmptyString:(NSString*)key{
//    
//    if ([self  isKindOfClass:[NSDictionary class]]) {
//        
//        NSDictionary  *midDic = (NSDictionary*) self;
//        
//        return [midDic reTurnemptyStrobjectOrNilForKey:key];
//        
//    }else{
//        return @"";
//    }
//}
//- (id)objectForKeyEmptyObject:(NSString*)key{
//    
//    if ([self  isKindOfClass:[NSDictionary class]]) {
//        
//        NSDictionary  *midDic = (NSDictionary*) self;
//        
//        return [midDic objectOrNilForKey:key];
//        
//        
//    }else{
//        return nil;
//        
//    }
//}
- (void)logOnDealloc
{
    if (objc_getAssociatedObject(self, &__logDeallocAssociatedKey__) == nil)//获取
    {
        LogDealloc *log = [[LogDealloc alloc] init];
        log.message = NSStringFromClass(self.class);
        objc_setAssociatedObject(self, &__logDeallocAssociatedKey__, log, OBJC_ASSOCIATION_RETAIN); //关联保存 log
//        NSLog(@"%@",objc_getAssociatedObject(self, &__logDeallocAssociatedKey__));
        /*
         添加属性 管理应用
         原理:
          1 push每次新建控制器,initXib调用分类方法 创建一个logDealloc对象 用个属性记录当前类名
          2 防止方法结束对象释放,在分类中需要,用个全局变量保存该对象(属性为类名),因为是分类所以关联创建属性,
          3 pop控制器(本类)销毁,分类全局变量销毁,logDealloc对象销毁,调用对象logDealloc的dealloc方法 打印类名
         
         */
    }
}

@end
