//
//  CacheCell.m
//  TestForMe
//
//  Created by Music on 2017/12/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "CacheCell.h"
#import "UIImageView+WebCache.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]


@interface CacheCell()
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

@implementation CacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        // 1.创建头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 2.创建昵称
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = NJNameFont;
        // nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 3.创建vip
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.image = [UIImage imageNamed:@"vip"];
        [self.contentView addSubview:vipView];
        self.vipView = vipView;
        
        // 4.创建正文
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.font = NJTextFont;
        introLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        
        // 5.创建配图
        UIImageView *pictureView = [[UIImageView alloc] init];
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
        
    }
    return self;
}
-(void)setModel:(CacheModel *)model
{
    
       NSString *urlicon  = model.thum ?[testUtil isHttpNewProJ: model.thum] : @"";
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlicon] placeholderImage:[UIImage imageNamed:@"timg.jpeg"]];
    
    // 设置昵称
    
    self.nameLabel.text = model.merchant_name;
    // 设置vip
    if (model.vip) {
        self.vipView.hidden = NO;
        self.nameLabel.textColor = [UIColor redColor];
    }else
    {
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    // 设置内容
    self.introLabel.text = model.address;
    
    // 设置配图
    if (model.thumb) {// 有配图
        //  self.pictureView.image = [UIImage imageNamed:weibo.picture];
         NSString *urlpic  =  model.thumb ?[testUtil isHttpNewProJ: model.thumb] : @"";
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:urlpic] placeholderImage:[UIImage imageNamed:@"timg.jpeg"]];
        self.pictureView.hidden = NO;
    }else
    {
        self.pictureView.hidden = YES;
    }
    
//frame
    // 间隙
    CGFloat padding = 10;
    
    // 设置头像的frame
    CGFloat iconViewX = padding;
    CGFloat iconViewY = padding;
    CGFloat iconViewW = 30;
    CGFloat iconViewH = 30;
    self.iconView.frame = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    // 设置昵称的frame
    // 昵称的x = 头像最大的x + 间隙
    CGFloat nameLabelX = CGRectGetMaxX(self.iconView.frame) + padding;
    // 计算文字的宽高
    CGSize nameSize = [self sizeWithString:model.merchant_name font:NJNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    CGFloat nameLabelH = nameSize.height;
    CGFloat nameLabelW = nameSize.width;
    CGFloat nameLabelY = iconViewY + (iconViewH - nameLabelH) * 0.5;
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
//    // 设置vip的frame
//    CGFloat vipViewX = CGRectGetMaxX(self.nameF) + padding;
//    CGFloat vipViewY = nameLabelY;
//    CGFloat vipViewW = 14;
//    CGFloat vipViewH = 14;
//    self.vipF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
    
    // 设置正文的frame
    CGFloat introLabelX = iconViewX;
    CGFloat introLabelY = CGRectGetMaxY(self.nameLabel.frame) + padding;
    CGSize textSize =  [self sizeWithString:model.address font:NJTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
    
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;
    
    self.introLabel.frame = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
    
    // 设置配图的frame
    CGFloat cellHeight = 0;
    if (model.thumb) {// 有配图
        CGFloat pictureViewX = iconViewX;
        CGFloat pictureViewY = CGRectGetMaxY(self.introLabel.frame) + padding;
        CGFloat pictureViewW = 100;
        CGFloat pictureViewH = 100;
        self.pictureView.frame = CGRectMake(pictureViewX, pictureViewY, pictureViewW, pictureViewH);
        
        // 计算行高
        self.cellHeight = CGRectGetMaxY(self.pictureView.frame) + padding;
    }else
    {
        // 没有配图情况下的行高
        self.cellHeight = CGRectGetMaxY(self.introLabel.frame) + padding;
    }
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
