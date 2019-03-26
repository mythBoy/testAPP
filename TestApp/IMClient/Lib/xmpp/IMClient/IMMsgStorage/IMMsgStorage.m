//
//  IMMsgStorage.m
//  iPhoneXMPP
//
//  Created by on 13-7-8.
//
//

#import "IMMsgStorage.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "IMUser.h"
#import "YRJSONAdapter.h"
#import "IMUserManager.h"
#import "XMPPLogging.h"

#import "IMChatSession.h"
#import "IMMsgCacheManager.h"
#import "IMMsgFactory.h"
#import "FriendListDBHandler.h"
#import "remarkManager.h"
#import "IMContext.h"
#import "IMMsgQueueManager.h"

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_VERBOSE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_OFF;
#endif

@interface NSMutableArray(Storage)
- (void)reverse;
@end

@implementation NSMutableArray(Storage)
- (void)reverse {
	for (int i=0; i<(floor([self count]/2.0)); i++) {
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
    }
}
@end


@implementation IMMsgStorage

- (id)initWithdbQueue:(FMDatabaseQueue *)dbQueue userManager:(IMUserManager *)userMgr
		   msgManager:(IMMsgCacheManager *)msgMgr
{
	self = [super init];
	if (self) {
		_dbQueue = dbQueue;
		_userMgr = userMgr;
		_msgMgr = msgMgr;
	}
	return self;
}

///////////////////////////////////////////////////////////////
- (NSString *)tableNameForMsg:(IMMsg *)msg
{
	return [self tableNameForUser:msg.fromUser];
}

- (NSString *)tableNameForUser:(IMUser *)user
{
	return [self tableNameForUserID:user.userID userType:user.userType];
}

- (NSString *)tableNameForUserID:(NSString *)userid userType:(IMUserType)type
{
	NSString *fixstr = userid;
	return [NSString stringWithFormat:@"immsg_%d_%@", type, fixstr];
}

- (NSString *)emptyStringWhenNil:(NSString *)str
{
	if (str == nil) {
		return @"";
	}
	return str;
}

- (NSString *)escapeString:(NSString *)str
{
	return  [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}
///////////////////////////////////////////////////////////////
//SQL
- (void)createMsgTable:(IMMsg *)msg db:(FMDatabase *)db
{
	NSString *tableName = [self tableNameForMsg:msg];
	
	NSString *sql = [NSString stringWithFormat:@"create table `%@` \
					 (mid integer PRIMARY KEY autoincrement,\
					 msgver integer default 1,\
					 msgid varchar(128) default '',\
					 userid varchar(64) default '',\
					 nickname varchar(128) default '',\
					 usertype integer default 0,\
					 msgtype integer default 1,\
					 msgbody text, msgsize integer,\
					 msgattach text default '',\
					 readstate integer,\
					 procstate integer,\
					 playstate integer,\
					 fromtype integer default 0,\
					 msgtime integer, \
					 remotetime integer, \
					 inserttime integer, \
					 colIntRes1 integer default 0,\
					 colIntRes2 integer default 0,\
					 colIntRes3 integer default 0,\
					 colStrRes1 Text default '',\
					 colStrRes2 Text default '',\
					 colStrRes3 Text default '')", tableName];
	
	[db executeUpdate:sql];
	sql = [NSString stringWithFormat:@"create index `%@_msgid_index` on `%@`(msgid)", tableName, tableName];
	[db executeUpdate:sql];
}

//- (NSString *)makeMsgInsertSql:(IMMsg *)msg
//{
//	NSString *sql = nil;
//	NSString *tableName = [self tableNameForMsg:msg];
//	
//	sql = [NSString stringWithFormat:@"insert into `%@`(msgid,msgver,userid,nickname,usertype,msgtype,msgbody,msgsize,msgattach,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime) values('%@',%d,'%@','%@',%d,%d,'%@',%llu,'%@',%d,%d,%d,%d,%lu,%lu,%lu)", tableName, msg.msgID,msg.msgVer, msg.msgUser.userID, msg.msgUser.nickname,msg.msgUser.userType, msg.msgType, msg.msgBody, msg.msgSize,[self emptyStringWhenNil:[msg.msgAttach JSONString]], msg.readState, msg.procState, msg.playState, msg.fromType,(unsigned long)[msg.msgTime timeIntervalSince1970] , (unsigned long)[msg.msgTime timeIntervalSince1970], time(NULL)];
//	
//	return sql;
//}

- (NSInteger )getProcStateWithMsgid:(NSString *)msgid tableName:(NSString *)tableName
{
    __block NSInteger ProcState = -2;
    NSString *sql = [NSString stringWithFormat:@"select ProcState from `%@` where msgid='%@'", tableName, msgid];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs;
        rs = [db executeQuery:sql];
        if([rs next])
        {
            ProcState = [rs intForColumn:@"ProcState"];
        }
        [rs close];
    }];
    return ProcState;
}

