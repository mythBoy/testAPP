//
//  NSString+Category.m
//  自己的扩张类
//
//  Created by mac iko on 12-10-24.
//  Copyright (c) 2012年 mac iko. All rights reserved.
//

#import "NSString+Category.h"
#import "NSMutableString+Category.h"
#import "NSData+Category.h"
@implementation NSString (Category)

-(BOOL)CheckUsernameInput:(NSString *)_text
{
    NSString *Regex = @"^\\w{2,16}{1}quot";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

-(BOOL)CheckPhonenumberInput:(NSString *)_text{
    NSString *Regex = @"1\\d{10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

-(BOOL)CheckMailInput:(NSString *)_text{
    NSString *Regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

-(BOOL)CheckPasswordInput:(NSString *)_text{
    NSString *Regex = @"\\w{6,16}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [emailTest evaluateWithObject:_text];
}

-(BOOL)isLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

-(BOOL)isNumbers:(NSString *)_text{
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}

-(BOOL)isNumberOrLetters:(NSString *)_text{
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:_text];
}


+(NSString *)stringWithUTF8Data:(NSData *)data{
    return [self stringWithData:data encoding:NSUTF8StringEncoding];
}

+(NSString *)stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding{
    return [[NSString alloc] initWithData:data encoding:encoding];
}

+(NSString *)stringWithUUID{
    CFUUIDRef UUIDObject = CFUUIDCreate(NULL);
    NSString *UUIDString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, UUIDObject));
    CFRelease(UUIDObject);
    return UUIDString;
}

+(NSString *)randStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

+(NSString *)randAlphanumericStringWithLength:(NSUInteger)length{
    if (length <= 0) {
        return @"";
    }
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0U; i < length; i++) {
        [string appendFormat:@"%c",[letters characterAtIndex:arc4random() % [letters length]]];
    }
    return [NSString stringWithString:string];
}

-(NSURL *)URL{
    return [NSURL URLWithString:self];
}

-(NSString *)URLEncodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, ((CFStringRef)self), NULL, CFSTR("!*'();:@&=+$,/?%#[]<>"), kCFStringEncodingUTF8));
    return result;
}

-(NSString *)URLDecodedString{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));
    return result;
}

-(NSString *)stringByAddingQueryDictionary:(NSDictionary *)dictionary{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp addQueryDictionary:dictionary];
    return [NSString stringWithString:tmp];
}

-(NSString *)stringByAppendingParameter:(id)parametet forKey:(NSString *)key{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp appendParameter:parametet forKey:key];
    return [NSString stringWithString:tmp];
}

-(CGFloat)widthWithFont:(UIFont *)font{
    CGSize size = [self sizeWithFont:font];
    return size.width;
}



-(BOOL)containsString:(NSString *)string{
    return [self containsString:string ignoringCase:YES];
}

-(BOOL)containsString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    
    NSRange range = [self rangeOfString:string options:options];
    return (range.location != NSNotFound);
}

-(BOOL)equalsToString:(NSString *)string{
    return [self equalsToString:string ignoringCase:YES];
}

-(BOOL)equalsToString:(NSString *)string ignoringCase:(BOOL)ignore{
    NSStringCompareOptions options = NSLiteralSearch;
    if (ignore) {
        options = NSCaseInsensitiveSearch;
    }
    return (NSOrderedSame == [self compare:string options:options]);
}

-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString{
    return [self stringByReplacingString:string withString:newString ignoringCase:NO];
}

-(NSString *)stringByReplacingString:(NSString *)string withString:(NSString *)newString ignoringCase:(BOOL)ignore{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp replaceString:string withString:newString ignoringCase:ignore];
    return [NSString stringWithString:tmp];
}

-(NSString *)stringByRemovingWhitespace{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespace];
    return [NSString stringWithString:tmp];
}

- (NSString *)stringByRemovingNewLine{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeNewLine];
    return [NSString stringWithString:tmp];
}
-(NSString *)stringByRemovingWhitespaceAndNewLine{
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespaceAndNewline];
    return [NSString stringWithString:tmp];
}

