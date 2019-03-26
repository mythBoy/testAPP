//
//  NCViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/22.
//  Copyright © 2017年 Dance. All rights reserved.
//  非ARC 模式   非ARC 模式    非ARC 模式   非ARC 模式 非ARC 模式   非ARC 模式 非ARC 模式   非ARC 模式 非ARC 模式   非ARC 模式 非ARC 模式   非ARC 模式 非ARC 模式   非ARC 模式非ARC 模式   非ARC 模式

#import "NCViewController.h"
#import "Person.h"
#import "Man.h"
#import "NSArray+Test.h"
#import <objc/runtime.h>
struct haha{
    int typeOne;
    int typeTwo;
}xixi;

typedef struct aa {
    int typeOne;
    int typeTwo;
}ppp;
typedef ppp *www;

typedef void (^addBlock)(id);

@interface NCViewController ()
@property (nonatomic,retain)Person *p1;
@property (nonatomic,strong)UIImageView *yourImageView;

@property (nonatomic, copy) void(^myblock)();
@end

@implementation NCViewController
{
           NSObject* _instanceObj;
     NSString *_weakString;
    

}
- (void)viewDidLoad
{

    [super viewDidLoad];
    

 //    typedef void(^blk) (void);
//    
//    //未加copy
//    //    id obj1 = [self getArray1];
//    //    blk kk1 = (blk) [obj1 objectAtIndex:0];
//    //    kk1();
//    //加copy
//    //    id obj = [self getArray];
//    //    blk kk = (blk) [obj objectAtIndex:0];
//    //    kk();//
//    addBlock abcd;
//    {
//        id array = [NSMutableArray array];
////        id __weak array1 = array;
//        //加copy
//        //   return [^(id obj){
//        //        [array addObject:obj];
//        //        NSLog(@"-数组的个数为--%lu",(unsigned long)array.count);
//        //    } copy];
//        
//        //未加copy
//        abcd =^(id obj){
//            [array addObject:obj];
//            NSLog(@"-数组的个数为--%lu",(unsigned long)[array count]);
//        };
//    }
//    
//    
//    
//    abcd([[NSObject alloc] init]);
//    abcd([[NSObject alloc] init]);
//    abcd([[NSObject alloc] init]);
  
   
//    [self staticBlock];
//    [self testpppp];
   
    self.baseDataArray = @[
                           @"test1 block",
                           @"AutoReleasePoor",
                           ];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row ) {
        case 0:
             [self test1];
            break;
        case 1:
           
            break;
            
        default:
            break;
    }
    
}
- (NSArray *)getArray
{
    int var = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"block1:%d",var);},
            ^{NSLog(@"block2:%d",var);},
            nil] ;
}
struct data {
    __unsafe_unretained  NSString *str;// __unsafe_unretained  修饰符 不属于oc内存管理对象 所以可以使用
};
+(instancetype)alloc
{
    return [self allocWithZone:NSDefaultMallocZone()];
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
   
    return NSAllocateObject(self, 0, zone);
}

- (NSUInteger)retainCounta
{
    return NSExtraRefCount(self)+1;
}
void test()
{
    int a[4]={1,2,3,4};
    printf("a的地址%p\n",&a);
    printf("a的地址%p\n",a);
      printf("a的地址%p\n",&(a[0]));
}
void test1()
{
//    NSAutoreleasePool *poor = [[NSAutoreleasePool alloc] init];
//    
//            NSArray *a = [NSArray array];
//            a= @[@"asd",@"dsa"];
//            Person *p = [[Person alloc] init];
//            Man *man = [[Man alloc] init];
//            [man autorelease];
//    
//    [poor drain];
//    NSLog(@"=p==%@",p);
    
    id __autoreleasing p;
    @autoreleasepool {
//        NSArray *a = [NSArray array];
//        a= @[@"asd",@"dsa"];
        
        p = [[Person alloc] init];
        
        Man *man = [[Man alloc] init];
        [man autorelease];
    }
   
    NSLog(@"=p==%@",p);


}

- (NSString *)setBi:(void *)bi
{
    NSLog(@"你好呀");
return @"你好呀";

}
- (void)dealloc
{
 [super dealloc];//非arc
}

