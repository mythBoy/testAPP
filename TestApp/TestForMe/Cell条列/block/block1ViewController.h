//
//  block1ViewController.h
//  TestForMe
//
//  Created by Music on 2017/7/20.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^testPassBlock)(NSDictionary *,NSString *);
@interface block1ViewController : BaseViewController
@property (nonatomic ,copy)testPassBlock testBlock;
@end
