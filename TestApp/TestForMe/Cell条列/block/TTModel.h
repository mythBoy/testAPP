//
//  TTModel.h
//  TestForMe
//
//  Created by Dance on 2017/3/10.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^testBlock)();
@interface TTModel : NSObject
@property (nonatomic ,copy)testBlock testBlock;
- (void)test;
@end
