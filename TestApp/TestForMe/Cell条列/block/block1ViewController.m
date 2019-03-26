//
//  block1ViewController.m
//  TestForMe
//
//  Created by Music on 2017/7/20.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "block1ViewController.h"
#import "block2ViewController.h"
#define kDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kCachesPath    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
typedef enum
{
    SaveTypeForNone = 0,
    SaveTypeForAllSave,
    SaveTypeForCover,
    
    
} SaveType;
@interface block1ViewController ()
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,assign) SaveType saveType;
@end

@implementation block1ViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//     self.navigationController.navigationBarHidden = YES;
////    self.navigationController.navigationBarHidden = NO;
//}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//     self.navigationController.navigationBarHidden = NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"block1";
    
//    NSString *a = @"";
//    NSLog(@"%d",[a isKindOfClass:[NSNull class]] );
//     NSLog(@"%d",[a isMemberOfClass:[NSNull class]] );
//    
//    NSDictionary *abcd = @{
//                          @"a":[NSString stringWithFormat:@"%@",a]
//                          };
//    NSDictionary *abc = @{
//                          @"a":a
//                          };
//   
//    NSLog(@"%@\n%@",abcd,abc);
//    NSMutableArray *array = @[@"1",@"2",@"3"].mutableCopy;
//    [array removeObject:@"1"];
//    
//    
//    NSMutableArray *array1 = @[@"11",@"22",@"33"].mutableCopy;
//    array = array1;
//    NSLog(@"%@",array);
//    
    
//    2017-08-04 15:29:01.800286 YuYu[2592:746546] 0 接受的长度为 32768
//    2017-08-04 15:29:01.800471 YuYu[2592:746546] 0 接受的总长度为 163488
//    2017-08-04 15:29:01.800538 YuYu[2592:746546] 0 的文件总长度为 467363
//    2017-08-04 15:29:01.800646 YuYu[2592:746546] 0 的进度为 35.0
//    2017-08-04 15:29:01.800717 YuYu[2592:746546] 后台任务仍在进行中
//    2017-08-04 15:29:01.800826 YuYu[2592:746546] =====>>>model.progress进度===0=
    
//    unsigned long long receiveDataSize = 467363;
//    unsigned long long total = 467363;
//    NSString *progress = [NSString stringWithFormat:@"%f",receiveDataSize*1.0/total*1.0];
//    
//    NSLog(@"===%@",progress);
//    NSLog(@"=====>>>model.progress ===%d=",[progress intValue]);
//    NSMutableArray* array = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        CGFloat num = arc4random() % 100 + 1;
//        [array addObject:[NSNumber numberWithFloat:num]];
//    }
//    NSLog(@"%@",array);
//    CGFloat maxValue = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat minValue = [[array valueForKeyPath:@"@min.floatValue"] floatValue];
//    NSLog(@"maxValue= %f",maxValue);
//    NSLog(@"minValue= %f",maxValue);
////    重点在这句话上
////    @”@max.floatValue”（获取最大值），
////    @”@min.floatValue”（获取最小值），
////    @”@avg.floatValue” (获取平均值)，
////    @”@count.floatValue”(获取数组大小) 
////    等等。。。。
    
}
- (void)clickBtn:(UIButton *)btn
{
   
    switch (btn.tag) {
        case 0:
        {
        
        
            [self createDir];//穿件文件夹
        }
            break;
        case 1:
        {
         
            [self writeFile];//写文件
        }
            break;
        case 2:
        {
         
            [self readFile];//读文件
            
        }
            break;
        case 3:
        {
         
            [self fileAttriutes];//属性
        }
            break;
        case 4:
        {
            
            [self deleteFile];//删除文件
        }
            break;
        case 5:
        {
            
            [self createFile];//创建文件夹
        }
            break;
        case 6:
        {
            
            [self moveFile];//移动
        }
            break;
        case 7:
        {
            
            [self copyFile];////  复制
        }
            break;
        case 8:
        {
            
            [self deletFile];////  删除
        }
            break;
        case 9:
        {
            
            [self isExistFile];//// 存在
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    block2ViewController *block = [[block2ViewController alloc] init];
    block.testBlock = self.testBlock;
    [self.navigationController pushViewController:block animated:YES];
}

//按升序排列数组
-(void)test
{
    NSString *path = NSHomeDirectory();//主目录
    NSLog(@"NSHomeDirectory:%@",path);//到应用级别（application 下的应用）
    
    
    NSString *userName = NSUserName();//与上面相同
    NSString *rootPath = NSHomeDirectoryForUser(userName);
    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);//到应用级别（application 下的应用）
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    
}
//获取Documents目录
-(NSString *)dirDoc{
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"app_home_doc: %@",documentsDirectory);
    return documentsDirectory;
}
//创建文件夹
-(void )createDir{
    // /Users/music/Library/Developer/CoreSimulator/Devices/40F1B42E-5892-4EA8-B233-4B6B5E5A02F7/data/Containers/Data/Application/9E584EF6-3B89-4762-A918-DBEBF397DA99/Documents/
    //  拼接路径
    NSString *filePath = [kDocumentsPath stringByAppendingPathComponent:@"pp"];
    NSLog(@"%@",filePath);
    //  获取 操作文件对象
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    //  withIntermediateDirectories
    //  YES 如果不存在 创建 可以覆盖 反之 不可以覆盖(创建失败)
    BOOL isCreateFile = [fileManger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //    NSLog(@"%d",isCreateFile);
    if (isCreateFile) {
        NSLog(@"创建成功--%d",isCreateFile);
    }else{
        NSLog(@"创建失败--%d",isCreateFile);
    }
    //document -下创建download文件夹   创建路径为filepath的文件夹 download

//    NSString *documentsPath =[self dirDoc];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
//    // 创建目录
//    BOOL res=[fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
//    if (res) {
//        NSLog(@"文件夹创建成功");
//    }else{
//        NSLog(@"文件夹创建失败");
//    }
}

//读文件
-(void)readFile{
//    NSString *documentsPath =[self dirDoc];
//    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
//    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
//    //    NSData *data = [NSData dataWithContentsOfFile:testPath];
//    //    NSLog(@"文件读取成功: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    NSString *content=[NSString stringWithContentsOfFile:testPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"文件读取成功: %@",content);
    NSString *new = [kDocumentsPath stringByAppendingPathComponent:@"pp"];
    //    NSString *testPath = [kCachesPath stringByAppendingPathComponent:@"Download.txt"];
    NSString *testPath = [new stringByAppendingPathComponent:@"xxoo.txt"];
    //    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    NSString *content=@"测试写入内容！";
    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        NSLog(@"文件写入成功");
    }else
        NSLog(@"文件写入失败");
}


