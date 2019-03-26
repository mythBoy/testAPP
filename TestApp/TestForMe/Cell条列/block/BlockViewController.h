//
//  BlockViewController.h
//  TestForMe
//
//  Created by Dance on 2017/7/5.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseViewController.h"


#define kcoco(uid)
typedef void (^testPassBlock)(NSDictionary *,NSString *);
@interface BlockViewController : BaseViewController
@property (nonatomic ,copy)testPassBlock testBlock;
@end
