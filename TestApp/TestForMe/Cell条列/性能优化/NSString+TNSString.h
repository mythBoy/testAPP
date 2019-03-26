//
//  NSString+TNSString.h
//  TestForMe
//
//  Created by Music on 2018/1/18.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TNSString)
+ (instancetype)stringWithFormat1:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
@end
