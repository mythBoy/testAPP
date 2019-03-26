//
//  IMMsgQueueManager.m
//  IMClient
//
//  Created by pengjay on 13-7-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMMsgQueueManager.h"
#import "DDLog.h"
#import "IMUserManager.h"


#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_OFF;
#endif

@implementation IMMsgQueueManager


- (id)initWithMsgStorage:(IMMsgStorage *)msgStorage
{
	self = [super init];
	if (self) {
		_cacheQueue = [[NSCache alloc]init];
		_cacheQueue.delegate = self;
		_cacheQueue.countLimit = 10;
		_msgStorage = msgStorage;
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)clearMemory
{
	[_cacheQueue removeAllObjects];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (IMMsgQueue *)openNormalMsgQueueWithUser:(IMUser *)fromUser delegate:(id<IMMsgQueueDelegate>)delegate
{
	if (fromUser == nil || delegate == nil)
		return nil;
	
	if ([_activeQueue.fromUser isEqual:fromUser]) {
		DDLogVerbose(@"get active:%@", fromUser);
		_activeQueue.delegate = delegate;
		return _activeQueue;
	}
	
	IMMsgQueue *msgQueue = [_cacheQueue objectForKey:fromUser.userID];
	if (!msgQueue) {
		DDLogCVerbose(@"create new msg queue:%@", fromUser.userID);
		msgQueue = [[IMMsgQueue alloc]initWithUser:fromUser msgStorage:_msgStorage queue:NULL
										audioMode:IMMsgQueueAudioModePrvChat groupFlag:YES];

		[_cacheQueue setObject:msgQueue forKey:fromUser.userID];
	}

	_activeQueue = msgQueue;
	_activeQueue.delegate = delegate;

	if (_globalQueue) {
		[_globalQueue stopAudioPlay];
	}
	
	return _activeQueue;
}
//add by 杨扬   后台删除敏感消息使用
-(IMMsgQueue *)getQueue:(NSString *)userID
{
//    	IMMsgQueue *msgQueue = [_cacheQueue objectForKey:userID];
    
    if ([_activeQueue.fromUser.userID isEqual:userID]) {
        return _activeQueue;
    }
    
    IMMsgQueue *msgQueue = [_cacheQueue objectForKey:userID];
    if (msgQueue) {
        
        //删掉userid的缓存后再从数据库中读取
        [_cacheQueue removeObjectForKey:userID];
    }
    

    return nil;
    
    
}


- (void)closeNormalMsgQueueWithUser:(IMUser *)fromUser
{
	if ([_activeQueue.fromUser isEqual:fromUser]) {
		[_activeQueue stopAudioPlay];
		_activeQueue.delegate = nil;
		_activeQueue = nil;
	}
}

- (IMMsgQueue *)openDiscussMsgQueueWithUser:(IMUser *)fromUser delegate:(id<IMMsgQueueDelegate>)delegate
{
	if (fromUser == nil || delegate == nil) {
		return nil;
	}
	if ([_globalQueue.fromUser isEqual:fromUser]) {
		_globalQueue.delegate = delegate;
		return _globalQueue;
	}
	
	_globalQueue	 = [[IMMsgQueue alloc] initWithUser:fromUser
										  msgStorage:_msgStorage
											   queue:NULL
										   audioMode:IMMsgQueueAudioModeOne
										   groupFlag:YES];
	_globalQueue.delegate = delegate;
	
	
	return _globalQueue;
}

- (void)closeDiscussMsgQueueWithUser:(IMUser *)fromUser
{
	if ([_globalQueue.fromUser isEqual:fromUser]) {
		[_globalQueue stopAudioPlay];
		_globalQueue.delegate = nil;
		_globalQueue = nil;
	}
}



#pragma mark - Deliver

- (void)deliverMsg:(IMMsg *)msg
{
	if ([_activeQueue.fromUser isEqual:msg.fromUser]) {
		[_activeQueue deliverMsg:msg];
	} else if ([_globalQueue.fromUser isEqual:msg.fromUser]) {
		[_globalQueue deliverMsg:msg];
	}
	else {
		IMMsgQueue *msgQueue = [_cacheQueue objectForKey:msg.fromUser.userID];
		if (msgQueue) {
			[msgQueue deliverMsg:msg];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)msgQueueActiving:(IMUser *)fromUser
{
	if (fromUser.userType & IMUserTypeP2P ||
        fromUser.userType & IMUserTypeBoradcast) {
		if ([_activeQueue.fromUser isEqual:fromUser]) {
			return YES;
		}
	} else {
		if ([_globalQueue.fromUser isEqual:fromUser]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark -
- (void)setIsQueueRecording:(BOOL)isQueueRecording
{
	_isQueueRecording = isQueueRecording;
	if (_activeQueue) {
		if (_isQueueRecording) {
			[_activeQueue pauseAudioPlay];
		} else {
			[_activeQueue resumAudioPlay];
		}
	}
}

//add by  yangyang   测试消息是否发送成功
- (void)localMsgSendStatuswithMsgid:(NSString *)msgid
{
    __weak typeof(self) weakself = self;
    if (_activeQueue) {
        
        [_activeQueue localMsgSendStatus:msgid blockHandler:^(id obj) {
            [weakself.msgStorage updateLocalMsgSendSuc:obj msgid:msgid];
            
            if (weakself&&[weakself isKindOfClass:[IMMsgQueueManager class]]) {
                
                IMMsg *cacheMsg = [weakself.msgStorage getCachedMsg:obj msgid:msgid];
                if (cacheMsg != nil) {
                    
                    
                    cacheMsg.procState = 0;
                }
            }else{
                return ;
            }
        }];
    }else{
        
            NSDictionary *dic =   [_msgStorage getMsgMgrSessionCache];
            NSArray *keys = [dic allKeys];
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    NSString *objS = obj;
                    if ( [objS containsString:msgid]) {
                        NSMutableString *mStr = [objS mutableCopy];
                        NSRange rang = [mStr rangeOfString:msgid];
                        [mStr deleteCharactersInRange:rang];
                        
                        
                        IMUserManager *mgr = [IMUserManager new];
                        IMUser *fromU =  [mgr createCacheUserWithID:mStr usertype:IMUserTypeP2P];
                        
                        
                        
                        [weakself.msgStorage updateLocalMsgSendSuc:fromU msgid:msgid];
                        
                        if (weakself&&[weakself isKindOfClass:[IMMsgQueueManager class]]) {
                            
                            IMMsg *cacheMsg = [weakself.msgStorage getCachedMsg:fromU msgid:msgid];
                            if (cacheMsg != nil) {
                                
                                
                                cacheMsg.procState = 0;
                            }
                        }else{
                            return ;
                        }

                        *stop = YES;
                    }
                    
                }
                
            }];
    }
}

- (void)localMsgReaded:(IMUser *)fromUser msgid:(NSString *)msgid
{
	[_msgStorage updateLocalMsgReaded:fromUser msgid:msgid];
	if ([_activeQueue.fromUser isEqual:fromUser]) {
		[_activeQueue localMsgReaded:msgid];
	} else {
		IMMsgQueue *msgQueue = [_cacheQueue objectForKey:fromUser.userID];
		if (msgQueue) {
			[msgQueue localMsgReaded:msgid];
		}
	}
}

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
	DDLogCVerbose(@"%@ will be evict!!", obj);
}
@end
