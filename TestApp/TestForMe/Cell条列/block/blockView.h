//
//  blockView.h
//  TestForMe
//
//  Created by Music on 2018/4/10.
//  Copyright © 2018年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class blockView;
@protocol blockViewDelegate <NSObject>
//@optional
- (void)blockViewClickBtn:(UIButton *)btn;
@end

@interface blockView : UIView

@property (nonatomic ,weak)id <blockViewDelegate>delegate;
@end
