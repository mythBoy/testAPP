//
//  CacheModel.m
//  TestForMe
//
//  Created by Music on 2017/12/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "CacheModel.h"
#import "MJExtension.h"
#define NJNameFont [UIFont systemFontOfSize:15]
#define NJTextFont [UIFont systemFontOfSize:16]

@implementation CacheModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        /*
         @property (nonatomic, copy) NSString *thum; // 头像 thum
         @property (nonatomic, copy) NSString *merchant_name; // 昵称 merchant_name
         @property (nonatomic, copy) NSString *address; // 内容 address
         @property (nonatomic, copy) NSString *thumb; // 配图  thumb
         */
//       [self setValuesForKeysWithDictionary:dict];
//        [self class] ob;
        // 间隙
        CGFloat padding = 10;
        
        // 设置头像的frame
        CGFloat iconViewX = padding;
        CGFloat iconViewY = padding;
        CGFloat iconViewW = 30;
        CGFloat iconViewH = 30;
        self.iconF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
        
        
        // 设置昵称的frame
        // 昵称的x = 头像最大的x + 间隙
        CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + padding;
        // 计算文字的宽高
        CGSize nameSize = [self sizeWithString:self.thum font:NJNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        CGFloat nameLabelH = nameSize.height;
        CGFloat nameLabelW = nameSize.width;
        CGFloat nameLabelY = iconViewY + (iconViewH - nameLabelH) * 0.5;
        self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
        
//        // 设置vip的frame
//        CGFloat vipViewX = CGRectGetMaxX(self.nameF) + padding;
//        CGFloat vipViewY = nameLabelY;
//        CGFloat vipViewW = 14;
//        CGFloat vipViewH = 14;
//        self.vipF = CGRectMake(vipViewX, vipViewY, vipViewW, vipViewH);
        
        // 设置正文的frame
        CGFloat introLabelX = iconViewX;
        CGFloat introLabelY = CGRectGetMaxY(self.iconF) + padding;
        CGSize textSize =  [self sizeWithString:self.address font:NJTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
        
        CGFloat introLabelW = textSize.width;
        CGFloat introLabelH = textSize.height;
        
        self.introF = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
        
        // 设置配图的frame
//        CGFloat cellHeight = 0;
        if (self.thumb) {// 有配图
            CGFloat pictureViewX = iconViewX;
            CGFloat pictureViewY = CGRectGetMaxY(self.introF) + padding;
            CGFloat pictureViewW = 100;
            CGFloat pictureViewH = 100;
            self.pictrueF = CGRectMake(pictureViewX, pictureViewY, pictureViewW, pictureViewH);
            
            // 计算行高
            self.cellHeight = CGRectGetMaxY(self.pictrueF) + padding;
        }else
        {
            // 没有配图情况下的行高
            self.cellHeight = CGRectGetMaxY(self.introF) + padding;
        }
        
    }
    return self;
}

+(id)initWithDict:(NSDictionary *)dict
{
    
  return  [[self alloc]  initWithDict:dict ];
    
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
