//
//  MesForwordInvocationController.m
//  TestForMe
//
//  Created by Show on 2019/3/13.
//  Copyright © 2019 Dance. All rights reserved.
// http://www.cnblogs.com/fkdd/archive/2012/03/14/2396284.html //消息转发

#import "MesForwordInvocationController.h"

@interface MesForwordInvocationController ()
@property (nonatomic)
@end

@implementation MesForwordInvocationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息转发";
    self.showTableView = NO;
}
- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    
    if (!signature)
        signature = [self.carInfo methodSignatureForSelector:selector];
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = [invocation selector];
    
    if ([self.carInfo respondsToSelector:selector])
    {
        [invocation invokeWithTarget:self.carInfo];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
