//
//  anyViewController.h
//  TestForMe
//
//  Created by Dance on 2017/4/28.
//  Copyright © 2017年 Dance. All rights reserved.
//


// 关于协议分类 演练
#import "BaseViewController.h"
@class anyViewController;
@protocol anyViewControllerDelegate<NSObject>
@optional
- (void)anyViewPass:(anyViewController *)vc andType:(UIEventType )type;
- (void)anyViewPass:(anyViewController *)vc andSuccess:(UIEventType )type;
- (void)anyViewPass:(anyViewController *)vc andField:(UIEventType )type;
@end

@interface anyViewController : BaseViewController
@property (nonatomic ,weak)id<anyViewControllerDelegate>delegate;
@property (nonatomic ,copy)void(^myblock)();
@property (nonatomic ,strong)void(^myblock1)();
@property (nonatomic ,assign)void(^assignBlock)();
@end


//分类
#import "BaseViewController.h"
@interface categoryController:BaseViewController

@end
