//
//  BlockViewController.m
//  TestForMe
//
//  Created by Dance on 2017/7/5.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BlockViewController.h"
#import "block1ViewController.h"
typedef void (^YYJumpProtocolBlock)(id obj, int type, NSInteger number,NSError * error);
typedef NS_ENUM(NSInteger, IMUserType) {
    IMUserTypeP2P = 1 << 0,
    IMUserTypeDiscuss = 1 << 1,
    IMUserTypeFriendCenter = 1 << 2,
    IMUserTypeBoradcast = 1 << 3,
    IMUserTypeAdmin = 1 << 10,
};

typedef NS_ENUM(NSInteger, pptype) {
    pptypeP2P = 1 << 0,
    pptypeDiscuss = 1 << 1,
    pptypeFriendCenter = 1 << 2,
    pptypeBoradcast = 1 << 3,
    pptypeTypeAdmin = 1 << 10,
};
typedef  int(^adddBlock)(int, int);
@interface BlockViewController ()
@property (nonatomic,assign) void(^myblock)();
//@property (nonatomic,assign)int(^adddBlock)(int, int);
//@property (nonatomic,copy) NSString *(^myblock1)(NSString *);

@end

@implementation BlockViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)testWithDic:(NSDictionary *)dic andTitle:(NSString *)title
{
    NSLog(@"perfect!~~~name:%@---class:%@ ",dic[@"name"],title);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    block1ViewController *block = [[block1ViewController alloc] init];
    block.testBlock = self.testBlock;
    [self.navigationController pushViewController:block animated:YES];
}
- (void)test1
{
    
    //1 __NSGlobalBlock__  全局block   存储在代码区（存储方法或者函数）
    void(^myBlock1)() = ^() {
        NSLog(@"我是老大");
    };
    
    NSLog(@"%@",myBlock1);
    
    
        //2 __NSStackBlock__  栈block  存储在栈区
        //block内部访问外部变量
        //block的本质是一个结构体
    int n = 5;
        void(^myBlock2)() = ^() {
            NSLog(@"我是老二%d", n);
        };
        NSLog(@"%@", myBlock2);
    
    
    
    
    //3 __NSMallocBlock__  堆block 存储在堆区  对栈block做一次copy操作
    void(^myBlock3)() = ^() {
        NSLog(@"我是老二%d", n);
    };
    NSLog(@"%@", [myBlock3 copy]);
    
    
    
    /*
     
     由以上三个例子可以看出当block没有访问外界的变量时,是存储在代码区,
     当block访问外界变量时时存储在栈区, 而此时的block出了作用域就会被释放
     以下示例:
     */
    [self test];//当此代码结束时,test函数中的所有存储在栈区的变量都会被系统释放, 因此如果属性的block是用assign修饰时  当再次访问时就会出现野指针访问.
    NSLog(@"%@",self.myblock);
//    self.myblock();

}
- (void)test {
    int n = 5;

    [self setMyblock:^{
        NSLog(@"%d",n);
    }];
    NSLog(@"test--%@前", ^{ NSLog(@"%d",n); });      //test--<__NSStackBlock__: 0x7fff5227cac0>前
    NSLog(@"test--%@前", [^{ NSLog(@"%d",n);} copy] ); //test--<__NSMallocBlock__: 0x6000004404b0>前
   
    NSLog(@"test--%@后",self.myblock);    //test--<__NSMallocBlock__: 0x60000025d940>后
    
}
- (void)test2
{

    
    
    NSArray *testArr = @[@"1", @"2"];
    
    void (^TestBlock)(void) = ^{
        
        NSLog(@"testArr :%@", testArr);//引用外部变量 testArr 数组
    };
    
    NSLog(@"block is %@",
          ^{
        
           NSLog(@"test Arr :%@", testArr);
          }
          );
    
    //block is <__NSStackBlock__: 0xbfffdac0>
    
    //打印可看出block是一个 NSStackBlock, 即在栈上, 当函数返回时block将无效
    
    NSLog(@"block is %@", TestBlock);
    
    //block is <__NSMallocBlock__: 0x75425a0>
    
    //上面这句在非arc中打印是 NSStackBlock, 但是在arc中就是NSMallocBlock
    
    //即在arc中默认会将block从栈复制到堆上，而在非arc中，则需要手动copy.
    
   
}

/******************************************************************************************/
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//
//    [self test122];
//    [self test123];
//     [self  test1];
//     [self  test2];
//     [self  test3];
  
    
    
}
- (void)test3
{
//    void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
//    {
////        if (group == nil) {
////            return;
////        }
////        
////        // added fix for camera albums order
////        NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
////        NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
////        
////        if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
////            
////            [self.assetGroups insertObject:group atIndex:0];
////        }
////        else {
////            [self.assetGroups addObject:group];
////        }
////        
////        // Reload albums
////        [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
//    };
//    
//    // Group Enumerator Failure Block
//    void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
//        
////        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"照片访问被禁止，请在隐私设置中打开" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
////        [alert show];
////        
////        NSLog(@"A problem occured %@", [error description]);
//    };
//    
////    // Enumerate Albums
////    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
////                                usingBlock:assetGroupEnumerator
////                              failureBlock:assetGroupEnumberatorFailure];
//    
////}

}
- (void )test122
{
    [BlockViewController returnCommanderSenderURL:@"" block:^(id obj, int type, NSInteger number, NSError *error) {
        
        
        NSLog(@"%@",obj);
    }];
}
+ (void)returnCommanderSenderURL:(NSString *)url
                           block:(YYJumpProtocolBlock)jumpProtocolBlcok
{
    NSInteger type = 0;
    NSDictionary * dic = @{
                           @"name":@"jack",
                           @"age":@"18"
                           };

    
        [BlockViewController YYJumpRealizationBlockType:type dic:dic block:(YYJumpProtocolBlock)jumpProtocolBlcok];
    

    
}
+ (void)YYJumpRealizationBlockType:(NSInteger)type dic:(NSDictionary *)dic block:(YYJumpProtocolBlock)jumpProtocolBlcok
{

    
    
    
   
    switch (type) {
            

              case 0:
        {
       
             NSString * webStr = @"asdsad";
            
            if (jumpProtocolBlcok) {
                jumpProtocolBlcok(webStr,0 ,type ,nil);
            }
        }
            break;
        default:
            break;
    }
}

/**************************************************************************************************************/
- (void )test123
{
    [BlockViewController returnCommanderSenderURL1:@"" block:^(id obj, int type, NSInteger number, NSError *error) {
        
        
        NSLog(@"%@",obj);
    }];
}
+ (void)returnCommanderSenderURL1:(NSString *)url
                           block:(YYJumpProtocolBlock)jumpProtocolBlcok
{
    int type = 0;
    NSDictionary * dic = @{
                           @"name":@"jack",
                           @"age":@"18"
                           };
    
    
    if (jumpProtocolBlcok) {
        jumpProtocolBlcok(dic,type,1,nil);
    }
    
    
    
}
@end

/*
 block总结 1
 带返回值得block 可以找个参数接着他
         int(^addBlock)(int,int) = ^(int x, int y){
         return x+y;
         };
         
         
         int asd =  addBlock(2,3);
         NSLog(@"%d",asd);
 */





