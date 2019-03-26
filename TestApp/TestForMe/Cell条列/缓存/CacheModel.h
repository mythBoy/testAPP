//
//  CacheModel.h
//  TestForMe
//
//  Created by Music on 2017/12/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheModel : NSObject

@property (nonatomic, copy) NSString *thum; // 头像 thum
@property (nonatomic, copy) NSString *merchant_name; // 昵称 merchant_name
@property (nonatomic, copy) NSString *address; // 内容 address
@property (nonatomic, copy) NSString *thumb; // 配图  thumb
@property (nonatomic, assign) BOOL vip;

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
//@property (nonatomic, strong) NJWeibo *weibo;
+(id)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
