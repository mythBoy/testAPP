//
//  messageDelManager.m
//  YuYu
//
//  Created by yy on 16/9/6.
//  Copyright © 2016年 mac iko. All rights reserved.
//

#import "messageDelManager.h"
#import "YYUserManager.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
//#import "NSXMLElement+XMPP.h"
//#import "XMPPIQ.h"
#import "AppDelegate.h"
@implementation messageDelManager


+ (messageDelManager *)sharedManager
{
    static messageDelManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        _istest = YES;
        _msgIdArray = [ ThreadSafetyArray new];
        _webBaseHandler=[[WebBaseHandler  alloc]init];
        _webBaseHandler.isApplication = YES;
        
        _tempMsgIdArray = [NSMutableArray array];
        [self startTimer];
        
//        NSTimeInterval period = 30.0; //设置时间间隔
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
//        dispatch_source_set_event_handler(_timer, ^{
//        //在这里执行事件
//            [self DurationUpload];
//        });
//        dispatch_resume(_timer);
    }
    return self;
}

-(NSString *)delChar:(NSString *)str
{
    NSMutableString *mutableStr = [str mutableCopy];
    
    NSString *subStr = @"\n ";
    
    NSRange range = [str rangeOfString:subStr];
    
    
    while (range.length>0) {
        [mutableStr deleteCharactersInRange:range];
         range = [mutableStr rangeOfString:subStr];

    }
    
     NSString *subStr2 = @"\n";
    NSRange range2 = [mutableStr rangeOfString:subStr2];
    if (range2.length>0) {
        [mutableStr deleteCharactersInRange:range2];

    }
    
//    NSString *subStr3 = @" ";
//    NSRange range3 = [mutableStr rangeOfString:subStr3];
//    
//    while (range3.length>0) {
//        [mutableStr deleteCharactersInRange:range3];
//        range3 = [mutableStr rangeOfString:subStr3];
//        
//    }
//
    


    
    return mutableStr;

}



-(void)DurationUpload
{
    if (self.msgIdArray.array.count == 0) {
        AppDelegate *app =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.imClient sendIQ:nil];

        return;
    }
    
    NSString *uid = [YYUserManager sharedObject].user.uid;
    NSString *msgid = [_msgIdArray.array JSONString];
    
//    NSString *arrStr = [_msgIdArray.array componentsJoinedByString:@","];
//    for (int i =0 ; i<_msgIdArray.array.count; i++) {
//        
//    }
    
    
   NSString *arrStr  = [self delChar:msgid];
    


    
    _tempMsgIdArray = [_msgIdArray.array mutableCopy];
    __weak typeof(self) wself = self;
    
//    if (_istest) {
//        
//        
//        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//        if (!keyWindow) {
//            keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
//        }
//        [self ShowTextPromptDelayHide:[NSString stringWithFormat:@"一共有%lu个信息,将要删除%lu个",(unsigned long)_msgIdArray.array.count,(unsigned long)_tempMsgIdArray.count] :2 :keyWindow ] ;
//    }
    
    
    [_webBaseHandler postWithWebServiceKey:yyIMMsgDelete postDic:@{@"imid":uid,@"msgid":arrStr} block:^(NSDictionary *retInfo, NSError *error) {
        
        
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (!keyWindow) {
            keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        }
        
        if ([[retInfo objectForKey:@"status"] boolValue]) {
            
            for (id  obj in wself.tempMsgIdArray) {
                [wself.msgIdArray delObjict:obj];
            }
            
            if (wself.istest) {
                NSLog(@"im-msg-delete已经删除%lu个，未删除%lu个",(unsigned long)wself.tempMsgIdArray.count,(unsigned long)wself.msgIdArray.array.count);
//                [self ShowTextPromptDelayHide:[NSString stringWithFormat:@"已经删除%lu个，未删除%lu个",(unsigned long)wself.tempMsgIdArray.count,(unsigned long)wself.msgIdArray.array.count] :2 :keyWindow ] ;
//                
            }

            AppDelegate *app =   (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.imClient sendIQ:nil];

            
        }else{
            if (wself.istest) {
                NSLog(@"im-msg-delete删除操作失败");

            }
            
        }
    }];
    
    
    
    
}

-(void)startTimer{
    if (!_durationTimer) {
        
        _durationTimer = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(DurationUpload) userInfo:nil repeats:YES];
         [[NSRunLoop mainRunLoop] addTimer:_durationTimer forMode:NSDefaultRunLoopMode];
        
//        _durationTimer =[ NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(DurationUpload) userInfo:nil repeats:YES];
//        [_durationTimer fire];
    }
}

-(void)stopTimer{
    if (_durationTimer) {
        if (_durationTimer.isValid) {
            [_durationTimer invalidate];
            _durationTimer = nil;
        }
    }
}
-(void)ShowTextPromptDelayHide:(NSString *)info  :(CGFloat) seconds :(UIView *)superView
{
    [MBProgressHUD hideAllHUDsForView:superView animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:NO];
    hud.userInteractionEnabled = NO;
    hud.detailsLabelText = info;
    //    hud.labelFont = [UIFont systemFontOfSize:12.0f];
    hud.yOffset = -50.0;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:seconds];
}

-(void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
