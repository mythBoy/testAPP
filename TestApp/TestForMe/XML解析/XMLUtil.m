//
//  XMLUitil.m
//  TestForMe
//
//  Created by Dance on 2017/4/21.
//  Copyright © 2017年 Dance. All rights reserved.
//

//#import "XMLUitil.h"
//
//@implementation XMLUitil
//
//@end
/////******///
//XMLUtil.h





//XMLUtil.m

#import "XMLUtil.h"

@implementation XMLUtil

- (instancetype)init{
    self = [super init];
    if (self) {
        //获取事先准备好的XML文件
        NSBundle *b = [NSBundle mainBundle];
        NSString *path = [b pathForResource:@"test" ofType:@".xml"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        self.par = [[NSXMLParser alloc]initWithData:data];
        //添加代理
        self.par.delegate = self;
        //初始化数组，存放解析后的数据
        self.list = [NSMutableArray arrayWithCapacity:5];
        
        
        
    }
    return self;
}

//几个代理方法的实现，是按逻辑上的顺序排列的，但实际调用过程中中间三个可能因为循环等问题乱掉顺序
//开始解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument...");
}
//准备节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    self.currentElement = elementName;
    
    if ([self.currentElement isEqualToString:@"student"]){
        self.person = [[Person alloc]init];
        
    }
    
}
//获取节点内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if ([self.currentElement isEqualToString:@"pid"]) {
        [self.person setPid:string];
    }else if ([self.currentElement isEqualToString:@"name"]){
        [self.person setName:string];
    }else if ([self.currentElement isEqualToString:@"sex"]){
        [self.person setSex:string];
    }else if ([self.currentElement isEqualToString:@"age"]){
        
        [self.person setAge:string];
    }
}

//解析完一个节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if ([elementName isEqualToString:@"student"]) {
        [self.list addObject:self.person];
    }
    self.currentElement = nil;
}

//解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidEndDocument...");
    NSLog(@"%@",self.person);
}

//外部调用接口
-(void)parse{
    [self.par parse];
    
}

@end
