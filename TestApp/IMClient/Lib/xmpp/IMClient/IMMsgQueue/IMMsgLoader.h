//
//  IMMsgLoader.h
//  IMClient
//
//  Created by pengjay on 13-8-28.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMMsg.h"
#import "IMUser.h"
#import "IMMsgStorage.h"

@protocol IMMsgLoaderDelegate;

@interface IMMsgLoader : NSObject
{
	IMUser *_fromUser;
	IMUser *_msgUser;
	IMMsgStorage *_msgStorage;
	
	dispatch_queue_t _mqueue;
	void *_mqueueTag;
	
	NSMutableArray *_msgArray;
	
	IMMsg *_lastMsg;
}
@property (nonatomic, readonly) BOOL hasMoreMsg;
@property (nonatomic, weak) id <IMMsgLoaderDelegate> delegate;

- (instancetype)initWithFromUser:(IMUser *)user msgUser:(IMUser *)msgUser
					  msgStorage:(IMMsgStorage *)msgStorage queue:(dispatch_queue_t)queue;
- (void)loadMoreMsg;
- (NSArray *)msgArray;

@end


@protocol IMMsgLoaderDelegate <NSObject>

@optional
- (void)imMsgLoader:(IMMsgLoader *)loader didLoadMsg:(NSArray *)loadMsgs;
@end
