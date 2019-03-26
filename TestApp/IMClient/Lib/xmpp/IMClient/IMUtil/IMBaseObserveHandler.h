//
//  IMBaseObserveHandler.h
//  IMClient
//
//  Created by pengjay on 13-9-14.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMBaseObserveHandler;
typedef void(^IMBaseObserveCompeletedBlock) (IMBaseObserveHandler *handler, id newKey, id oldKey);

@interface IMBaseObserveHandler : NSObject
{
	BOOL _isObserved;	
}
@property (nonatomic,strong, readonly) id observedObj;

- (id)initWithObj:(id)obj keyPath:(NSString *)keyPath block:(IMBaseObserveCompeletedBlock)block;
- (void)addObserver;
- (void)removeObserver;
@end