- (NSInteger )getMidWithMsgid:(NSString *)msgid tableName:(NSString *)tableName
{
	__block NSInteger mid = -2;
	NSString *sql = [NSString stringWithFormat:@"select mid from `%@` where msgid='%@'", tableName, msgid];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs;
		rs = [db executeQuery:sql];
		if([rs next])
		{
			mid = [rs intForColumn:@"mid"];
		}
		[rs close];
	}];
	return mid;
}

- (IMMsg *)getCachedMsg:(IMUser *)fromUser msgid:(NSString *)msgid
{
	IMMsg *cacheMsg = [_msgMgr getProcessCachedMsgWithUser:fromUser msgid:msgid];
	if (cacheMsg == nil) {
		cacheMsg = [_msgMgr getSessionCachedMsgWithUser:fromUser msgid:msgid];
	}
	return cacheMsg;
}

- (NSMutableArray *)getUserMsginDB:(FMDatabase *)db SQL:(NSString *)sql fromUser:(IMUser *)fromUser
{
	
	NSMutableArray *tmpArray = [NSMutableArray array];
	//		NSMutableDictionary *cacheDic = [NSMutableDictionary dictionary];
	FMResultSet *rs = [db executeQuery:sql];
	while ([rs next]) {
		IMMsgType type = [rs intForColumn:@"msgtype"];
		
		
		NSString *msguserID = [rs stringForColumn:@"userid"];
		IMUserType msguserType = [rs intForColumn:@"usertype"];
		NSString *msgID = [rs stringForColumn:@"msgid"];
        
        IMMsgProcState ps = [rs intForColumn:@"procstate"];

		IMMsg *cacheMsg = [self getCachedMsg:fromUser msgid:msgID];
		if (cacheMsg != nil) {
                [tmpArray addObject:cacheMsg];
                continue;
		}
        IMUser *msgUser;
        if ([rs intForColumn:@"fromType"] ==IMMsgFromLocalSelf) {
            
            NSString *imNickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"imNickName"];
            if (imNickName&&imNickName.length>0) {
                msgUser = [_userMgr createCacheUserWithID:msguserID usertype:msguserType nikename:imNickName];
                
            }else{
                msgUser = [_userMgr createCacheUserWithID:msguserID usertype:msguserType];
                
            }
        }else{
            msgUser = [_userMgr createCacheUserWithID:msguserID usertype:msguserType];

        }
		IMMsg *msg = [IMMsgFactory handleMsgWithFromUser:fromUser
												 msgUser:msgUser
												   msgid:[rs stringForColumn:@"msgid"]
												 msgTime:[rs dateForColumn:@"msgtime"]
												 isDelay:NO
												 msgBody:[rs stringForColumn:@"msgbody"]
												  attach:[[rs stringForColumn:@"msgattach"] objectFromJSONString]
												 msgType:type
												 msgSize:[rs unsignedLongLongIntForColumn:@"msgsize"]
												fromType:[rs intForColumn:@"fromtype"]
											   readState:[rs intForColumn:@"readstate"]
											   procState:[rs intForColumn:@"procstate"]
											   playState:[rs intForColumn:@"playstate"]];
        
        if (msg) {
            
            [tmpArray addObject:msg];
        }else{
            NSLog(@"******************error:msg==nil *******************\n******************error:msg==nil *******************");
        }
		
	}
	
	[rs close];
	return tmpArray;
}

