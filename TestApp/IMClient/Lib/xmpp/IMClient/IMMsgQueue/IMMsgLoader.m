//
//  IMMsgLoader.m
//  IMClient
//
//  Created by pengjay on 13-8-28.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMMsgLoader.h"
#define MSGPageNum 20
@implementation IMMsgLoader

- (instancetype)initWithFromUser:(IMUser *)user msgUser:(IMUser *)msgUser
					  msgStorage:(IMMsgStorage *)msgStorage queue:(dispatch_queue_t)queue
{
	self = [super init];
	if (self) {
		_fromUser = user;
		if (msgUser == nil) {
			_msgUser = _fromUser;
		} else
		_msgUser = msgUser;
		//		_audioMgr = audioHandler;
		_msgStorage = msgStorage;
		_msgArray = [NSMutableArray array];
		if (queue) {
			_mqueue = queue;
#if !OS_OBJECT_USE_OBJC
			dispatch_retain(_mqueue);
#endif
		}
		else {
			const char *name = [NSStringFromClass([self class]) UTF8String];
			_mqueue = dispatch_queue_create(name, NULL);
		}
		
		_mqueueTag = &_mqueueTag;
		dispatch_queue_set_specific(_mqueue, _mqueueTag, _mqueueTag, NULL);
		
		_hasMoreMsg = YES;
		[self loadMoreMsg];
	}
	return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
	dispatch_release(_mqueue);
#endif
}

- (void)loadMoreMsg
{
	dispatch_block_t block = ^{
		NSMutableArray *tmpArray = nil;
		if (_hasMoreMsg == YES) {
			tmpArray = [_msgStorage getMsgsFromUser:_fromUser msgUser:_msgUser fromMsgid:_lastMsg.msgID count:MSGPageNum];
		}
		
		if (tmpArray.count < MSGPageNum) {
			_hasMoreMsg = NO;
		} else {
			_hasMoreMsg = YES;
		}
		
		if (tmpArray.count > 0) {
			_lastMsg = [tmpArray lastObject];
			[_msgArray addObjectsFromArray:tmpArray];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if ([self.delegate respondsToSelector:@selector(imMsgLoader:didLoadMsg:)]) {
				[self.delegate imMsgLoader:self didLoadMsg:tmpArray];
			}
		});
	};

	if (dispatch_get_specific(_mqueueTag))
		block();
	else
		dispatch_async(_mqueue, block);
}

- (NSArray *)msgArray
{
	__block NSArray *retArray = nil;
	
	if (dispatch_get_specific(_mqueueTag))
		retArray = _msgArray;
	else {
		dispatch_sync(_mqueue, ^{
			retArray = [_msgArray copy];
		});
	}
	return retArray;
}

@end
