//
//  BaseViewController.h
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic ,strong)UITableView *baseTableView;
@property (nonatomic ,assign)BOOL showTableView;
@property (nonatomic ,strong)NSArray *baseDataArray;
//@property (nonatomic ,copy)NSString *cusTitle;

@end