- (NSMutableArray *)getUserMsgWithSql:(NSString *)sql fromUser:(IMUser *)fromUser
{
	__block NSMutableArray *resultArray = nil;
	
	[_dbQueue inDatabase:^(FMDatabase *db) {
		resultArray = [self getUserMsginDB:db SQL:sql fromUser:fromUser];
	}];
	return resultArray;
}

- (void)updateWithSql:(NSString *)sql
{
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSDictionary *)getMsgMgrSessionCache
{
    return [_msgMgr getSessionMsgCache];;
}


#pragma mark - Protocol
- (void)saveMsg:(IMMsg *)msg
{
	if(msg == nil || _dbQueue == nil)
		return;
	
    XMPPLogVerbose(@"save db:%@", msg);
    NSString *tableName = [self tableNameForMsg:msg];
    NSString *sql = [NSString stringWithFormat:@"insert into `%@`(msgid,msgver,userid,nickname,usertype,msgtype,\
                     msgbody,msgsize,msgattach,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime) \
                     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", tableName];
    
    __weak IMMsgStorage * wself = self;
    [_dbQueue inTransaction:^(FMDatabase *adb, BOOL *rollback) {
        IMMsgStorage *sself = wself;
        BOOL suc = [adb executeUpdate:sql, msg.msgID, @(msg.msgVer), msg.msgUser.userID, msg.msgUser.nickname, @(msg.msgUser.userType),
                    @(msg.msgType), msg.msgBody, @(msg.msgSize), [self emptyStringWhenNil:[msg.msgAttach JSONString]],
                    @(msg.readState), @(msg.procState), @(msg.playState), @(msg.fromType),msg.msgTime,msg.msgTime, @(time(NULL))];
        if(suc == NO)
        {
            XMPPLogError(@"%d", [adb lastErrorCode]);
            if([adb lastErrorCode] == 1)
            {
                [sself createMsgTable:msg db:adb];
                [adb executeUpdate:sql, msg.msgID, @(msg.msgVer), msg.msgUser.userID, msg.msgUser.nickname, @(msg.msgUser.userType),
                 @(msg.msgType), msg.msgBody, @(msg.msgSize), [self emptyStringWhenNil:[msg.msgAttach JSONString]],
                 @(msg.readState), @(msg.procState), @(msg.playState), @(msg.fromType),msg.msgTime,msg.msgTime, @(time(NULL))];
            }
        }
    }];
}

- (void)delMsg:(IMMsg *)msg
{
	if(msg == nil || _dbQueue  == nil)
		return;
	
	NSString *tableName = [self tableNameForUser:msg.fromUser];
	
	NSString *sql = [NSString stringWithFormat:@"delete from `%@` where msgid = '%@'", tableName, msg.msgID];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		BOOL suc = [db executeUpdate:sql];
	}];
    


}

//add by 杨扬   后台删除敏感消息使用

- (void)delMsg:(NSString *)groupId type:(NSString *)type msgId:(NSString *)msgID
{

    NSString *lastStr = nil;
    switch ([type intValue]) {
        case 2:
            lastStr = @"@qz.yuyu.com";
            break;
        case 8:
            lastStr = @"@broadcast.yuyu.com";
            break;
        default:
            lastStr = @"@yuyu.com";
            break;
    }
   NSString *tableName = [NSString stringWithFormat:@"immsg_%ld_%@%@", (long)[type integerValue], groupId,lastStr];
    
    NSString *sql = [NSString stringWithFormat:@"delete from `%@` where msgid = '%@'", tableName, msgID];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        BOOL suc = [db executeUpdate:sql];
    }];

    if ([IMContext checkContextExist] == YES) {
        [[IMContext sharedContext].msgQueueMgr clearMemory];
        
    }

}


- (void)delAllMsg:(IMUser *)user
{
	if (user == nil)
		return;
	NSString *tableName = [self tableNameForUser:user];
	
	NSString *sql = [NSString stringWithFormat:@"drop table `%@`", tableName];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
}

