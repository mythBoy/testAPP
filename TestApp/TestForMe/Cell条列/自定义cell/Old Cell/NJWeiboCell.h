//
//  NJWeiboCell.h
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NJWeiboFrame;

@interface NJWeiboCell : UITableViewCell
/**
 *  接收外界传入的模型
 */
//@property (nonatomic, strong) NJWeibo *weibo;

@property (nonatomic, strong) NJWeiboFrame *weiboFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
