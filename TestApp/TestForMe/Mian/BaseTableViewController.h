//
//  BaseTableViewController.h
//  TestForMe
//
//  Created by Dance on 2017/7/7.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseViewController.h"

//@class BaseTableViewController;
//@protocol baseTableViewDelegate <NSObject>
//
//- (void)baseTableViewController:(BaseTableViewController *)basetableView didSelectRowAtIndexPath:(NSIndexPath *)path andTitArrays:(NSArray *)titArrays;
//
//@end

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *titArrays;
//@property (nonatomic ,weak)id<baseTableViewDelegate>delegate;
@property (nonatomic ,copy)void(^didSelectRowAtIndexPathBlock)(NSIndexPath *,NSArray *);
- (void)baseTableViewController:(BaseTableViewController *)basetableView didSelectRowAtIndexPath:(NSIndexPath *)path andTitArrays:(NSArray *)titArrays;
@end
