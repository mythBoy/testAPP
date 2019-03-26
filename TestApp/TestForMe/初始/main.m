//
//  main.m
//  TestForMe
//
//  Created by Dance on 2017/3/8.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
int a=1; //全局变量存储在静态内存中，只初始化一次

void showMessage(){
    static int b=1; //静态变量存储在静态内存中，第二次调用不会再进行初始化
    int c=1;
    ++b;
    a+=2;
    NSLog(@"a=%p,b=%p,c=%p\n",&a,&b,&c);
    printf("===>>>a=%d,b=%d,c=%d\n",a,b,c);
}
int main(int argc, char * argv[]) {
    @autoreleasepool {
        
//        showMessage(); //结果：a=3,b=2,c=1
//        showMessage(); //结果：a=5,b=3,c=1
//        showMessage(); //结果：a=3,b=2,c=1
//        showMessage(); //结果：a=5,b=3,c=1
//        showMessage(); //结果：a=3,b=2,c=1
//        showMessage(); //结果：a=5,b=3,c=1
//        showMessage(); //结果：a=3,b=2,c=1
//        showMessage(); //结果：a=5,b=3,c=1
//        showMessage(); //结果：a=5,b=3,c=1
//        showMessage(); //结果：a=3,b=2,c=1
//        showMessage(); //结果：a=5,b=3,c=1
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
/*
 静态变量
 首先说一下存储在普通内存中的静态变量，全局变量和使用static声明的局部变量都是静态变量，在系统运行过程中只初始化一次（在下面的例子中虽然变量b是局部变量，在外部无法访问，但是他的生命周期一直延续到程序结束，而变量c则在第一次执行完就释放，第二次执行时重新创建）。
 */
