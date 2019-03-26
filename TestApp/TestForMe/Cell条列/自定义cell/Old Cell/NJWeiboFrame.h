//
//  NJWeiboFrame.h
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

//  专门用来保存每一行数据的frame, 计算frame

#import <Foundation/Foundation.h>
@class NJWeibo;
@interface NJWeiboFrame : NSObject
/**
 *  头像的frame
 */
@property (nonatomic, assign) CGRect iconF;
/**
 *  昵称的frame
 */
@property (nonatomic, assign) CGRect nameF;
/**
 *  vip的frame
 */
@property (nonatomic, assign) CGRect vipF;
/**
 *  正文的frame
 */
@property (nonatomic, assign) CGRect introF;
/**
 *  配图的frame
 */
@property (nonatomic, assign) CGRect pictrueF;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 *  模型数据
 */
@property (nonatomic, strong) NJWeibo *weibo;

@end
