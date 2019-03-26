//
//  AppDelegate.m
//  TestForMe
//
//  Created by Dance on 2017/3/8.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "ViewController.h"
#import "SFViewController.h"
#import "LKViewController.h"
#import "AnyWayViewController.h"
#import "anyViewController.h"
#import "BaseNavViewController.h"
#import "RootViewController.h"

#define SwitchChooice 2               //TEST模式 1/0   正式 2

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BaseViewController *vc;
    if (SwitchChooice == 0|| SwitchChooice == 1) {
        vc  = [[LearnViewController alloc] init];
        
    }else{
        
        vc = [[RootViewController alloc] init];
    }
    
    BaseNavViewController *nav= [[BaseNavViewController alloc] initWithRootViewController:vc];


    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
//    NSString* testObject = [[NSData alloc] init]; //testObject在编译时和运行时分别是什么类型的对象？
//    [testObject stringByAppendingString:@""];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)xx
{
    NSMutableArray *array = @[@4,@3,@5,@1,@7,@8,@6,@2].mutableCopy;
    
    for (int i = 0; i<array.count-1; i++) {
            NSNumber *midNum = array[i];//1
            int index = i;//1
            for (int j = i; j<array.count-1; j++) {
//                NSLog(@"====比较%@和%@",midNum,array[j+1]);
                if ([midNum compare:array[j+1]] == NSOrderedDescending)//前大 后小
                {
                    
                    midNum = array[j+1];//最小的
//                       NSLog(@"mid=%@",midNum);
                    index = j+1;
                 
                }
                [array exchangeObjectAtIndex:i withObjectAtIndex:index];
            }
            NSLog(@"===%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]);
    }
   
}
- (void)mm
{
      NSMutableArray *array = @[@4,@3,@5,@1,@7,@8,@6,@2].mutableCopy;
    for (int i= 0; i<array.count-1; i++) {
        
        for (int j = 0;j<array.count-1-i;j++) {
            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {//qian da
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
         NSLog(@"===%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]);
    }
     NSLog(@"===%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]);
}


- (void)aa
{
     NSMutableArray *array = @[@4,@3,@5,@1,@7,@8,@6,@2].mutableCopy;//13547862
    NSNumber *midNum = array[0];//1
    int index = 0;//1
    for (int j = 0; j<array.count-1; j++) {
        NSLog(@"====比较%@和%@",midNum,array[j+1]);
        if ([midNum compare:array[j+1]] == NSOrderedDescending)//前大 后小
        {
            midNum = array[j+1];//最小的
            index = j+1;
        }
        [array exchangeObjectAtIndex:0 withObjectAtIndex:index];
    }
    NSLog(@"===%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7]);
}






//- (void)MMMMM
//{
//  NSMutableArray *array = @[@4,@3,@5,@1,@7,@8,@6,@2].mutableCopy;//13547862
//    
//    for (int i =0; i<array.count-1; i++) {
//        for (int j = 0; j<array.count-1-i; j++) {
//            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {//前大后小
//                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
//            };
//        }
//
//    }
//       NSLog(@"%@",array);
//
//}


//- (void)MMMMM
//{
//    NSMutableArray *array = @[@4,@3,@5,@1,@7,@8,@6,@2].mutableCopy;//13547862
//    
//    for (int i =0; i<array.count-1; i++) {
//        
//        NSNumber *midNum = array[i];
//        int mid = i;
//        for (int j = i; j<array.count-1; j++) {
//            if ([midNum compare:array[j+1]] == NSOrderedDescending) {//前大后小
//                midNum = array[j+1];
//                mid = j+1;
//            };
//        }
//
//         [array exchangeObjectAtIndex:i withObjectAtIndex:mid];
//    }
//    NSLog(@"%@",array);
//    
//}

- (void)MMMMM
{
    NSMutableArray *ary = @[@"abc",@"C",@"A",@"b",@"T",@"d",].mutableCopy;//13547862
    
    
    
//    NSArray *ary = @[@"a3",@"a1",@"a2",@"a24",@"a14"];
    
    
//    NSLog(@"%@",ary);
    
    
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
    
    
//    NSArray *myary = [ary sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];//注意这里的ary进行排序后会生产一个新的数组指针，myary，不能在用ary,ary还是保持不变的。
    
//    
//    NSLog(@"%@-%@-%@-%@-%@-%@",myary[0],myary[1],myary[2],myary[3],myary[4],myary[5]);
//    
//    NSArray *arry;
//    NSMutableArray *a =  [NSMutableArray arrayWithArray:arry];
//    NSLog(@"%@",a);
//
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    NSLog(@"path:%@", path);
}

- (void)getBun
{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//  
//    // app名称
//    NSString *app_Name =    [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    // app版本
//    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    // app build版本
//    NSString *app_build =   [infoDictionary objectForKey:@"CFBundleVersion"];
//    NSLog(@"%@-%@-%@",       app_Name,app_Version,app_build);
//    
//    
//    UIImage *imag = [UIImage imageNamed:@"title"];
//    NSData *data = UIImagePNGRepresentation(imag);
//    NSString *str = [data base64Encoding];
//    
//  
//    NSLog(@"-->%@",str);
    
    
    NSData *nsdata = [@"iOS Developer Tips encoded in Base64"
                      dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    // Print the Base64 encoded string
    NSString *str = [nsdata base64Encoding];
    
    
    NSLog(@"Encoded:%@",str);

    NSLog(@"Encoded: %@", base64Encoded);
    ///////////////////////////////////
    
//    NSData *nsdataFromBase64String = [[NSData alloc]
//                                      initWithBase64EncodedString:base64Encoded options:0];
//    
//    // Decoded NSString from the NSData
//    NSString *base64Decoded = [[NSString alloc]
//                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
//    NSLog(@"Decoded: %@", base64Decoded);
//    NSArray *a = [NSArray array];
//    NSArray *b = [a copy];
//    NSLog(@"%p--%p",a,b);
//    a = @[@"a"];
//    b = @[@"b"];
//    NSLog(@"%@--%@",a,b);
//    NSLog(@"%p--%p",a,b);
 

    

}




























@end
