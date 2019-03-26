//
//  SFViewController.m
//  TestForMe
//
//  Created by Dance on 2017/3/17.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "SFViewController.h"

//static int instance3 = 20;//这叫全局变量(仅仅本类使用)
@interface SFViewController ()
//@property (nonatomic ,copy)NSString *instance5;这也叫成员变量
{
 NSString *instance1;//这叫成员变量
}
@end
NSString *instance;// 这也叫全局变量
@implementation SFViewController
{

    NSString *instance4;//这也叫成员变量
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

//    NSLog(@"=1==%d",instance2);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self mmmmp];
    
//    [self choice];
//    dispatch_time_t delayInNanoSeconds =dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//    dispatch_queue_t concurrentQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//    dispatch_after(delayInNanoSeconds, concurrentQueue, ^(void){
//        
//        NSLog(@"%@", [NSThread currentThread]);
//    });
//    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
//    
//    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//       NSLog(@"%@", [NSThread currentThread]);
//    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//冒泡排序
- (NSMutableArray *)mppx
{
    NSMutableArray *array = @[@4,@8,@5,@7,@2,@6,@3,@1,@0].mutableCopy;//count =9//8
    
    
    
    for (int i = 0; i<array.count-1; i++) {
            for (int j= 0; j<array.count-1-i; j++) {
                NSLog(@"%d--%d",j,j+1);
                if ([ array[j] compare:array[j+1] ]== NSOrderedDescending) {//前大 后小  Descending降序
                    [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];//前小 后大
                }
            }
//        NSLog(@"middle-%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    }
    
//    NSLog(@"last--%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    return array;
}
/*
 457263108
 452631078
 425310678
 
 
 
 */

//选择排序
- (NSMutableArray *)choice
{
    /*原理:  1 从第一个开始 依次比较数组中每一个元素，
            2 碰到更小 留下小的，继续比较
            3 每一趟比较找到最小的 放在最前面
     */
    NSMutableArray *array = @[@4,@8,@0,@7,@1,@6,@3,@2,@5].mutableCopy;//count=9    index = 0~8
    
    /*
     48 04 07  01  06 03 02 05
     */
    
//    int i,j,arr[10];
    NSNumber *temp;  //临时变量
//
//    for(i=0;i<10;i++){
//        
//        scanf("%d",&arr[i]);
//    }
    
            for(int i=0;i<array.count-1;i++){  //0~7   9个数两两比较八次就可以了
                
                for(int j=i+1;j<array.count;j++){//   int j= 1; j<9 ;j++   1~8
                            
                            //  4
                            
                            if([array[i] compare: array[j]] == NSOrderedDescending){//如果  前大 后小

//                                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                                temp = array[i];
                                array[i] = array[j];
                                array[j] = temp;


                            }
                            NSLog(@"i=%d %@--j=%d %@",i,array[i] ,j, array[j]);
                            NSLog(@"begin-%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
                           
                }
//                 NSLog(@"middle-%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    }
    NSLog(@"last--%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    return array;
}



- (void)MP
{
   NSMutableArray *array = @[@1,@0,@5,@9,@2,@3].mutableCopy;//5ci
    for (int j= 0;j<array.count;j++) {
        if ([array[j] compare:array[j+1]] == NSOrderedDescending) {//前大后小
            
            
            [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            
        }
    }
}

















NSMutableArray * MP()
{
    /*
     015239
     012359
     012369
     012369
     012369
     */
    NSMutableArray *array = @[@1,@0,@5,@9,@2,@3].mutableCopy;//5ci
    for (int i = 0; i<array.count; i++) {
        for (int j= 0;j<array.count-1-i;j++) {
            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {//前大后小
                
                
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                
            }
        }
        NSLog(@"%@-%@-%@-%@-%@-%@",array[0],array[1],array[2],array[3],array[4],array[5]);
    }
    NSLog(@"%@",array);
    return array;
    
    
    
}
NSMutableArray * xz()
{
    NSMutableArray *array = @[@9,@1,@0,@5,@2,@3].mutableCopy;//5ci
    
    
    for (int i = 0; i<array.count; i++) {
        
        NSNumber *mid = array[i];
        
        for (int j =i; j<array.count-1; j++) {
            if ([mid compare:array[j+1]] == NSOrderedDescending) {//前大后小
                mid = array[j+1];
                
            }
            
            
        }
        
        [array exchangeObjectAtIndex:i withObjectAtIndex:[array indexOfObject:mid]];
        NSLog(@"%@-%@-%@-%@-%@-%@",array[0],array[1],array[2],array[3],array[4],array[5]);
    }
    
    
    NSLog(@"%@",array);
    return array;
  
}

//mpmp
- (void )newMpmp
{
    NSMutableArray *array = @[@3,@2,@7,@1,@8,@4,@6,@5,@3,@4,@0,@9].mutableCopy;
    
    for (int i = 0; i<array.count-1; i++) {
        for (int j= 0; j<array.count-1-i; j++) {
            if ( [array[j] compare:array[j+1]] == NSOrderedDescending) {//降序
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
          
            
        }
    }
    NSLog(@"%@",array);
}




- (void)newChoice
{
    
     NSMutableArray *array = @[@4,@8,@5,@7,@2,@6,@3,@1,@0].mutableCopy;//count == 9    index= 0~8

    NSNumber *midNum;//choice
    for (int i = 0; i<array.count -1 ; i++) {//两两比较八次就够了
        for (int j= i+1; j<array.count; j++) {// 比较1~8
            if ( [array[i] compare:array[j]] == NSOrderedDescending ) { // 如果前大 后小
                midNum = array[i];
                array[i] = array[j];
                array[j] = midNum;
            }


        }
    }

//   /*
//
//    */
//
    
//    //
//    //maopao
//    NSMutableArray *array = @[@4,@8,@5,@7,@2,@6,@3,@1,@0].mutableCopy;//count == 9    index= 0~8
//
//    NSNumber *midNum;//choice
//
//    for (int i = 0; i<array.count-1; i++) {
//        for (int j = 0 ; j<array.count-1-i; j++) {
//            if ([array[j] compare:array[j+1]] == NSOrderedDescending) {
//
//                midNum = array[j];
//                array[j] = array[j+1];
//                array[j+1] = midNum;
//            }
//        }
//    }
    /*
     NSMutableArray *array = @[@1,@2,@4,@0,@3].mutableCopy;  //0-3
     for (int i = 0; i<array.count-1; i++) {
     for (int j=i+1; j<array.count-1-i; j++) {
     NSNumber *a = array[j] ;
     NSNumber *b = array[j+1];
     NSLog(@"%@---%@",a,b);
     if ([a compare: b] == NSOrderedDescending) {//j更大
     
     [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
     }
     
     
     }
     NSLog(@"%@",array);
     }
     NSLog(@"====%@",array);
     */
    // 负责减去
   NSLog(@"last--%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    
}





- (void)mmmmp
{
    /*
     12034
     10234
     10234
     01234
     */
//    NSMutableArray *array = @[@1,@2,@4,@0,@3].mutableCopy;  //0-3
//    for (int i = 0; i<array.count-1; i++) {
//        for (int j=0; j<array.count-1-i; j++) {
//            NSNumber *a = array[j] ;
//            NSNumber *b = array[j+1];
//        NSLog(@"%@---%@",a,b);
//            if ([a compare: b] == NSOrderedDescending) {//j更大
//
//                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
//            }
//
//
//        }
//           NSLog(@"%@",array);
//    }
//    NSLog(@"====%@",array);
    NSMutableArray *array = @[@4,@8,@5,@7,@2,@6,@3,@1,@0].mutableCopy;//count == 9    index= 0~8
    
    /*
     085746321
     018756432
     012756438
     012756438
     
     */
    
    NSNumber *midNum;//choice
    for (int i = 0; i<array.count -1 ; i++) {//两两比较八次就够了( 其中a 和n-1比较)
      
                           
        for (int j= i+1; j<array.count; j++) {// 比较1~8
              NSLog(@"比较%@--%@",array[i] ,array[j]);
                                 
            if ( [array[i] compare:array[j]] == NSOrderedDescending ) { // 如果前大 后小
                midNum = array[i];
                array[i] = array[j];
                array[j] = midNum;
            }
            
            
        }
          NSLog(@"mid--%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
    }
      NSLog(@"last--%@%@%@%@%@%@%@%@%@",array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8]);
}

















@end