//不理解为什么 p 要retain
-(void) test3
{
    
    id obj = [[NSObject alloc] init]; //1
    NSLog(@"%lu",(unsigned long)[obj retainCount]);//1
    
    
    void *p = [obj retain];//1
    NSLog(@"%lu",(unsigned long)[obj retainCount]);//1
    NSLog(@"%lu",(unsigned long)[(id)p retainCount]);//1
    
    
    [obj release];//2
    NSLog(@"%lu",(unsigned long)[obj retainCount]);
    NSLog(@"%lu",(unsigned long)[(id)p retainCount]);
//    [obj release];
}
/********************************************************************************************/
//测试block 三种类型
- (void)test1
{
    //block 在内存中分为三种类型 __NSGlobalBlock__；__NSStackBlock__；__NSMallocBlock__
    
    
    //非ARC 模式下
    //1 __NSGlobalBlock__  全局block   存储在代码区（存储方法或者函数）
    void(^myBlock1)() = ^() {
        NSLog(@"我是老大");
    };
    
    NSLog(@"我是老大 %@",myBlock1);
    NSLog(@"我是老大copy %@", [myBlock1 copy]);
    
    //备注：block 中不引用外部变量 得到 __NSGlobalBlock__
    
    
    
    /*****************************************************/
        //2 __NSStackBlock__  栈block  存储在栈区
        //block内部访问外部变量
        //block的本质是一个结构体
    int n = 5;
        void(^myBlock2)() = ^() {
            NSLog(@"我是老二%d", n);
        };
        NSLog(@"我是老二 %@", myBlock2);
        NSLog(@"我是老二copy %@", [myBlock2 copy]);
    
    
    // 备注当block 中引用外部变量，在非ARC模式下，得到 __NSStackBlock__，存储在栈区，在ARC模式下则自动copy到堆区
    // 对[__NSStackBlock__ copy] 即为copy到堆去得到 __NSMallocBlock__
    
    
    /*****************************************************/
    //3 __NSMallocBlock__  堆block 存储在堆区  对栈block做一次copy操作
    void(^myBlock3)() = ^() {
       
        NSLog(@"我是老三%d", n);
       
    };
    NSLog(@"我是老三 %@", [myBlock3 copy]);
    [myBlock3 copy];
    NSLog(@"%lu",(unsigned long)[myBlock3 retainCount]);//
    
    
    
    /*
     
     由以上三个例子可以看出当block没有访问外界的变量时,是存储在代码区,
     当block访问外界变量时时存储在栈区, 而此时的block出了作用域就会被释放
     以下示例:
     */
    [self test];//当此代码结束时,test函数中的所有存储在栈区的变量都会被系统释放, 因此如果属性的block是用assign修饰时  当再次访问时就会出现野指针访问.
    self.myblock();
    
}
- (void)test {
    int n = 5;
    
    [self setMyblock:^{
        NSLog(@"%d",n);
    }];
    NSLog(@"test--%@",self.myblock);
    
}
- (void)staticBlock{
    
    static int base = 100;
    
    long (^sum)(int, int) = ^ long (int a, int b) {
        
        base++;
        
        return base + a + b;
        
    };
    
    base = 0;
    
    printf("%ld\n",sum(1,2));
    
    // 这里输出是4，而不是103, 因为base被设置为了0
    
    printf("%d\n", base);
    
    // 这里输出1， 因为sum中将base++了
    
}
NSObject* __globalObj = nil;
- (void) testpppp
{
    
    _instanceObj = [[NSObject alloc] init];
    static NSObject* __staticObj = nil;
    
    __globalObj = [[NSObject alloc] init];
    
    __staticObj = [[NSObject alloc] init];
    
    NSObject* localObj = [[NSObject alloc] init];
    
    __block NSObject* blockObj = [[NSObject alloc] init];
    
    typedef void (^MyBlock)(void) ;
    
    MyBlock aBlock = ^{
        
        NSLog(@"%@", __globalObj);
        
        NSLog(@"%@", __staticObj);
        
        NSLog(@"%@", _instanceObj);
        
        NSLog(@"%@", localObj);
        
        NSLog(@"%@", blockObj);
        
    };
    
    aBlock = [[aBlock copy] autorelease];
    
    aBlock();
    
    NSLog(@"%lu", (unsigned long)[__globalObj retainCount]);
    
    NSLog(@"%lu", (unsigned long)[__staticObj retainCount]);
    
    NSLog(@"%lu", (unsigned long)[_instanceObj retainCount]);
    
    NSLog(@"%lu", (unsigned long)[localObj retainCount]);
    
    NSLog(@"%lu", (unsigned long)[blockObj retainCount]);
    
}






@end