//文件属性
-(void)fileAttriutes{
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:testPath error:nil];
    NSArray *keys;
    id key, value;
    keys = [fileAttributes allKeys];
    NSUInteger count = [keys count];
    for (int i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [fileAttributes objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
    }
}

//删除文件
-(void)deleteFile{
    //  拼接新路径
    NSString *new = [kDocumentsPath stringByAppendingPathComponent:@"pp"];
    NSString *testPath = [new stringByAppendingPathComponent:@"xxoo.txt"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    BOOL isDelete = [fileManger removeItemAtPath:testPath error:nil];
    //    NSLog(@"%d",isDelete);
    if (isDelete) {
        NSLog(@"删除成功--%d",isDelete);
    }else{
        NSLog(@"删除失败--%d",isDelete);
    }
    
//    NSString *documentsPath =[self dirDoc];
//    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
//    BOOL res=[fileManager removeItemAtPath:testPath error:nil];
//    if (res) {
//        NSLog(@"文件删除成功");
//    }else
//        NSLog(@"文件删除失败");
//    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:testPath]?@"YES":@"NO");
}

/***********/
//  创建文件
- (void)createFile
{
    
   // /Users/music/Library/Developer/CoreSimulator/Devices/40F1B42E-5892-4EA8-B233-4B6B5E5A02F7/data/Containers/Data/Application/9E584EF6-3B89-4762-A918-DBEBF397DA99/Documents/
    //  拼接路径
    NSString *filePath = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
    NSLog(@"%@",filePath);
    //  获取 操作文件对象
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    //  withIntermediateDirectories
    //  YES 如果不存在 创建 可以覆盖 反之 不可以覆盖(创建失败)
    BOOL isCreateFile = [fileManger createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
//    NSLog(@"%d",isCreateFile);
    if (isCreateFile) {
        NSLog(@"创建成功--%d",isCreateFile);
    }else{
        NSLog(@"创建失败--%d",isCreateFile);
    }
    //document -下创建download文件夹   创建路径为filepath的文件夹 download
}

//  移动
- (void)moveFile
{
    //  拼接老路径
    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
    //  拼接新路径
    NSString *new = [kCachesPath    stringByAppendingPathComponent:@"Download"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    //将 路径old的文件夹 移动到 路劲new下 , 即为 文件从 document 下移动到cache
    BOOL isMoved = [fileManger moveItemAtPath:old toPath:new error:nil];
//    NSLog(@"%d",isMoved);
    if (isMoved) {
        NSLog(@"移动成功--%d",isMoved);
    }else{
        NSLog(@"移动失败--%d",isMoved);
    }
    
}

//写文件
-(void)writeFile{
    //    NSString *documentsPath =[self dirDoc];
    //    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
     NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download"];
//    NSString *testPath = [kCachesPath stringByAppendingPathComponent:@"Download.txt"];
     NSString *testPath = [new stringByAppendingPathComponent:@"ppo.txt"];
//    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test.txt"];
    NSString *content=@"测试写入内容！";
    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (res) {
        NSLog(@"文件写入成功");
    }else
        NSLog(@"文件写入失败");
    
    //创建 路径为testpath的文件夹ppo.txt 创建看出在kDocumentsPath 的download 中
}

//  复制
- (void)copyFile
{
    //  拼接老路径
//    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"pp.txt"];
    //  拼接新路径
    NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download/ppo.txt"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSLog(@"%@",new);
    
    BOOL isCopy = [fileManger copyItemAtPath:new toPath:old error:nil];
//    NSLog(@"%d",isCopy);
    if (isCopy) {
        NSLog(@"拷贝成功--%d",isCopy);
    }else{
        NSLog(@"拷贝失败--%d",isCopy);
    }
    //将路径kCachesPath 中的download文件（内含ppo.txt文件）复制到路径old 下的pp文件中 ，拷贝后的文件名为 pp  ???拷贝时候， old文件不能已经存在？？
}
//  删除
- (void)deletFile
{
    //  拼接新路径
    NSString *new = [kCachesPath stringByAppendingPathComponent:@"Download"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    BOOL isDelete = [fileManger removeItemAtPath:new error:nil];
//    NSLog(@"%d",isDelete);
    if (isDelete) {
        NSLog(@"删除成功--%d",isDelete);
    }else{
        NSLog(@"删除失败--%d",isDelete);
    }
    
    
}
//  是否存在
- (void)isExistFile
{
    //  拼接老路径
    NSString *old = [kDocumentsPath stringByAppendingPathComponent:@"Download"];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManger fileExistsAtPath:old];
    if (isExist) {
        NSLog(@"文件存在--%d",isExist);
    }else{
        NSLog(@"文件不存在--%d",isExist);
    }
   
}
- (void)xc
{
    
    
}
@end
