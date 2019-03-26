//
//  AnyWayViewController.m
//  TestForMe
//
//  Created by Dance on 2017/4/12.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "AnyWayViewController.h"
#import "AppDelegate.h"
#import "XMLUtil.h"
#import "anyViewController.h"
#import "SFViewController.h"
#import "NCViewController.h"
#import "Person.h"
#import "DXCViewController.h"
#import "Man.h"
#import "NSArray+Test.h"
#import <objc/runtime.h>
#import "testModel.h"

@interface AnyWayViewController ()<NSXMLParserDelegate,anyViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic ,weak)id obj;
@property (nonatomic, strong) UIDatePicker          *datePick;
@property (nonatomic, strong) UIToolbar             *dateTooleBar;
@property (nonatomic, strong) UITextField           *ageField;//生日
@end

@implementation AnyWayViewController
{
    void *p;
//    testModel __weak*_p;
   
}


struct data {
  __unsafe_unretained  NSString *str;
}aa;

typedef struct data baba;


int func(int a);

typedef  int (^akl)(int);

typedef int (^blk)(int);


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatUI];
    
    
    
}

- (void)creatUI
{
    self.title = @"ANY控制器";
    self.view.backgroundColor = [UIColor lightGrayColor]; //button
    
    _datePick = [[UIDatePicker alloc]init];
    _datePick.backgroundColor =  [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1.0f];
    
    [_datePick setMaximumDate:[NSDate date]];
    _datePick.datePickerMode = UIDatePickerModeDate;
    
    //取消按钮
    UIBarButtonItem *dateCancelBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dateCancel)];


    UIBarButtonItem *datefFlexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:NULL];
    //确定按钮
    UIBarButtonItem *dateSureBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", nil) style:UIBarButtonItemStylePlain target:self action:@selector(dateSure)];


    
    self.dateTooleBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kScreenSize.height, kScreenSize.width, 40)];
    self.dateTooleBar.barStyle = UIBarStyleDefault;

    self.dateTooleBar.items = @[dateCancelBtn,datefFlexibleSpaceItem,dateSureBtn];
    
    self.ageField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    [self.ageField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    self.ageField.text = @"00";
    self.ageField.delegate = self;
    [self.view addSubview:self.ageField];
    self.ageField.inputView = _datePick;
    self.ageField.inputAccessoryView = self.dateTooleBar;
  
}
#pragma mark 日期转字符串
+ (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}


- (NSDate *)formatDateStr:(NSString *)dateStr
{
    //    NSString *dateStr = @"20140623195323"; // 1974-01-01 00:00:00 +0000
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //  将NSDate转换成指定格式的字符串
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dateStr]];
    NSLog(@"===>%@",date);
    return date;
}

//日期 确定按钮
-(void)dateSure
{
    [self.ageField resignFirstResponder];
    
//    NSDate *date = self.datePick.date;  // 1974-01-01 00:00:00 +0000
//    NSString *age = [[self class] formatDate:date];  //1974-01-01

//        self.ageField.text = [[[self class] formatDate:date] copy];

    
}
//日期取消 按钮
- (void)dateCancel
{
    [self.ageField resignFirstResponder];
}
#pragma  mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//  NSDate *date =  [self formatDateStr:nil] ;
//     NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
//    [self.datePick setDate:date animated:NO];
//    [self checkBirthdayFormat:textField.text];
    
}




//textfield编辑结束
- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
[self checkBirthdayFormat:textField.text];
    
}
//文字变化
- (void)textFieldDidChanged:(UITextField *)textField//昵称 地区 生日 手机号
{

    [self checkBirthdayFormat:textField.text];
}

- (BOOL)checkBirthdayFormat:(NSString *)birStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //  将NSDate转换成指定格式的字符串
    id date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",birStr]];
    NSLog(@"==当前文本输入日期为==>%@",date);
    if([date isKindOfClass:[NSDate class]]){
        NSLog(@"为日期格式");
        self.datePick.date = date;

    }else{
         NSLog(@"不是日期格式");
    }
    return date;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    categoryController *vc = [[categoryController alloc] init];
    anyViewController *vc = [[anyViewController alloc] init];
    vc.myblock = ^{
    
    };
    
    vc.assignBlock();
    [self.navigationController pushViewController:vc animated:YES];
}
@end

