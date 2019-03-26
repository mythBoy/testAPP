//
//  CusView.h
//  TestForMe
//
//  Created by Dance on 2017/3/13.
//  Copyright © 2017年 Dance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CusView;
@protocol CusViewDelegate <NSObject>
@optional
-(void)pass:(int)tag;

@end
@interface CusView : UIView

@property (nonatomic ,weak)id<CusViewDelegate>delegate;
@end
