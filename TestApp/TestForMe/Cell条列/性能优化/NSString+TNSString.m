//
//  NSString+TNSString.m
//  TestForMe
//
//  Created by Music on 2018/1/18.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import "NSString+TNSString.h"

@implementation NSString (TNSString)
+ (instancetype)stringWithFormat1:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
   return  [[self class] stringWithFormat:@"%@",format];
    
}
-(void)dealloc
{
    
//    NSLog(@"TNSString字符串释放了");
    
}
@end
