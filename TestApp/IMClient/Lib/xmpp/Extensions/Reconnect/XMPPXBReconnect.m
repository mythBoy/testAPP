//
//  XMPPXBReconnect.m
//  IMClient
//
//  Created by pengjay on 13-10-24.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "XMPPXBReconnect.h"
#import "XMPPStream.h"
@implementation XMPPXBReconnect
- (instancetype)initWithDispatchQueue:(dispatch_queue_t)queue
{
	self = [super initWithDispatchQueue:queue];
	if (self) {
		_xbReach = [Reachability reachabilityForInternetConnection];
		[_xbReach startNotifier];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(reachabilityChanged:)
													 name:kReachabilityChangedNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	dispatch_block_t block = ^{
		[_xbReach stopNotifier];
		[[NSNotificationCenter defaultCenter] removeObserver:self];
		_xbReach = nil;
	};
	
	if (dispatch_get_specific(moduleQueueTag))
		block();
	else
		dispatch_sync(moduleQueue, block);
}

#pragma mark - Notice
- (void)reachabilityChanged:(NSNotification *)note
{
		dispatch_block_t block = ^{ @autoreleasepool {
			Reachability *rea = note.object;
			NSLog(@"xx:%d", [rea currentReachabilityStatus]);
			if ([rea currentReachabilityStatus] == NotReachable) {
				[xmppStream closeStreamSocket];
			}
		}};

		if (dispatch_get_specific(moduleQueueTag))
			block();
		else
			dispatch_async(moduleQueue, block);
}

@end
