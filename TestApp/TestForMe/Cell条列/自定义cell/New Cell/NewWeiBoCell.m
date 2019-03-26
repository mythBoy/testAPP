//
//  NJWeiboCell.m
//  TestForMe
//
//  Created by Music on 2017/12/27.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "NewWeiBoCell.h"
//#import "NewWeiBo.h"
#import "UIImageView+WebCache.h"
 static NSString *abcdefg =@"红咔嚓雷cell";
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]

@interface  NewWeiBoCell()
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  vip
 */
@property (nonatomic, weak) UIImageView *vipView;
/**
 *  配图
 */
@property (nonatomic, weak) UIImageView *pictureView;
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *introLabel;
@end

@implementation NewWeiBoCell

//+ (instancetype)cellWithTableView:(UITableView *)tableView
//{
//    // NSLog(@"cellForRowAtIndexPath");
//    static NSString *identifier = @"status";
//    // 1.缓存中取
//    NewWeiBoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    // 2.创建
//    if (cell == nil) {
//        cell = [[NewWeiBoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    return cell;
//}
//
//
///**
// *  构造方法(在初始化对象的时候会调用)
// *  一般在这个方法中添加需要显示的子控件
// */
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
//        // 1.创建头像
//        UIImageView *iconView = [[UIImageView alloc] init];
//        [self.contentView addSubview:iconView];
//        self.iconView = iconView;
//        
//        // 2.创建昵称
//        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.font = NJNameFont;
//        // nameLabel.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:nameLabel];
//        self.nameLabel = nameLabel;
//        
//        // 3.创建vip
//        UIImageView *vipView = [[UIImageView alloc] init];
//        vipView.image = [UIImage imageNamed:@"vip"];
//        [self.contentView addSubview:vipView];
//        self.vipView = vipView;
//        
//        // 4.创建正文
//        UILabel *introLabel = [[UILabel alloc] init];
//        introLabel.font = NJTextFont;
//        introLabel.numberOfLines = 0;
//        // introLabel.backgroundColor = [UIColor greenColor];
//        [self.contentView addSubview:introLabel];
//        self.introLabel = introLabel;
//        
//        // 5.创建配图
//        UIImageView *pictureView = [[UIImageView alloc] init];
//        [self.contentView addSubview:pictureView];
//        self.pictureView = pictureView;
//        
//    }
//    return self;
//}
//
//
//- (void)setWeiboFrame:(NewWeiBo *)weiboFrame
//{
//    _weiboFrame = weiboFrame;
//    
//    // 1.给子控件赋值数据
//    [self settingData];
//    // 2.设置frame
//    [self settingFrame];
//}
//
//
///**
// *  设置子控件的数据
// */
//- (void)settingData
//{
//    
//    NewWeiBo *weibo = self.weiboFrame.weibo;
//
//    // 设置头像
//    //self.iconView.image = [UIImage imageNamed:weibo.icon];
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:weibo.icon] placeholderImage:[UIImage imageNamed:@"word"]];
//
//    // 设置昵称
//    self.nameLabel.text = weibo.name;
//    // 设置vip
//    if (weibo.vip) {
//        self.vipView.hidden = NO;
//        self.nameLabel.textColor = [UIColor redColor];
//    }else
//    {
//        self.vipView.hidden = YES;
//        self.nameLabel.textColor = [UIColor blackColor];
//    }
//    // 设置内容
//    self.introLabel.text = weibo.text;
//
//    // 设置配图1
//    if (weibo.picture) {// 有配图
//        //  self.pictureView.image = [UIImage imageNamed:weibo.picture];
//        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:weibo.picture] placeholderImage:[UIImage imageNamed:@"word"]];
//        self.pictureView.hidden = NO;
//    }else
//    {
//        self.pictureView.hidden = YES;
//    }
//}
///**
// *  设置子控件的frame
// */
//- (void)settingFrame
//{
//    
//    // 设置头像的frame
//    self.iconView.frame = self.weiboFrame.iconF;
//    
//    // 设置昵称的frame
//    self.nameLabel.frame = self.weiboFrame.nameF;
//    
//    // 设置vip的frame
//    self.vipView.frame = self.weiboFrame.vipF;
//    
//    // 设置正文的frame
//    self.introLabel.frame = self.weiboFrame.introF;
//    
//    // 设置配图的frame
//    
//    if (self.weiboFrame.weibo.picture) {// 有配图
//        self.pictureView.frame = self.weiboFrame.pictrueF;
//    }
//}
//
///**
// *  计算文本的宽高
// *
// *  @param str     需要计算的文本
// *  @param font    文本显示的字体
// *  @param maxSize 文本显示的范围
// *
// *  @return 文本占用的真实宽高
// */
//- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *dict = @{NSFontAttributeName : font};
//    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
//    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
//    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//    return size;
//}

@end

