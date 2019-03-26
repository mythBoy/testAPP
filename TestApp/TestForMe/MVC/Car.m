//
//  Car.m
//  TestForMe
//
//  Created by Dance on 2017/3/22.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "Car.h"

@implementation Car
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //    NSLog(@"%@",self.car);
    [aCoder encodeObject:self.paizi forKey:@"car"];

    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.paizi = [aDecoder decodeObjectForKey:@"car"];
  
    }
    
    return self;
}

@end
