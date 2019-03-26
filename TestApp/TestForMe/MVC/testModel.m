//
//  testModel.m
//  TestForMe
//
//  Created by Dance on 2017/5/15.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "testModel.h"

@implementation testModel

-(instancetype)init
{
    if (self = [super init]) {
        _testBlock = ^{
//            NSLog(@"self =%@",self);
        };
        
       
    }
     return self;
}
-(void)dealloc
{

    
    if (!self.name.length) {
        NSLog(@"testModel is dealloc 但是名称未赋值");
    }else{
    NSLog(@"名称为%@的testModel is dealloc",self.name);
    }
   
}
@end
