//
//  block2ViewController.h
//  TestForMe
//
//  Created by Music on 2017/7/20.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^testPassBlock)(NSDictionary *,NSString *);
@interface block2ViewController : BaseViewController
@property (nonatomic ,copy)testPassBlock testBlock;
@end
