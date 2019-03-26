//
//  IMBaseObserveHandler.m
//  IMClient
//
//  Created by pengjay on 13-9-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMBaseObserveHandler.h"

@interface IMBaseObserveHandler ()
@property (nonatomic, copy) IMBaseObserveCompeletedBlock block;
@property (nonatomic, copy) NSString *keyPath;
@end

@implementation IMBaseObserveHandler

- (id)initWithObj:(id)obj keyPath:(NSString *)keyPath block:(IMBaseObserveCompeletedBlock)block
{
	self = [super init];
	if (self) {
		_observedObj = obj;
		self.keyPath = keyPath;
		_isObserved = NO;
		self.block = block;
	}
	return self;
}

- (void)dealloc
{
	[self removeObserver];
}

- (void)addObserver
{
	if (_isObserved == NO) {
		_isObserved = YES;
		[_observedObj addObserver:self forKeyPath:_keyPath
						  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
						  context:nil];
	}
}

- (void)removeObserver
{
	@synchronized(self){
		if (_isObserved) {
			_isObserved = NO;
			[_observedObj removeObserver:self forKeyPath:_keyPath];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:_keyPath]) {
		id n = [change objectForKey:NSKeyValueChangeNewKey];
		id o = [change objectForKey:NSKeyValueChangeOldKey];
		if (_block) {
			_block(self, n, o);
		}
	}
}

@end