- (NSString*)stringByRemoveingAllWhitespageAndNewLing {
    NSMutableString *tmp = [NSMutableString stringWithString:self];
    [tmp removeWhitespaceAndNewline];
    return [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (NSString*)subStringToBytesLenght:(int)lenght{
    float number = 0.0;
    NSMutableString *resultString = [NSMutableString string];
    for (int index = 0; index < [self length]; index++) {
        
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number+0.5;
        }
        if (number <= lenght) {
            [resultString appendString:character];
        } else {
            break;
        }
    }
    return resultString;
}
-(NSInteger)lengthOfStringBytes
{
    float number = 0.0;
    for (int index = 0; index < [self length]; index++) {
        
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number+0.5;
        }
    }
    return ceil(number);
}
#pragma mark - Hash

- (NSString *)MD5HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] MD5HashString];
}

- (NSString *)SHA1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] SHA1HashString];
}
//- (NSString*)otherImageDownloadPath {
//    return [[[DXTUtils otherImagePath] stringByAppendingPathComponent:self.SHA1HashString] stringByAppendingPathExtension:@"jpg"];
//}

- (BOOL)isEmailAddress {
	if([self length] <= 0)
		return NO;
    NSString *regularExpression =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    return [predicate evaluateWithObject:[self lowercaseString]];
}

- (BOOL)isLetters{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumbers{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberOrLetters{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

+ (NSString *)stringWithSubstrings:(NSArray *)substrings separatesBy:(NSString *)separator
{
    if (substrings.count == 0) return @"";
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    [substrings enumerateObjectsUsingBlock:^(NSString *sub, NSUInteger idx, BOOL *stop) {
        [mutableString appendFormat:@"%@%@", sub, separator];
    }];
    
    NSRange range;
    range.length = separator.length, range.location = mutableString.length - separator.length;
    if (range.length) {
        [mutableString deleteCharactersInRange:range];
    }
    
    return mutableString.copy;
}

/**
 *  格式化每三位带逗号的数据
 *  @param string 余额数据字符串
 *  @return 带逗号余额
 */
+ (NSString *)balanceFormatFromStr:(NSString*)string
{
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumberFormatter *numFormatter2 = [[NSNumberFormatter alloc] init];
    [numFormatter2 setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *num = [numFormatter2 numberFromString:string];
    NSString *tempStr = [numFormatter stringFromNumber:num];
    NSString *balanceStr = [tempStr substringFromIndex:1];
    if ([tempStr hasPrefix:@"-"]) {
        balanceStr = [NSString stringWithFormat:@"-%@",[tempStr substringFromIndex:2]];
    }
    return balanceStr;
    
}
//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
//检车电话号码
+ (BOOL)checkTel:(NSString *)str{
    NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    
    if (!isMatch ||[str length]==0) {
        return NO;
        
    }
    return YES;
    
}
+(NSString *)reviseString:(NSString *)str
{
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [str doubleValue];//转double
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];//转字符串
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];//转number
    return [decNumber stringValue];//转字符串
    
}
//时间戳 转 NSDate
+ (NSDate *)receiveDateByTimeStamp:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    return date;
}
//时间戳 转 NSDate字符串
+ (NSString *)receiveDateStrByTimeStamp:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
    
}

+ (NSString *)checkNetArdess:(NSString *)urlStr
{

    if ([urlStr isKindOfClass:[NSString class]] && ![urlStr hasPrefix:@"http"]) {
        
        return   [NSString stringWithFormat:@"http:%@",urlStr];
        
    }else{
        
        return urlStr;
    }
    
}
//给手机号加****
+ (NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght

{
     NSString *newStr = originalStr;
    //判断当前字符串是否为空   是否为手机号类型
    if(originalStr.length == 0 || [NSString checkTel:originalStr] == NO ){
        
        return newStr;
    }
   
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
    
}

#pragma 检测身份证号
+ (BOOL)checkUserIdCard: (NSString *) idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
@end