- (NSMutableArray *)getUserPicMsg:(IMUser *)user{
    NSString *tableName = [self tableNameForUser:user];
    NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgsize,msgattach,\
                     readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` where msgtype = 2 order by mid desc\
                     ", tableName];
   
    NSMutableArray *resultArray = [self getUserMsgWithSql:sql fromUser:user];
    [resultArray reverse];
    return resultArray;
}

- (NSMutableArray *)getUserLastMsg:(IMUser *)user count:(int)cnt
{
	NSString *tableName = [self tableNameForUser:user];
	
	NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgsize,msgattach,\
					 readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` order by mid desc\
					 limit %d", tableName, cnt];
	NSMutableArray *resultArray = [self getUserMsgWithSql:sql fromUser:user];
	[resultArray reverse];
	return resultArray;
}
- (IMMsg *)getLastMsg:(IMUser *)user msgid:(NSString *)msgid db:(FMDatabase *)db{
    NSString *tableName = [self tableNameForUser:user];
    
    NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgattach, \
                     msgsize,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` where\
                     msgid = '%@' limit 1", tableName, msgid];
    NSMutableArray *resultArray = [self getUserMsginDB:db SQL:sql fromUser:user];
    if (resultArray.count <= 0) {
        return nil;
    }
    return [resultArray objectAtIndex:0];
}


- (IMMsg *)getMessage:(IMUser *)user msgid:(NSString *)msgid db:(FMDatabase *)db
{
	
	NSString *tableName = [self tableNameForUser:user];
	
	NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgattach, \
					msgsize,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` where\
					msgid = '%@'", tableName, msgid];
	NSMutableArray *resultArray = [self getUserMsginDB:db SQL:sql fromUser:user];
	if (resultArray.count <= 0) {
		return nil;
	}
	return [resultArray objectAtIndex:0];
}

- (BOOL)msgExistwithMsgid:(NSString *)msgid user:(IMUser *)user
{
	__block BOOL flag = NO;
	__weak IMMsgStorage *wself = self;
	[_dbQueue inDatabase:^(FMDatabase *db) {
		IMMsgStorage *sself = wself;
		if ([sself getMessage:user msgid:msgid db:db] != nil)
		{
			flag = YES;
		}
	}];
	return flag;
}

