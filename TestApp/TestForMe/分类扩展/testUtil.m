//
//  testUtil.m
//  TestForMe
//
//  Created by Music on 2017/7/18.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "testUtil.h"
#define YYWebServicePHP                     @"https://admin.jrtoo.com"                              // 中国金融通
#define YYHongWebServiceCifcogroup                  YYWebServicePHP @"/"        // 图片加载路径，除了直播
@implementation testUtil
+ (NSString *)isHttpNewProJ:(NSString *)str
{
        NSLog(@"str*************=%@=",str);
//    NSString *url =str;
    //加判断防止崩溃   add by  gf
    if ([str isKindOfClass:[NSString class]]) {
        if([str hasPrefix:@"http://"]||[str hasPrefix:@"https://"]){
            return str;
        }else{
                  NSLog(@"urlurlurlurl%@%@",YYHongWebServiceCifcogroup,str);
            return [NSString stringWithFormat:@"%@%@",YYHongWebServiceCifcogroup,str];
            
        }
    }
    else
    {
        return @"";
    }
    //    return url;
}
@end
