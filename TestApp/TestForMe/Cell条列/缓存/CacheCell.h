//
//  CacheCell.h
//  TestForMe
//
//  Created by Music on 2017/12/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CacheModel.h"
@interface CacheCell : UITableViewCell
@property (nonatomic ,strong)CacheModel *model;
@property (nonatomic, assign) CGFloat cellHeight;
@end