- (NSMutableArray *)getUserOlderMsg:(IMUser *)user msgid:(NSString *)msgid count:(int)cnt
{
	NSString *tableName = [self tableNameForUser:user];
	NSInteger mid = [self getMidWithMsgid:msgid tableName:tableName];
	if(mid < 0)
		return nil;
	
	NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgsize,\
				msgattach,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` where\
					 mid < %d order by mid desc limit %d", tableName, mid,cnt];
	NSMutableArray *resultArray = [self getUserMsgWithSql:sql fromUser:user];
	[resultArray reverse];
	return resultArray;
}

- (NSMutableArray *)getMsgsFromUser:(IMUser *)fromuser msgUser:(IMUser *)msgUser fromMsgid:(NSString *)msgid count:(int)cnt
{
	if (!fromuser || !msgUser)
		return nil;
	
	NSString *tableName = [self tableNameForUser:fromuser];
	NSInteger mid = 0;
	if (msgid) {
		mid = [self getMidWithMsgid:msgid tableName:tableName] + 1;
	}
	
	if (mid < 0 || cnt <= 0) {
		return nil;
	}
	
	NSString *sql = [NSString stringWithFormat:@"select msgid,userid,nickname,usertype,msgtype,msgbody,msgsize,\
					 msgattach,readstate,procstate,playstate,fromtype,msgtime,remotetime,inserttime from `%@` where\
					 mid >= %d  and fromtype = %d and userid = '%@'  order by mid asc limit %d",
					 tableName, mid, IMMsgFromOther,msgUser.userID, cnt];
	NSMutableArray *resultArray = [self getUserMsgWithSql:sql fromUser:fromuser];
	return resultArray;
}
//update
- (void)updateMsgState:(IMMsg *)msg
{
	if(msg == nil)
		return;
	NSString *tableName = [self tableNameForMsg:msg];
	NSString *sql = [NSString stringWithFormat:@"update `%@` set readstate = %d, procstate = %d, playstate = %d where\
					 msgid = '%@'", tableName, msg.readState, msg.procState, msg.playState, msg.msgID];
    
	[self updateWithSql:sql];
    [_msgMgr addProcessMsg:msg];//更新缓存
}

- (void)updateMsgAttach:(IMMsg *)msg
{
	if (msg == nil)
		return;
	
	NSString *tableName = [self tableNameForMsg:msg];
	NSString *sql = [NSString stringWithFormat:@"update `%@` set msgattach = '%@' where msgid = '%@'",
					 tableName, [msg.msgAttach JSONString], msg.msgID];
	[self updateWithSql:sql];
}

- (void)updateMsgBody:(IMMsg *)msg
{
	if (msg == nil)
		return;
	
	NSString *tableName = [self tableNameForMsg:msg];
	NSString *sql = [NSString stringWithFormat:@"update `%@` set msgbody = '%@' where msgid = '%@'",
					 tableName, msg.msgBody, msg.msgID];
	[self updateWithSql:sql];
}

- (void)updateLocalMsgSendSuc:(IMUser *)fromUser msgid:(NSString *)msgid
{
    if (fromUser == nil)
        return;
    NSString *tableName = [self tableNameForUser:fromUser];
    NSString *sql = nil;
    if (msgid) {
        NSInteger ProcState = [self getProcStateWithMsgid:msgid tableName:tableName];
        if (ProcState!=0) {
            
            NSInteger mid = [self getMidWithMsgid:msgid tableName:tableName];
            sql = [NSString stringWithFormat:@"update `%@` set ProcState = %d where fromtype != %d and mid = %d",
                   tableName,
                   IMMsgProcStateSuc,
                   IMMsgFromOther,
                   mid];
            [self updateWithSql:sql];
        }
    }

}


- (void)updateLocalMsgReaded:(IMUser *)fromUser msgid:(NSString *)msgid
{
	if (fromUser == nil)
		return;
	NSString *tableName = [self tableNameForUser:fromUser];
	NSString *sql = nil;
	if (msgid) {
		NSInteger mid = [self getMidWithMsgid:msgid tableName:tableName];
		sql = [NSString stringWithFormat:@"update `%@` set readstate = %d where fromtype != %d and mid <= %d",
			   tableName,
			   IMMsgReadStateReaded,
			   IMMsgFromOther,
			   mid];
	} else {
		sql = [NSString stringWithFormat:@"update `%@` set readstate = %d where fromtype != %d",
			   tableName,
			   IMMsgReadStateReaded,
			   IMMsgFromOther];
	}
	[self updateWithSql:sql];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ChatSession
- (void)createChatSessionTable:(FMDatabase *)db
{
	NSString *sql = @"create table chatsession(\
	mid integer PRIMARY KEY autoincrement, \
	tbver integer default 1,\
	userid varchar(128) UNIQUE default '',\
	nickname varchar(128) default '',\
	usertype integer default 0,\
	lastmsgid varchar(128) default '', \
	unreadnum integer default 0,\
	updatetime integer,\
	createtime integer)";
	[db executeUpdate:sql];
	
	sql = [NSString stringWithFormat:@"create index userid_index on chatsession(userid)"];
    [db executeUpdate:sql];
	sql = [NSString stringWithFormat:@"create index updatetime_index on chatsession(updatetime)"];
    [db executeUpdate:sql];
}

- (NSString *)makeChatRecordInsertSql:(IMMsg *)msg
{
    

	int num = 1;
    if(msg.fromType != IMMsgFromOther || msg.readState == IMMsgReadStateReaded){
        num = 0;
    }
    
    NSString *sql = [NSString stringWithFormat:@"insert into chatsession(userid, nickname, usertype, lastmsgid,unreadnum, updatetime, createtime) values('%@','%@',%d, '%@', %d, %lu, %lu)", msg.fromUser.userID, msg.fromUser.nickname, msg.fromUser.userType, msg.msgID, num,(unsigned long)[msg.msgTime timeIntervalSince1970], time(NULL)];
    

	return sql;
}

- (NSString *)makeChatRecordUpdateSql:(IMMsg *)msg
{
	NSString *sql = nil;
	if(msg.fromType == IMMsgFromLocalSelf || msg.readState == IMMsgReadStateReaded){
        
        if ([[msg.msgAttach objectForKey:@"type"] isEqualToString:@"imagetextsharelink"]) {   //
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@', unreadnum=unreadnum,\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }else{
        //   ****  1、自己发送
		sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@', unreadnum=unreadnum,\
			   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
			   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }
	}else if(msg.fromType == IMMsgFromRemoteSelf){
		sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',updatetime=%lu\
			   where userid='%@'", msg.fromUser.nickname, msg.msgID,  (unsigned long)[msg.msgTime timeIntervalSince1970],
			   msg.fromUser.userID];
	}else{
        
        if (msg.msgType == IMMsgTypeGolden) {
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@', unreadnum=unreadnum,\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }else{
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@',lastmsgid='%@', unreadnum=unreadnum+1,\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];

        }
	}
	return sql;
}



- (NSString *)updateChatRecordUpdateSql:(IMMsg *)msg
{
    NSString *sql = nil;
    if(msg.fromType == IMMsgFromLocalSelf || msg.readState == IMMsgReadStateReaded)
    {
        
        if ([[msg.msgAttach objectForKey:@"type"] isEqualToString:@"imagetextsharelink"]) {   //
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }else{
            
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }
    }
    else if(msg.fromType == IMMsgFromRemoteSelf)
    {
        sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',updatetime=%lu\
               where userid='%@'", msg.fromUser.nickname, msg.msgID,  (unsigned long)[msg.msgTime timeIntervalSince1970],
               msg.fromUser.userID];
    }
    else
    {
        
        if (msg.msgType == IMMsgTypeGolden) {
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }else{
            
            sql = [NSString stringWithFormat:@"update chatsession set nickname='%@', lastmsgid='%@',\
                   updatetime=%lu where userid='%@'", msg.fromUser.nickname, msg.msgID,
                   (unsigned long)[msg.msgTime timeIntervalSince1970], msg.fromUser.userID];
        }
    }
    return sql;
}




- (BOOL)hasChatRecord:(IMUser *)user
{
	NSString *sql = [NSString stringWithFormat:@"select userid from chatsession where userid = '%@'", user.userID];
	__block BOOL flag = NO;
	[_dbQueue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs = [db executeQuery:sql];
		if([rs next])
			flag = YES;
		[rs close];
	}];
	return flag;
}

//专门为修改备注名使用

- (BOOL)hasChatRecordRemark
{
    NSString *sql = [NSString stringWithFormat:@"select remark from chatsession" ];
    __block BOOL flag = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        if([rs next])
            flag = YES;
        [rs close];
    }];
    return flag;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)delAllChatSession
{
	NSArray *sessions = [self getChatSessionList:0];
	for (IMChatSession *se in sessions) {
		[self delChatSession:se.fromUser];
	}
}

//delete msg table and session 
- (void)delChatSession:(IMUser *)user
{
	NSString *sql = [NSString stringWithFormat:@"delete from chatsession where userid = '%@'", user.userID];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
	
	NSString *tableName = [self tableNameForUser:user];
	sql = [NSString stringWithFormat:@"drop table `%@`", tableName];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
}

//delete msg table and reset session content
- (void)clearChatSessionContent:(IMUser *)user
{
	NSString *sql1 = [NSString stringWithFormat:@"update chatsession set unreadnum=0, lastmsgid = '' where userid = '%@'", user.userID];
	NSString *tableName = [self tableNameForUser:user];
	NSString *sql2 = [NSString stringWithFormat:@"drop table `%@`", tableName];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql1];
		[db executeUpdate:sql2];
	}];
}

- (void)updateChatSession:(IMMsg *)msg
{
    if (msg == nil)
        return;
    
    NSString *insertSql = nil;
    if([self hasChatRecord:msg.fromUser])
    {
        insertSql = [self updateChatRecordUpdateSql:msg];
    }
    else
    {
        return;
    }
    __weak IMMsgStorage *wself = self;
    
    [_dbQueue inDatabase:^(FMDatabase *adb) {
        IMMsgStorage *sself = wself;
        BOOL suc = [adb executeUpdate:insertSql];
        if(suc == NO)
        {
            if([adb lastErrorCode] == 1)
            {
                [sself createChatSessionTable:adb];
                [adb executeUpdate:insertSql];
            }
        }
        
    }];
}



- (void)addChatSession:(IMMsg *)msg
{
	if (msg == nil)
		return;
	
	NSString *insertSql = nil;
	if([self hasChatRecord:msg.fromUser])
	{
		insertSql = [self makeChatRecordUpdateSql:msg];
	}
	else
	{
		insertSql = [self makeChatRecordInsertSql:msg];
	}
	__weak IMMsgStorage *wself = self;
	
	[_dbQueue inDatabase:^(FMDatabase *adb) {
		IMMsgStorage *sself = wself;
		BOOL suc = [adb executeUpdate:insertSql];
		if(suc == NO)
		{
			if([adb lastErrorCode] == 1)
			{
				[sself createChatSessionTable:adb];
				[adb executeUpdate:insertSql];
			}
		}
		
	}];
}

- (NSMutableArray *)getChatSessionList:(NSInteger)cnt
{
    
    BOOL isNew = [self hasChatRecordRemark];
    NSString *sql ;
    if (isNew) {
        sql = [NSString stringWithFormat:@"select userid, nickname, usertype, lastmsgid, unreadnum, updatetime,remark from chatsession order by updatetime desc limit %d", cnt];
        if (cnt == 0) {
            sql = [NSString stringWithFormat:@"select userid, nickname, usertype, lastmsgid, unreadnum, updatetime,remark from chatsession order by updatetime desc"];
        }

    }else{
        sql = [NSString stringWithFormat:@"select userid, nickname, usertype, lastmsgid, unreadnum, updatetime from chatsession order by updatetime desc limit %d", cnt];
        if (cnt == 0) {
            sql = [NSString stringWithFormat:@"select userid, nickname, usertype, lastmsgid, unreadnum, updatetime from chatsession order by updatetime desc"];
        }
    }
    
	
	__block NSMutableArray *resultArray = nil;
	
	[_dbQueue inDatabase:^(FMDatabase *db) {
		
		NSMutableArray *tmpArray = [NSMutableArray array];
		FMResultSet *rs = [db executeQuery:sql];
		while ([rs next]) {
			IMChatSession *chatSession = [[IMChatSession alloc]init];
			
			NSString *userid = [rs stringForColumn:@"userid"];
            NSString *nickName = [rs stringForColumn:@"nickname"];
            
            NSString *uid = [[userid componentsSeparatedByString:@"@"] objectAtIndex:0];
            

            
            NSString * remarkName = [[remarkManager sharedManager] getObjectForKey:uid];
            if (remarkName && remarkName.length>0 && ![remarkName isEqualToString:@""] ) {
                nickName = remarkName;
                
            }


			IMUserType userType = [rs intForColumn:@"usertype"];
			chatSession.fromUser = [_userMgr createCacheUserWithID:userid usertype:userType nikename:nickName];
			chatSession.unreadNum = [rs intForColumn:@"unreadnum"]; 
			
			NSString *lastMsgid = [rs stringForColumn:@"lastmsgid"];
			
			//search cache first
			IMMsg *cacheMsg = [self getCachedMsg:chatSession.fromUser msgid:lastMsgid];
			if (cacheMsg) {
				chatSession.msg = cacheMsg;
			}
			else {
				//chatSession.msg = [self getMessage:chatSession.fromUser msgid:lastMsgid db:db];
                chatSession.msg = [self getLastMsg:chatSession.fromUser msgid:lastMsgid db:db];
                [_msgMgr addSessionMsgWithUser:chatSession.fromUser msg:chatSession.msg];
			}
			
			[tmpArray addObject:chatSession];
		}
		
		[rs close];
		resultArray = tmpArray;
	}];
	return resultArray;
}

- (IMChatSession *)chatSessionForUser:(IMUser *)user
{
	NSString *sql = [NSString stringWithFormat:@"select userid, nickname, usertype, lastmsgid, unreadnum, updatetime\
					 from chatsession where userid = '%@'", user.userID];

	__block IMChatSession *retSession = nil;
	[_dbQueue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs = [db executeQuery:sql];
		if ([rs next]) {
			IMChatSession *chatSession = [[IMChatSession alloc]init];
			
			NSString *userid = [rs stringForColumn:@"userid"];
			NSString *nickName = [rs stringForColumn:@"nickname"];
			IMUserType userType = [rs intForColumn:@"usertype"];
			chatSession.fromUser = [_userMgr createCacheUserWithID:userid usertype:userType nikename:nickName];
			chatSession.unreadNum = [rs intForColumn:@"unreadnum"];
			
			NSString *lastMsgid = [rs stringForColumn:@"lastmsgid"];
			
			//search cache first
			IMMsg *cacheMsg = [self getCachedMsg:chatSession.fromUser msgid:lastMsgid];
			if (cacheMsg) {
				chatSession.msg = cacheMsg;
			}
			else {
				chatSession.msg = [self getMessage:chatSession.fromUser msgid:lastMsgid db:db];
                [_msgMgr addSessionMsgWithUser:chatSession.fromUser msg:chatSession.msg];
			}
			
			retSession = chatSession;
		}
		
		[rs close];
	}];
	return retSession;
}

- (NSUInteger)unreadTotalNum
{
	NSString *sql = [NSString stringWithFormat:@"select sum(unreadnum) as b from chatsession where unreadnum>0"];
	__block NSInteger num = 0;
	[_dbQueue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs = [db executeQuery:sql];
		if([rs next])
			num = [rs intForColumn:@"b"];
		[rs close];
	}];
	return num;
}

- (NSMutableArray *)searchUsersInChatSessionWithKeyword:(NSString *)keywrod
{
	NSString *sql = [NSString stringWithFormat:@"select userid, nickname, usertype from chatsession where nickname \
					 like '%%%@%%'", keywrod];
	
	__block NSMutableArray *resultArray = nil;
	
	[_dbQueue inDatabase:^(FMDatabase *db) {
		
		NSMutableArray *tmpArray = [NSMutableArray array];
		FMResultSet *rs = [db executeQuery:sql];
		while ([rs next]) {
			NSString *userid = [rs stringForColumn:@"userid"];
			NSString *nickName = [rs stringForColumn:@"nickname"];
			IMUserType userType = [rs intForColumn:@"usertype"];
			
			IMUser *user = [_userMgr createCacheUserWithID:userid usertype:userType nikename:nickName];
			
			[tmpArray addObject:user];
		}
		
		[rs close];
		resultArray = tmpArray;
	}];
	return resultArray;
}

- (void)setAllMsgReaded:(IMUser *)user
{
	NSString *sql = [NSString stringWithFormat:@"update chatsession set unreadnum=0 where userid = '%@'", user.userID];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
}

- (void)setAllSessionReaded
{
	NSString *sql = [NSString stringWithFormat:@"update chatsession set unreadnum=0"];
	[_dbQueue inDatabase:^(FMDatabase *db) {
		[db executeUpdate:sql];
	}];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IMMsgProcState)getFrinedCenterProcStateWithUser:(IMUser *)user
{
	IMUser *friendCenter = [IMUser friendCenterUser];
	NSString *tableName = [self tableNameForUser:friendCenter];
	NSString *sql = [NSString stringWithFormat:@"select procstate from `%@` where userid = '%@' order by mid desc limit 1", tableName, user.userID];
	__block IMMsgProcState st = -1;
	[_dbQueue inDatabase:^(FMDatabase *db) {
		FMResultSet *rs;
		rs = [db executeQuery:sql];
		if([rs next])
		{
			st = [rs intForColumn:@"procstate"];
		}
		[rs close];
	}];
	return st;
}

- (void)updateFriendCenterProcState:(IMMsgProcState)state withUser:(IMUser *)user
{
	IMUser *friendCenter = [IMUser friendCenterUser];
	NSString *tableName = [self tableNameForUser:friendCenter];
	NSString *sql = [NSString stringWithFormat:@"update `%@` set procstate = %d where userid = '%@'", tableName, state, user.userID];
	[self updateWithSql:sql];
}
@end
