//
//  messageDelManager.h
//  YuYu
//
//  Created by yy on 16/9/6.
//  Copyright © 2016年 mac iko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadSafetyArray.h"
#import "WebBaseHandler.h"
#import "UIHelper.h"

@interface messageDelManager : NSObject
{
    NSTimer *_durationTimer;
    WebBaseHandler  *_webBaseHandler;

    
}

@property(nonatomic,strong) ThreadSafetyArray *msgIdArray;
@property(nonatomic,strong) NSMutableArray *tempMsgIdArray;
@property(nonatomic)    BOOL istest;


+ (messageDelManager *)sharedManager;

-(void)DurationUpload;


@end



