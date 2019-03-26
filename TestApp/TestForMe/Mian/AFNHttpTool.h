//
//  AFNHttpTool.h
//  TestForMe
//
//  Created by Dance on 2017/3/10.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^success)(NSURLSessionDataTask * _Nonnull, id _Nullable);

@interface AFNHttpTool : NSObject
+ (void)GetWithUrl:(NSString *)urlStr paramers:(NSMutableDictionary *)paramers  success:(success)success;
@end
