//
//  Person.m
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "Person.h"

@implementation Person
//-(void)setCar:(Car *)car
//{
//    if (_car != car) {
//        [_car release];
//         _car = [car retain];
//    }
////    [[NSRunLoop currentRunLoop]  addPort:nil forMode:];
//}


- (void)dealloc
{
    NSLog(@"person dealloc name=%@",self.name);
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
 
//    NSLog(@"%@",self.car);
    [aCoder encodeObject:self.car forKey:@"car"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.height forKey:@"height"];
   
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.car = [aDecoder decodeObjectForKey:@"car"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
    }
    
    return self;
}

@end
