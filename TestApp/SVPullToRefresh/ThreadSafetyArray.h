//
//  ThreadSafetyArray.h
//  IMClient
//
//  Created by yy on 16/9/6.
//  Copyright © 2016年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreadSafetyArray : NSObject

@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong) NSMutableArray *totalArray;

@property int index;
- (void)addObject:(NSObject*)obj;
- (BOOL)hasObject:(NSObject*)obj;
- (void)delObjict:(NSObject*)obj;

- (void)walk:(void (^)(NSObject*))walkfun;

-(int)count;

@end
