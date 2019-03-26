//
//  IMCoreUtil.h
//  IMClient
//
//  Created by pengjay on 13-8-29.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMCoreUtil : NSObject
+ (BOOL)objIsNULLorNSNull:(id)obj;
+ (NSString *)spaceStringIfNullOrNSNull:(NSString *)str;
+ (NSString *)isHttp:(NSString *)str;
@end
