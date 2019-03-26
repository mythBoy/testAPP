//
//  XMLUitil.h
//  TestForMe
//
//  Created by Dance on 2017/4/21.
//  Copyright © 2017年 Dance. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@interface XMLUitil : NSObject
//
//@end
#import <Foundation/Foundation.h>
#import "Person.h"
//声明代理
@interface XMLUtil : NSObject<NSXMLParserDelegate>
//添加属性
@property (nonatomic, strong) NSXMLParser *par;
@property (nonatomic, strong) Person *person;
//存放每个person
@property (nonatomic, strong) NSMutableArray *list;
//标记当前标签，以索引找到XML文件内容
@property (nonatomic, copy) NSString *currentElement;

//声明parse方法，通过它实现解析
-(void)parse;


@property NSString *str;
@end
