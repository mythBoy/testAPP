//
//  anyViewController.m
//  TestForMe
//
//  Created by Dance on 2017/4/28.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "anyViewController.h"
//

typedef  struct {//结构体类型
    unsigned int DelegateSuccess :1;//位段 表示 取值为1，0 适合存放bool
    unsigned int DelegateField :1;
}DelegateType;//这里是变量名称
//
//typedef struct DelegateFlag DELEGATEFLAG;//这是重新命名
@interface anyViewController ()
@property (nonatomic ,assign)DelegateType type;

@end

@implementation anyViewController
{
    struct{
        unsigned int delegateTypeOne :1;
        unsigned int delegateTypeTwo :1;
    }_delegateType;
    
}
- (void)loadView
{
    self.view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    [self.view  setBackgroundColor: [UIColor blueColor]];
////    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
////    v.image = [UIImage imageNamed:@"Default"];
//    self.view = v;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[super class]);
    NSLog(@"%@",self.superclass);
    self.view.backgroundColor = [UIColor brownColor];
    
    _myblock = ^{
        NSLog(@"my block");
    };
    
    
    
    _assignBlock = ^{
        NSLog(@"_assignBlock");
    };
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.myblock(@"myblock");
    
    self.assignBlock();
}
- (void)viewDidLayoutSubviews
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//频繁调用时候缓存 委托者是否实现该方法  112页   备注：代理调用频繁时候可以如下处理 例如刷新省
- (void)setDelegate:(id<anyViewControllerDelegate>)delegate
{
    _delegate = delegate;
    _type.DelegateSuccess = [_delegate respondsToSelector:@selector(anyViewPass:andSuccess:)];
    _type.DelegateField = [_delegate respondsToSelector:@selector(anyViewPass:andField:)];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_type.DelegateSuccess) {
        [_delegate anyViewPass:self andSuccess:event.type];
    }
    else if(_type.DelegateField){
        [_delegate anyViewPass:self andField:event.type];
    }
//    [_delegate anyViewPass:self andType:event.type];

    
    [self.navigationController popViewControllerAnimated:YES];
}

@end


/******************************************/
@interface categoryController ()
@property (nonatomic )NSString *dynamicStr;
@property (nonatomic )NSString *synthesizeStr;

@end

@implementation categoryController

{
    NSString *asd;
}

@dynamic dynamicStr;                           //告诉编译器 禁止实现该属性的 getter，setter方法，同时成员变量也不会创建。
@synthesize synthesizeStr = synthesizeStr;     //合成器语法 自动合成getter，setter方法，同时设置成员变量 synthesizeStr
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dynamic
    self.testStr = @"123";
    NSLog(@"self.testStr==%@",self.testStr);
    
    //synthesize
    synthesizeStr = @"100";
    NSLog(@"self.synthesizeStr==%@",self.synthesizeStr);
    
    self.synthesizeStr = @"200";
    NSLog(@"synthesizeStr===%@",synthesizeStr);
}

- (void)setTestStr:(NSString *)testStr
{
    asd = testStr;
}
- (NSString *)testStr
{
    return asd;
}

@end





