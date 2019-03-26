//
//  NSObject+TPerson.m
//  TestForMe
//
//  Created by Dance on 2017/3/16.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "NSObject+TPerson.h"
#import <objc/runtime.h>
@implementation NSObject (TPerson)

//static char *PersonNameKey = "PersonNameKey";
//-(void)setName:(NSString *)name{

    /*
     OBJC_ASSOCIATION_ASSIGN;            //assign策略
     OBJC_ASSOCIATION_COPY_NONATOMIC;    //NONATOMIC copy策略
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;  //NONATOMIC retain策略
     
     OBJC_ASSOCIATION_RETAIN;   //retain策略
     OBJC_ASSOCIATION_COPY;     // copy策略
     */



    /*
     *
     id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
   
//    objc_setAssociatedObject(self, PersonNameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//-(NSString *)name{
//    return objc_getAssociatedObject(self, PersonNameKey);
//}

- (void)setName:(NSString *)name
{
    objc_setAssociatedObject(self,"nameKey",name,OBJC_ASSOCIATION_COPY);
}

- (NSString*)name
{
    NSString *nameObject = objc_getAssociatedObject(self, "nameKey");
    return nameObject;
}


@end
