//
//  Category.m
//  TestForMe
//
//  Created by Dance on 2017/7/14.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "Category.h"

@implementation Category
- (id)objectOfNilAtIndex:(NSInteger)index
{
    if (index<[self count]) {
        return self[index];
    }
    return nil;

}
@end

