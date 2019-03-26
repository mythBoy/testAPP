//
//  SaveDataViewController.h
//  TestForMe
//
//  Created by Dance on 2017/4/18.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import "BaseViewController.h"
#import "bbbbViewController.h"
@class SaveDataViewController;
@protocol SaveDataViewControllerDelegate
- (void)SaveDataViewControllerdelegate;
@end

@interface SaveDataViewController : bbbbViewController
@property (nonatomic, strong)id <SaveDataViewControllerDelegate> delegate;
@end
