//
//  IMMsgStorageProtocol.h
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import "IMMsg.h"
#import "IMChatSession.h"
@protocol IMMsgStorageProtocol <NSObject>
@required
// Msg
- (void)saveMsg:(IMMsg *)msg; //保存消息
- (void)delMsg:(IMMsg *)msg; //删除消息

- (void)delMsg:(NSString *)groupId type:(NSString *)type msgId:(NSString *)msgID; //add by  杨扬  为后台删除敏感聊天信息添加
- (void)delAllMsg:(IMUser *)user;
- (NSMutableArray *)getUserPicMsg:(IMUser *)user;//获取图片消息

- (NSMutableArray *)getUserLastMsg:(IMUser *)user count:(int)cnt; //获取最近消息

- (NSMutableArray *)getUserOlderMsg:(IMUser *)user msgid:(NSString *)msgid count:(int)cnt; // 获取历史消息

- (NSMutableArray *)getMsgsFromUser:(IMUser *)fromuser msgUser:(IMUser *)msgUser fromMsgid:(NSString *)msgid count:(int)cnt; //获取对方消息

- (BOOL)msgExistwithMsgid:(NSString *)msgid user:(IMUser *)user;

//update Msg
- (void)updateMsgState:(IMMsg *)msg; //更新消息的state

- (void)updateMsgAttach:(IMMsg *)msg;

- (void)updateMsgBody:(IMMsg *)msg;

- (void)updateLocalMsgReaded:(IMUser *)fromUser msgid:(NSString *)msgid;

- (void)updateLocalMsgSendSuc:(IMUser *)fromUser msgid:(NSString *)msgid;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//ChatSession
- (void)delAllChatSession;


/**
 *	@brief 删除会话	
  */
- (void)delChatSession:(IMUser *)user;


/**
 *	@brief 清除聊天内容
 */
- (void)clearChatSessionContent:(IMUser *)user;

- (void)addChatSession:(IMMsg *)msg;

- (void)updateChatSession:(IMMsg *)msg;


- (NSUInteger)unreadTotalNum;

- (IMChatSession *)chatSessionForUser:(IMUser *)user;

- (void)setAllMsgReaded:(IMUser *)user;

- (void)setAllSessionReaded;

- (NSMutableArray *)getChatSessionList:(NSInteger)cnt;

- (NSMutableArray *)searchUsersInChatSessionWithKeyword:(NSString *)keywrod;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FriendCenter
- (IMMsgProcState)getFrinedCenterProcStateWithUser:(IMUser *)user;
- (void)updateFriendCenterProcState:(IMMsgProcState)state withUser:(IMUser *)user;

@end
