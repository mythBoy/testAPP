//
//  IMBaseClient.h
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"
#import "IMMsgAll.h"
#import "IMUserManager.h"
#import "IMMsgStorage.h"
#import "IMMsgCacheManager.h"
#import "IMChatSessionManager.h"
#import "IMMsgQueueManager.h"
#import "IMNewMsgNotifyManager.h"
#import "IMMsgObserveHandler.h"
#import "IMDefaultConfigurator.h"
#import "IMConfiguration.h"

typedef NS_ENUM(NSInteger, IMClientState)
{
	IMClientStateDisconnected = 0,
	IMClientStateConnecting,
	IMClientStateConnected,
};

@class GCDMulticastDelegate;
@protocol IMClientDelegate;
@class FMDatabaseQueue;

@interface IMBaseClient : NSObject
{
	NSString *_myUserID;
	NSString *_myPasswd;
	NSString *_host;
	NSUInteger _port;
	
	IMClientState _clientState;
	FMDatabaseQueue *_dbQueue;
	IMMsgCacheManager *_msgCacheMgr;
	IMChatSessionManager *_sessionMgr;
	IMMsgQueueManager *_msgQueueMgr;
	IMNewMsgNotifyManager *_msgNotifyMgr;
	IMUserManager *_userMgr;
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
	XMPPvCardSqlStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	IMMsgStorage *_msgStorage;
	
	XMPPRoster *xmppRoster;
	XMPPRosterSqlStorage *xmppRosterStorage;
	
	XMPPAutoPing *_xmppAutoPing;
	XMPPPing *_xmppPing;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	NSCache *_msgHandlerCache;
	
	BOOL shouldSignup;
	
	NSString *_deviceToken;
}

@property (nonatomic, readonly, strong) GCDMulticastDelegate <IMClientDelegate> *delegates;
@property (nonatomic, readonly, strong) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, readonly, strong) XMPPRoster *xmppRoster;
@property (nonatomic, readonly, strong) XMPPRosterSqlStorage *xmppRosterStorage;
@property (nonatomic, strong) IMUserManager *userMgr;
@property (nonatomic, readonly, strong) IMMsgStorage *msgStorage;
@property (nonatomic, readonly, strong) IMMsgCacheManager *msgCacheMgr;
@property (nonatomic, readonly, strong) IMChatSessionManager *sessionMgr;
@property (nonatomic, readonly) IMClientState clientState;

- (BOOL)connect;
- (BOOL)connectAndSignup;
- (void)setupClient;
- (void)teardownClient;

- (id)initWithHost:(NSString *)host port:(NSInteger)port;
- (BOOL)loginWithUserID:(NSString *)userID passwd:(NSString *)passwd shouldRegister:(BOOL)bRegister;
- (void)logOut;
- (void)reSendMsg:(IMMsg *)msg;
- (void)sendMsg:(IMMsg *)msg;
- (void)sendIQ:(XMPPIQ *)iq;

- (void)sendLocalSysNoteMsg:(IMMsg *)msg;

- (NSArray *)allFirstLetterAndUserInRoster;
- (NSArray *)searchFriendsWithKey:(NSString *)key;

//
- (void)handleRecvMsg:(IMMsg *)msg;
- (BOOL)shoudSendMsg:(IMMsg *)msg;

//
- (void)xmppStream:(XMPPStream *)sender didReceiveChatMessageWithEvent:(XMPPMessage *)message;

- (void)xmppStream:(XMPPStream *)sender didReceiveIQMessageWithEvent:(NSString *)msgid;

//push
- (void)setDeviceToken:(NSString *)deviceToken;
- (void)enterForeground;
- (void)enterBackground;
@end




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol IMClientDelegate <NSObject>

@optional

- (void)imClient:(IMBaseClient *)client stateChanged:(IMClientState)state;
- (void)imClient:(IMBaseClient *)client didRecvMsg:(IMMsg *)msg;
- (void)imClient:(IMBaseClient *)client didSendMsg:(IMMsg *)msg;
- (void)imClient:(IMBaseClient *)client didLogin:(BOOL)suc withError:(NSError *)error;
- (void)imClient:(IMBaseClient *)client didSignup:(BOOL)suc withError:(NSError *)error;
- (void)imClient:(IMBaseClient *)client conflictWithError:(NSError *)error;

- (void)imClientRosterDidChange:(IMBaseClient *)client;
- (void)imClient:(IMBaseClient *)client userInfoDidChange:(NSString *)userID;
- (void)imClient:(IMBaseClient *)client didUpdateMyUserInfo:(BOOL)suc withError:(NSError *)error;

- (void)imClientDidSetup:(IMBaseClient *)client;
- (void)imclientWillTearDown:(IMBaseClient *)client;
@end
