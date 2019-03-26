//
//  IMMsgQueueManager.h
//  IMClient
//
//  Created by pengjay on 13-7-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMsgQueue.h"
#import "IMMsgStorage.h"
#import "IMMsgDeliverProtocol.h"
@interface IMMsgQueueManager : NSObject <IMMsgDeliverProtocol, NSCacheDelegate>
{
	NSCache *_cacheQueue;
	IMMsgQueue *_activeQueue;
	IMMsgQueue *_globalQueue;

	IMMsgStorage *_msgStorage;
}
@property (nonatomic) BOOL isQueueRecording;
@property (nonatomic,strong)IMMsgStorage *msgStorage;
- (id)initWithMsgStorage:(IMMsgStorage *)msgStorage;
- (IMMsgQueue *)openNormalMsgQueueWithUser:(IMUser *)fromUser delegate:(id<IMMsgQueueDelegate>)delegate;
- (void)closeNormalMsgQueueWithUser:(IMUser *)fromUser;
- (BOOL)msgQueueActiving:(IMUser *)fromUser;
- (void)localMsgReaded:(IMUser *)fromUser msgid:(NSString *)msgid;

- (IMMsgQueue *)openDiscussMsgQueueWithUser:(IMUser *)fromUser delegate:(id<IMMsgQueueDelegate>)delegate;
- (void)closeDiscussMsgQueueWithUser:(IMUser *)fromUser;

//add by 杨扬  后台删除敏感消息使用
-(IMMsgQueue *)getQueue:(NSString *)userID;
//add by 杨杨  测试消息是否发送成功
- (void)localMsgSendStatuswithMsgid:(NSString *)msgid;
- (void)clearMemory;
@end
