//
//  CacheFrame.h
//  TestForMe
//
//  Created by Music on 2017/12/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheModel.h"
@interface CacheFrame : NSObject
@property (nonatomic ,strong)CacheModel *model;
@property (nonatomic ,assign)CGFloat cellHeight;
@end
