//
//  IMMsgStorage.h
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import "IMMsgStorageProtocol.h"

@class FMDatabaseQueue;
@class IMUserManager;
@class IMMsgCacheManager;

@interface IMMsgStorage : NSObject <IMMsgStorageProtocol>
{
//	IMUserManager *_userMgr;
	IMMsgCacheManager *_msgMgr;
}
@property (nonatomic,strong,readonly)IMUserManager *userMgr;;
@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;
- (id)initWithdbQueue:(FMDatabaseQueue *)dbQueue userManager:(IMUserManager *)userMgr
		   msgManager:(IMMsgCacheManager *)msgMgr;
- (NSString *)tableNameForUser:(IMUser *)user;
- (BOOL)hasChatRecord:(IMUser *)user;
-(NSDictionary *)getMsgMgrSessionCache;
- (IMMsg *)getCachedMsg:(IMUser *)fromUser msgid:(NSString *)msgid;

@end
