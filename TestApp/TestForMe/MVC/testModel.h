//
//  testModel.h
//  TestForMe
//
//  Created by Dance on 2017/5/15.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^testBlock)(void);
@interface testModel : NSObject
{
    testBlock _testBlock;
}
@property (nonatomic ,copy)NSString *name;

@end
