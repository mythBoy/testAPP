//
//  NSString+Category.h
//  自己的扩张类
//
//  Created by mac iko on 12-10-24.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Category)



+ (NSString *)stringWithSubstrings:(NSArray *)substrings separatesBy:(NSString *)separator;

//判断用户名是否是2～16位；
-(BOOL)CheckUsernameInput:(NSString *)_text;
//判断手机号码，1开头的十一位数字
-(BOOL)CheckPhonenumberInput:(NSString *)_text;
//判断邮箱
-(BOOL)CheckMailInput:(NSString *)_text;
//判断密码，6－16位
-(BOOL)CheckPasswordInput:(NSString *)_text;
//判断是否字母构成
- (BOOL)isLetters:(NSString *)_text;
//判断是否是数字构成
- (BOOL)isNumbers:(NSString *)_text;
//判断是否是数字或字母构成
- (BOOL)isNumberOrLetters:(NSString *)_text;



//创建字符串
+ (NSString *)stringWithUTF8Data:(NSData *)data;
+ (NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding;

//生成唯一id
+ (NSString *)stringWithUUID;
//生成一个固定长度的随即字符串
+ (NSString *)randStringWithLength:(NSUInteger)length;
//生成一个固定长度不带数字的字符串
+ (NSString *)randAlphanumericStringWithLength:(NSUInteger)length;
//直接将string改为string
- (NSURL *)URL;
//将string编码
- (NSString *)URLEncodedString;
//将sring解码
- (NSString *)URLDecodedString;
//返回一个string包含一个dictionary中的所有条目
-(NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary;
//
-(NSString *)stringByAppendingParameter:(id)parametet forKey:(NSString *)key;
//返回string的宽度
- (CGFloat)widthWithFont:(UIFont *)font;
//判断是否存在子字符串
-(BOOL)containsString:(NSString *)string;
-(BOOL)containsString:(NSString *)string ignoringCase:(BOOL)ignore;
//判断是否和字符串相等
-(BOOL)equalsToString:(NSString *)string;
-(BOOL)equalsToString:(NSString *)string ignoringCase:(BOOL)ignore;
//替换掉字符串中的子字符串
-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString;
-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString ignoringCase:(BOOL)ignore;
//删除空格
-(NSString *)stringByRemovingWhitespace;
//删除空格和换行
-(NSString *)stringByRemovingWhitespaceAndNewLine;

//删除所有空格和换行
- (NSString*)stringByRemoveingAllWhitespageAndNewLing;

//删除所有换行
- (NSString *)stringByRemovingNewLine;
//返回给定长度的子字符串 （绝大部分非英汉字用UTF-8编码占用三个字节）算一个长度，不是汉字算半个长度
- (NSString*)subStringToBytesLenght:(int)lenght;
//返回指定字符串的长度 （绝大部分非英文汉字用UTF-8编码占用三个字节）算一个长度，不是汉字算半个长度
-(NSInteger)lengthOfStringBytes;
///-------------------------------
/// Hash
///-------------------------------
- (NSString *)MD5HashString;
- (NSString *)SHA1HashString;


//- (NSString*)otherImageDownloadPath;

- (BOOL)isEmailAddress;

- (BOOL)isLetters;

- (BOOL)isNumbers;

- (BOOL)isNumberOrLetters;
+ (NSString *)balanceFormatFromStr:(NSString*)string;


+ (BOOL)isValidateEmail:(NSString *)email;//判断邮箱
+ (BOOL)checkTel:(NSString *)str;//判断电话
+ (NSString *)reviseString:(NSString *)str;//    //直接传入精度丢失有问题的Double类型

/**
 时间戳 转 NSDate
 */
+ (NSDate *)receiveDateByTimeStamp:(NSString *)timeString;
/**
 时间戳 转 NSDate字符串
 */
+ (NSString *)receiveDateStrByTimeStamp:(NSString *)timeString;
/**
  判断url是否包含http
 */
+ (NSString *)checkNetArdess:(NSString *)urlStr;

/**
  给手机号加****  会判断是否为手机号类型
 */
+ (NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;
/**
   检测身份证号
 */
+ (BOOL)checkUserIdCard: (NSString *) idCard;
@end
