//
//  ThreadSafetyArray.m
//  IMClient
//
//  Created by yy on 16/9/6.
//  Copyright © 2016年 pengjay.cn@gmail.com. All rights reserved.
//

#import "ThreadSafetyArray.h"

@implementation ThreadSafetyArray
- (id)init {
    self = [super init];
    if (self) {
        _array = [[NSMutableArray alloc] init];
        NSArray *arr  = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThreadSafetyArray"];
        if (arr) {
            _array = [arr mutableCopy];
            _totalArray = [arr mutableCopy];
            _index = 0;
        }else{
            _totalArray = [NSMutableArray array];
        }
        
    }
    return self;
}

- (void)addObject:(NSObject*)obj {
    @synchronized(self) {
        [_array addObject:obj];
        NSLog(@"ThreadSafetyArray>>>>>>>>>>>>%d",_index++);
        [_totalArray addObject:obj];
        [[NSUserDefaults standardUserDefaults] setObject:_totalArray forKey:@"ThreadSafetyArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];

//        NSLog(@">>>>>>>>>>>>%d",_index++);
//        [_totalArray addObject:obj];
        if (_totalArray.count>500) {
            NSMutableArray *tempArr = [NSMutableArray array];
            for (int i = _totalArray.count-1; i>200; i--) {
                [tempArr addObject:_totalArray[i]];
            }
            _totalArray = [tempArr mutableCopy];
            [[NSUserDefaults standardUserDefaults] setObject:_totalArray forKey:@"ThreadSafetyArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }
    }
}

- (void)walk:(void (^)(NSObject*))walkfun {
    @synchronized(self) {
        for (NSObject* obj in _array) {
//            walkfun(obj);
        }
    }
}
- (void)delObjict:(NSObject*)obj {
    @synchronized(self) {
        [_array removeObject:obj];
//        [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"ThreadSafetyArray"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (BOOL)hasObject:(NSObject*)obj {
    @synchronized (self) {
        
        BOOL isHas = [_totalArray containsObject:obj];
        if (isHas) {
            NSLog(@"重复消息msg_id = %@",obj);
        }
        
        return  isHas;
    }
}

-(int)count
{
    return _array.count;
}

@end
