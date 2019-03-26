//
//  NewWeiBoCell.h
//  TestForMe
//
//  Created by Music on 2018/3/12.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewWeiBo;

@interface NewWeiBoCell : UITableViewCell
@property (nonatomic, strong) NewWeiBo *weiboFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

