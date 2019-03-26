//
//  DXCViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "DXCViewController.h"
#import <objc/runtime.h>
@interface DXCViewController ()

@end

@implementation DXCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    kkk = @"123";
//    lll = @"456";
    for (NSString *name in [UIFont familyNames]) {
        NSLog(@"----%@",name);
    }


}
//+  (void)load
//{
//    //只执行一次这个方法
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        SEL originalSelector = @selector(systemFontOfSize:);
//        SEL swizzledSelector = @selector(mysystemFontOfSize:);
//        // Class class = class_getInstanceMethod((id)self);
//        Method originalMethod = class_getClassMethod(class, originalSelector);
//        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//        BOOL didAddMethod = class_addMethod(class,originalSelector,
//                                            method_getImplementation(swizzledMethod),
//                                            method_getTypeEncoding(swizzledMethod));
//        if (didAddMethod)
//        {
//            class_replaceMethod(class,swizzledSelector,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//
//        }
//        else
//        {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}



@end











