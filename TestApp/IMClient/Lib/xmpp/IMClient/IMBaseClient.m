//
//  IMBaseClient.m
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "IMBaseClient.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPvCardAvatarModule.h"
//#import "XMPPMessage+XEP0045.h"
#import "NSXMLElement+XEP_0203.h"
#import "XMPPMessage+Custom.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "FMDatabaseQueue.h"
#import <CFNetwork/CFNetwork.h>

#import "IMUser.h"
#import "IMPathHelper.h"
#import "IMContext.h"
#import "IMMsgFactory.h"
#import "IMCoreUtil.h"
#import "messageDelManager.h"
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface IMBaseClient()

@end

@implementation IMBaseClient
@synthesize xmppvCardTempModule = xmppvCardTempModule;
@synthesize xmppRoster = xmppRoster;
@synthesize msgCacheMgr = _msgCacheMgr;
@synthesize sessionMgr = _sessionMgr;
@synthesize xmppRosterStorage = xmppRosterStorage;
@synthesize userMgr = _userMgr;
@synthesize msgStorage = _msgStorage;
@synthesize clientState = _clientState;

- (id)init
{
    self = [super init];
    if (self) {
        [DDLog removeAllLoggers];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        _host = [IMConfiguration sharedInstance].configurator.host;
        _port = [IMConfiguration sharedInstance].configurator.port;
        _delegates = (GCDMulticastDelegate<IMClientDelegate> *)[[GCDMulticastDelegate alloc]init];
        
    }
    return self;
}

- (id)initWithHost:(NSString *)host port:(NSInteger)port
{
    self = [super init];
    if (self) {
        [DDLog removeAllLoggers];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        if (host.length > 0 && port > 0) {
            _host = host;
            _port = port;
        } else {
            _host = [IMConfiguration sharedInstance].configurator.host;
            _port = [IMConfiguration sharedInstance].configurator.port;
        }
        
        _delegates = (GCDMulticastDelegate<IMClientDelegate> *)[[GCDMulticastDelegate alloc]init];
    }
    return self;
}

- (void)dealloc
{
    DDLogInfo(@"BaseClient Dealloc");
    
    //    [NSException raise:@"IMSessino error" format:@"BaseClient Dealloc! imcontext must be init first!"];
    
    [self teardownStream];
    [IMContext destroyInstance];
    
}

#pragma prtocted

- (void)setupStream
{
    NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
    
    // Setup xmpp stream
    //
    // The XMPPStream is the base class for all activity.
    // Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        // Want xmpp to run in the background?
        //
        // P.S. - The simulator doesn't support backgrounding yet.
        //        When you try to set the associated property on the simulator, it simply fails.
        //        And when you background an app on the simulator,
        //        it just queues network traffic til the app is foregrounded again.
        //        We are patiently waiting for a fix from Apple.
        //        If you do enableBackgroundingOnSocket on the simulator,
        //        you will simply see an error message from the xmpp stack when it fails to set the property.
        
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    
    // Setup reconnect
    //
    // The XMPPReconnect module monitors for "accidental disconnections" and
    // automatically reconnects the stream for you.
    // There's a bunch more information in the XMPPReconnect header file.
    
    xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect setAutoReconnect:YES];
    
    //Setup AutoPing
    _xmppAutoPing = [[XMPPAutoPing alloc] init];
    [_xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppAutoPing activate:xmppStream];
    
    //Setup Ping
    _xmppPing = [[XMPPPing alloc] init];
    [_xmppPing activate:xmppStream];
    // Setup roster
    //
    // The XMPPRoster handles the xmpp protocol stuff related to the roster.
    // The storage for the roster is abstracted.
    // So you can use any storage mechanism you want.
    // You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
    // or setup your own using raw SQLite, or create your own storage mechanism.
    // You can do it however you like! It's your application.
    // But you do need to provide the roster with some storage facility.
    
    ////////////////////////////////////////////////////////////////////////////////////////
    xmppRosterStorage = [[XMPPRosterSqlStorage alloc]initWithdbQueue:_dbQueue];
    xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:xmppRosterStorage];
    
    
    // Setup vCard support
    //
    // The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
    // The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.
    
    xmppvCardStorage = [[XMPPvCardSqlStorage alloc]init];
    xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];
    
    [xmppReconnect	activate:xmppStream];
    [xmppvCardTempModule activate:xmppStream];
    [xmppRoster activate:xmppStream];
    
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppStream setHostName:_host];
    [xmppStream setHostPort:_port];
    
    allowSelfSignedCertificates = NO;
    allowSSLHostNameMismatch = NO;
    
}


- (void)teardownStream
{
    [xmppStream removeDelegate:self];
    [xmppvCardTempModule removeDelegate:self];
    [xmppRoster removeDelegate:self];
    [xmppReconnect removeDelegate:self];
    [xmppRoster deactivate];
    [xmppReconnect deactivate];
    [xmppvCardTempModule deactivate];
    
    [_xmppAutoPing  removeDelegate:self];
    [_xmppAutoPing deactivate];
    
    [_xmppPing deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
    xmppvCardTempModule = nil;
    xmppvCardStorage = nil;
    _xmppAutoPing = nil;
    _xmppPing = nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)goOnline
{
    
  
    
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    if(_deviceToken != nil)
        [presence addAttributeWithName:@"token" stringValue:_deviceToken];
    [presence addAttributeWithName:@"active" stringValue:@"1"];
    NSString* appver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSXMLElement *ver = [NSXMLElement elementWithName:@"ver" stringValue:appver];
    NSXMLElement *dev = [NSXMLElement elementWithName:@"device" stringValue:@"ios"];
    [presence addChild:ver];
    [presence addChild:dev];
    [xmppStream sendElement:presence];
    
    
    
    

}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [xmppStream sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    
    if (_myUserID == nil || _myPasswd == nil) {
        DDLogError(@"%@: userId or passwd is nil", THIS_METHOD);
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:_myUserID
                                       resource:[IMConfiguration sharedInstance].configurator.jidResource]];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}


- (BOOL)connectAndSignup
{
    shouldSignup = YES;
    return [self connect];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupClient
{
    _msgHandlerCache = [[NSCache alloc]init];
    _clientState = IMClientStateDisconnected;
    
    _userMgr = [[IMUserManager alloc]initWithClient:self];
    
    _dbQueue = [[FMDatabaseQueue alloc]initWithPath:[IMPathHelper userStoragePath:_myUserID]];
    
    _msgCacheMgr = [[IMMsgCacheManager alloc]init];
    _msgStorage = [[IMMsgStorage alloc]initWithdbQueue:_dbQueue userManager:_userMgr msgManager:_msgCacheMgr];
    
    _msgQueueMgr = [[IMMsgQueueManager alloc]initWithMsgStorage:_msgStorage];
    
    _sessionMgr = [[IMChatSessionManager alloc]initWithMsgStorage:_msgStorage dispatchQueue:NULL msgQueueMgr:_msgQueueMgr];
    
    _msgNotifyMgr = [[IMNewMsgNotifyManager alloc]initWithMsgQueueMgr:_msgQueueMgr];
    
    IMContext *context = [[IMContext alloc]initWithLoginUserID:[_userMgr createCacheUserWithID:_myUserID
                                                                                      usertype:IMUserTypeP2P]
                                                    msgStorage:_msgStorage msgQueueMgr:_msgQueueMgr];
    
    [IMContext initInstance:context];
    
}

- (void)teardownClient
{
    
}

- (BOOL)loginWithUserID:(NSString *)userID passwd:(NSString *)passwd shouldRegister:(BOOL)bRegister
{
    if (userID == nil || passwd == nil)
        return NO;
    
    _myUserID = userID;
    _myPasswd = passwd;
    
    [self setupClient];
    
    if (xmppStream != nil)
        [self teardownStream];
    [self setupStream];
    [_delegates imClientDidSetup:self];
    if (bRegister)
        return [self connectAndSignup];
    else
        return [self connect];
}

- (void)logOut
{
    [self disconnect];
    [self teardownStream];
    [_delegates imclientWillTearDown:self];
    [self teardownClient];
}
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    _clientState = IMClientStateConnecting;
    [self.delegates imClient:self stateChanged:_clientState];
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
  

}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if (allowSelfSignedCertificates)
    {
        [settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
    }
    
    if (allowSSLHostNameMismatch)
    {
        [settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    
    NSError *error = nil;
    
    if (![xmppStream authenticateWithPassword:_myPasswd error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);
    }
}
#pragma mark  登录成功后操作
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    _clientState = IMClientStateConnected;
    [self.delegates imClient:self stateChanged:_clientState];
    [self.delegates imClient:self didLogin:YES withError:nil];
    [self goOnline];
    
    
#pragma mark  连接成功  主动求情离线消息
    [self sendIQ:nil];
    [messageDelManager sharedManager];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    _clientState = IMClientStateDisconnected;
    [self.delegates imClient:self stateChanged:_clientState];
    
    if (shouldSignup) {
        NSError *er = nil;
        if (![xmppStream registerWithPassword:_myPasswd error:&er]) {
            DDLogVerbose(@"register error1:%@", er);
        }
        
    }
    [self.delegates imClient:self didLogin:NO withError:nil];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    shouldSignup = NO;
    [self.delegates imClient:self didSignup:YES withError:nil];
    if ([xmppStream authenticateWithPassword:_myPasswd error:nil]) {
        DDLogVerbose(@"auth error");
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    shouldSignup = NO;
    [self.delegates imClient:self didSignup:NO withError:nil];
}
#pragma mark  接口消息回执iq
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *msgid = [iq attributeStringValueForName:@"id"];
    NSLog(@">>>>>>>>>>>>%@",msgid);
    if (msgid) {
        
        if (![msgid isEqualToString:@"111"]) {
            [self xmppStream:sender didReceiveIQMessageWithEvent:msgid];
        }
    }
    
    
    
    return NO;
}

#pragma mark  接收的message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@:%@", THIS_FILE, THIS_METHOD, message);
    if ([message isChatMessageWithBody])
    {
        [self xmppStream:sender didReceiveChatMessageWithBody:message];
    }
    
    else if ([message isMessageWithBody])
    {
        [self xmppStream:sender didReceiveSysMessageWithBody:message];
    }
    else if([message isChatMessageWithEvent])//群事件消息
    {
        [self xmppStream:sender didReceiveChatMessageWithEvent:message];//建群
    }
    else
    {
        DDLogVerbose(@"Not Handler msg!");
        
        
        //处理body为空
        
        //add by 杨扬   后台删除敏感消息使用
        //
        //        NSXMLElement *eventEl = [message elementForName:@"event"];
        //        NSString * kindStr = [eventEl attributeStringValueForName:@"kind"];
        
        
        
    }
    
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSXMLElement *conflict = [error elementForName:@"conflict" xmlns:@"urn:ietf:params:xml:ns:xmpp-streams"];
    if (conflict != nil) {
        [self.delegates imClient:self conflictWithError:nil];
        [self teardownStream];
    }
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    _clientState = IMClientStateDisconnected;
    [self.delegates imClient:self stateChanged:_clientState];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *msgID = [message attributeStringValueForName:@"id"];
    NSString *userID = [message attributeStringValueForName:@"to"];
    IMMsg *msg = [_msgCacheMgr getProcessMsgWithUserID:userID msgID:msgID];
    if (msg) {
        //		msg.procState = IMMsgProcStateSuc;
//        [_msgCacheMgr removeProcessMsg:msg];
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSString *msgID = [message attributeStringValueForName:@"id"];
    NSString *userID = [message attributeStringValueForName:@"to"];
    IMMsg *msg = [_msgCacheMgr getProcessMsgWithUserID:userID msgID:msgID];
    if (msg) {
        msg.procState = IMMsgProcStateFaied;
        [_msgCacheMgr removeProcessMsg:msg];
    }
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Reconnect
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags
{
    _clientState = IMClientStateConnecting;
    [self.delegates imClient:self stateChanged:_clientState];
    
    return YES;
}

#pragma mark - AutoPing
- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - MessageHandler
//私聊消息处理
- (void)xmppStream:(XMPPStream *)sender didReceiveChatMessageWithBody:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    NSDate *msgDate = [NSDate date];
    if([message wasDelayed])
    {
        msgDate = [message delayedDeliveryDate];
        
    }
    
    NSString *userJID = nil;
    
    //这里要区分是在房间里的单独对话消息还是真正的私聊消息
    XMPPJID* msgFrom = [message from];
    //	NSString* fromDomain = [msgFrom domain];
    NSString* nickName = [message attributeStringValueForName:@"nick"];
    NSString *msgID = [message elementID];
    if(msgID == nil || [msgID length] <= 0)
        msgID = [IMMsg generateMessageID];
    
    userJID = [msgFrom bare];
    
    IMUser *fromUser = [self.userMgr createCacheUserWithID:userJID usertype:IMUserTypeP2P nikename:nickName];
    IMUser *msgUser = [self.userMgr createCacheUserWithID:userJID usertype:IMUserTypeP2P nikename:nickName];
    
    ///Discuss Group Message Process
    if ([XMPPUserObject xmppUserTypeWithJidStr:userJID] == XMPPUserTypeDiscussGroup) {
        NSXMLElement *body = [message elementForName:@"body"];
        NSString *dismsgUserJID = [body attributeStringValueForName:@"sponsor"];
        NSString *dissmgUserName = [body attributeStringValueForName:@"name"];
        msgUser = [self.userMgr createCacheUserWithID:dismsgUserJID usertype:IMUserTypeP2P nikename:dissmgUserName];
        
        fromUser = [self.userMgr createCacheUserWithID:userJID usertype:IMUserTypeDiscuss nikename:nickName];
    }
    ///
    
    assert(msgUser.userID);
    
    
    NSXMLElement *body = [message elementForName:@"body"];
    NSString *chatMsg = [body stringValue];
    NSString *chatType = [body attributeStringValueForName:@"type" withDefaultValue:XMPPMessageTypeNormal];
    int nSize = [body attributeIntValueForName:@"size" withDefaultValue:0];
    
    NSMutableDictionary *attach = nil;
    if ([chatType isEqualToString:XMPPMessageTypePicFileLink] || [chatType isEqualToString:XMPPMessageTypeVideoLink] || [chatType isEqualToString:XMPPMessageTypeWebFileLink]|| [chatType isEqualToString:XMPPMessageTypeProductLink]) {
        //		attach = [NSMutableDictionary dictionary];
        //		NSString *thumbURL = [body attributeStringValueForName:@"thumb"];
        //		if (thumbURL) {
        //			[attach setObject:thumbURL forKey:@"thumburl"];
        //		}
        attach = [body attributesAsDictionary];
    }
    
    IMMsg *recvMsg = [IMMsgFactory handleMsgWithFromUser:fromUser msgUser:msgUser msgid:msgID msgTime:msgDate
                                                 isDelay:[message wasDelayed] msgBody:chatMsg attach:attach
                                                 msgType:[XMPPMessage getImMsgType:chatType] msgSize:nSize
                                                fromType:IMMsgFromOther readState:IMMsgReadStateUnRead
                                               procState:IMMsgProcStateUnproc playState:IMMsgPlayStateUnPlay];
    
    if (recvMsg) {
        
        
        [self handleRecvMsg:recvMsg];
    }
}

//系统消息处理
- (void)xmppStream:(XMPPStream *)sender didReceiveSysMessageWithBody:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    //查看是否为管理员消息
    //	NSString* from = [[message from] full];
    //	if ([from isEqualToString:XMPP_SVR_DOMAIN]) {
    //		//是管理员的广播消息
    //		NSXMLElement *body = [message elementForName:@"body"];
    //		NSString *chatMsg = [body stringValue];
    //		//            NSString *chatType = [body attributeStringValueForName:@"type" withDefaultValue:XMPPMessageTypeNormal];
    //		int nSize = [body attributeIntValueForName:@"size" withDefaultValue:0];
    //
    //		ChatMsg *cmsg = [[[ChatMsg alloc]init] autorelease];
    //
    //		NSDate *senddate = [NSDate date];
    //		if([message wasDelayed])
    //		{
    //			senddate = [message delayedDeliveryDate];
    //			cmsg.isDelay = YES;
    //			cmsg.groupTime = [senddate timeIntervalSince1970];
    //
    //			CUSTOMIZELOG(@"%@", senddate);
    //		}
    //		cmsg.remoteTime = [senddate timeIntervalSince1970];
    //
    //		cmsg.roomID = ADMIN_JID;
    //		cmsg.roomName = ADMIN_NAME;
    //		cmsg.userID = ADMIN_JID;
    //		cmsg.userName = ADMIN_NAME;
    //		cmsg.msgID = [Public generateMessageID:cmsg.userName];
    //		cmsg.msgSize = nSize;
    //
    //		cmsg.message = chatMsg;
    //		cmsg.msgType = MESSAGETYPETEXT;
    //		cmsg.msgStat = MSGSTATPLAYED;
    //		cmsg.fromFlag = 1;
    //
    //		dispatch_async(dispatch_get_main_queue(), ^{
    //			[[MsgProc sharedMsgProc] recvPrivateMsg:cmsg];
    //		});
    //	}
    
}

//群聊事件处理
- (void)xmppStream:(XMPPStream *)sender didReceiveChatMessageWithEvent:(XMPPMessage *)message
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    //	NSString *fromJidstr = [[message from] bare];
    //	//        if(![Public isQunJid:groupid])
    //	//            return;
    //	NSString *nickName = [message attributeStringValueForName:@"nick"];
    //	NSXMLElement *event = [message elementForName:@"event"];
    //	NSString *kind = [event attributeStringValueForName:@"kind"];
    //	NSString *msgBody = [message stringValue];
    //
    //	IMUser *msgUser = [[IMUser alloc]init] ;
    //	msgUser.userID = fromJidstr;
    //	msgUser.nickname = nickName;
    //
    //	IMUser *fromUser = [[IMUser alloc]init] ;
    
}
#pragma mark - HandelMsg
- (void)handleRecvMsg:(IMMsg *)msg
{
    [_msgStorage saveMsg:msg];
    [_msgQueueMgr deliverMsg:msg];
    [_sessionMgr deliverMsg:msg];
    [_msgNotifyMgr deliverMsg:msg];
    
    if (msg.fromType != IMMsgFromLocalSelf) {
        [self.delegates imClient:self didRecvMsg:msg];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Roster
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@", presence);
    [xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
}

- (void)xmppRosterDidChange:(XMPPRosterSqlStorage *)sender
{
    DDLogVerbose(@"roster changed");
    [self.delegates imClientRosterDidChange:self];
}

- (void)xmppRosterDidPopulate:(XMPPRosterSqlStorage *)sender
{
    DDLogVerbose(@"roster populate");
}


- (void)xmppRoster:(XMPPRosterSqlStorage *)sender didAddUser:(NSString *)userJid
{
    DDLogVerbose(@"roster add :%@", userJid);
}

- (void)xmppRoster:(XMPPRosterSqlStorage *)sender didUpdateUser:(NSString *)userJid
{
    DDLogVerbose(@"roster update :%@", userJid);
}

- (void)xmppRoster:(XMPPRosterSqlStorage *)sender didRemoveUser:(NSString *)userJid
{
    DDLogVerbose(@"roster remove :%@", userJid);
}


- (void)xmppRoster:(XMPPRosterSqlStorage *)sender
    didAddResource:(XMPPResourceObject *)resource
          withUser:(NSString *)userJid
{
    DDLogVerbose(@"roster online:%@", userJid);
}

- (void)xmppRoster:(XMPPRosterSqlStorage *)sender
 didUpdateResource:(XMPPResourceObject *)resource
          withUser:(NSString *)userJid
{
    DDLogVerbose(@"roster updateline:%@", userJid);
}

- (void)xmppRoster:(XMPPRosterSqlStorage *)sender
 didRemoveResource:(XMPPResourceObject *)resource
          withUser:(NSString *)userJid
{
    DDLogVerbose(@"roster offline:%@", userJid);
}

#pragma mark - vCardTempDelegate
- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    
    DDLogVerbose(@"%@: %@: %@", THIS_FILE, THIS_METHOD, [jid bare]);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        vCardTemp.jid = jid;
        [self.userMgr updateCacheUserWithvCard:vCardTemp];
        
        //change name if user in roster
        [self.xmppRoster setNickname:[vCardTemp nickname] ifExsitUserJidstr:[jid bare]];
        [self.delegates imClient:self userInfoDidChange:[jid bare]];
    });
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule
{
    [self.delegates imClient:self didUpdateMyUserInfo:YES withError:nil];
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error
{
    [self.delegates imClient:self didUpdateMyUserInfo:NO withError:nil];
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SendMsg
- (BOOL)sendXmppChatMsg:(IMMsg *)msg
{
    if ([xmppStream isDisconnected]) {
        
        [self connect];
        //change process state, and update
        msg.procState = IMMsgProcStateFaied;
        [_msgStorage updateMsgState:msg];
        return NO;
    }
    DDLogVerbose(@"sendMsg:sendXMPP:%@", msg.msgID);
    XMPPMessage *xmppMsg = [XMPPMessage message];
    [xmppMsg addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
    [xmppMsg addAttributeWithName:@"id" stringValue:msg.msgID];
    [xmppMsg addAttributeWithName:@"to" stringValue:msg.fromUser.userID];
    [xmppMsg addAttributeWithName:@"from" stringValue:[[xmppStream myJID] full]];
    [xmppMsg addAttributeWithName:@"type" stringValue:@"chat"];
    
//    NSTimeInterval interval = [msg.msgTime timeIntervalSince1970];
//    NSString *datekey = [NSString stringWithFormat:@"%.0f",interval];
//    [xmppMsg addAttributeWithName:@"msgTime" stringValue:datekey];

    
    //add by 杨扬   增加头像
    
    [xmppMsg addAttributeWithName:@"avatarPath" stringValue:msg.msgUser.avatarPath];
    
    [xmppMsg addAttributeWithName:@"nick" stringValue:[IMCoreUtil spaceStringIfNullOrNSNull:msg.msgUser.nickname]];
    
    NSXMLElement *sendMsgBody = [NSXMLElement elementWithName:@"body"
                                                  stringValue:[IMCoreUtil spaceStringIfNullOrNSNull:msg.msgBody]];
    
    if (msg.msgType != IMMsgTypeText && msg.msgType != IMMsgTypeEmotion) {
        [sendMsgBody addAttributeWithName:@"type" stringValue:[XMPPMessage getXMPPMsgTypeStr:msg.msgType]];
    }
    
    if (msg.msgAttach) {
        for (NSString *tkey in msg.msgAttach.allKeys) {
            NSString *tValues = [msg.msgAttach objectForKey:tkey];
            if ([IMCoreUtil objIsNULLorNSNull:tValues]) {
                DDLogCError(@"msgattach have nil value");
                continue;
            }
            [sendMsgBody addAttributeWithName:tkey stringValue:tValues];
        }
    }
    
    [xmppMsg addChild:sendMsgBody];
    
    // 转发图片视频消息时 状态为未处理
    // BUG #17409 【IOS金融通正式环境】首页-》微信-》转发语音给好友-》好友查看转发的语音-》语音一直处于加载中
    //语音消息没做状态改变
    //语音消息也做处理
    
    if ([msg.msgAttach objectForKey:@"zhuanfa"] != nil && (msg.msgType == IMMsgTypePic||msg.msgType == IMMsgTypeVideo||msg.msgType == IMMsgTypeAudio)) {
        msg.procState = IMMsgProcStateUnproc;
    }else {
        //update state
        //        msg.procState = IMMsgProcStateSuc;
    }
    [_msgStorage updateMsgState:msg];
    NSAssert(xmppStream != nil, @"xmppstream eoor ");
    [xmppStream sendElement:xmppMsg];
    
    [self.delegates imClient:self didSendMsg:msg];
    
    return YES;
}
- (void)sendIQ:(XMPPIQ *)iq
{
    
    NSXMLElement *offline = [NSXMLElement elementWithName:@"offline" xmlns:@"http://jabber.org/protocol/offline"];
    NSXMLElement *fetch = [NSXMLElement elementWithName:@"fetch"];
    
    [offline addChild:fetch];
    
    XMPPIQ *IQ = [XMPPIQ iqWithType:@"get" to:nil elementID:@"111" child:offline];
    [xmppStream sendElement:IQ];
}

- (void)clearMsgInCache:(IMMsg *)msg
{
    //	[_msgCacheMgr removeProcessMsg:msg];
    [_msgHandlerCache removeObjectForKey:msg.msgID];
}

- (void)reSendMsg:(IMMsg *)msg
{
    [self sendMsg:msg shouldSave:NO];
}

- (void)sendMsg:(IMMsg *)msg
{
    [self sendMsg:msg shouldSave:YES];
}

- (BOOL)shoudSendMsg:(IMMsg *)msg
{
    if (_clientState != IMClientStateConnected) {
        msg.procState = IMMsgProcStateFaied;
        [_msgStorage updateMsgState:msg];
        return NO;
    }
    return YES;
}

#pragma mark  sengMsg

- (void)sendMsg:(IMMsg *)msg shouldSave:(BOOL)shouldSave
{
    if (msg == nil)
        return;
    DDLogVerbose(@"WillSendMsg:%@:%@", msg.msgID, msg.fromUser);
    
    
    
    
    // 视频聊天记录在下边保存  不此存保存 by 郝晓锋
    if (shouldSave && ![[msg.msgAttach objectForKey:@"lm_title"]  isEqualToString:@"VIDEO_CALL"]) {
        [_msgCacheMgr addProcessMsg:msg];
        [self handleRecvMsg:msg];

    }
    
    if (![self shoudSendMsg:msg]) {
        return;
    }
    //
    if (msg.msgType == IMMsgTypeText || msg.msgType == IMMsgTypeLocatioin || msg.msgType == IMMsgTypeGift || msg.msgType == IMMsgTypeEmotion || msg.msgType == IMMsgTypeCard || msg.msgType == IMMsgTypeGolden || msg.msgType == IMMsgTypeBastard  || msg.msgType == IMMsgTypeWebFile || msg.msgType == IMMsgTypeImageText || msg.msgType == IMMsgTypeGifImage || msg.msgType == IMMsgTypeShangQuan)
    {
        msg.procState = IMMsgProcStateProcessing;
        
        
        
        [self sendXmppChatMsg:msg];
        
        //// 消息ping---测试消息发送成功
        NSXMLElement *ping = [NSXMLElement elementWithName:@"ping" xmlns:@"urn:xmpp:ping"];
        
        XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:nil elementID:msg.msgID child:ping];
        
        [xmppStream sendElement:iq];
        //// 消息ping---测试消息发送成功
        
        
    }else if (msg.msgType == IMMsgTypeAudio || msg.msgType == IMMsgTypeFile || msg.msgType == IMMsgTypePic
              || msg.msgType == IMMsgTypeVideo) {
        
        __weak typeof(self) wself = self;
        IMMsgObserveHandler *proHandler = [[IMMsgObserveHandler alloc]initWithMsg:msg keyPath:@"procState"
                                                                  compeletedBolck:^(IMMsgObserveHandler *handler, IMMsg *msg1, NSNumber *nValue, NSNumber *oValue) {
                                                                      static int i = 0;
                                                                      NSLog(@"fuck:%d", i++);
                                                                      typeof(self) sself = wself;
                                                                      if ([nValue integerValue] == IMMsgProcStateSuc &&
                                                                          [oValue integerValue] == IMMsgProcStateProcessing) {
                                                                          DDLogVerbose(@"SendMsg:upload end:%@:%@", msg.msgID, nValue);
                                                                          [sself sendXmppChatMsg:msg1];
                                                                          
                                                                          //// 消息ping---测试消息发送成功
                                                                          NSXMLElement *ping = [NSXMLElement elementWithName:@"ping" xmlns:@"urn:xmpp:ping"];
                                                                          
                                                                          XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:nil elementID:msg.msgID child:ping];
                                                                          
                                                                          [xmppStream sendElement:iq];
                                                                          //// 消息ping---测试消息发送成功
                                                                      }
                                                                      
                                                                      if (([nValue integerValue] == IMMsgProcStateSuc||
                                                                           [nValue integerValue] == IMMsgProcStateFaied) &&
                                                                          [oValue integerValue] == IMMsgProcStateProcessing) {
                                                                          DDLogVerbose(@"sendmsg:remove cache:%@", nValue);
                                                                          [sself clearMsgInCache:msg1];
                                                                      }
                                                                  }];
        
        // 转发消息的时候 不需要上传图片等信息 by 郝晓锋
        if ([msg.msgAttach objectForKey:@"zhuanfa"] != nil) {
            [self sendXmppChatMsg:msg];
            
            //// 消息ping---测试消息发送成功
            NSXMLElement *ping = [NSXMLElement elementWithName:@"ping" xmlns:@"urn:xmpp:ping"];
            
            XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:nil elementID:msg.msgID child:ping];
            
            [xmppStream sendElement:iq];
            //// 消息ping---测试消息发送成功
            if (msg.msgType == IMMsgTypeFile) {
                [_msgStorage updateLocalMsgSendSuc:msg.fromUser msgid:msg.msgID];
                msg.procState =  IMMsgProcStateSuc;
            }
        }else {
            [_msgHandlerCache setObject:proHandler forKey:msg.msgID];
            [_msgCacheMgr addProcessMsg:msg];
            [proHandler addObserver];
            IMFileMsg *fileMsg = (IMFileMsg *)msg;
            [fileMsg uploadFile];
        }
        
    }
    
    if (shouldSave){
        
        if ([[msg.msgAttach objectForKey:@"lm_title"]  isEqualToString:@"VIDEO_CALL"]) {
            if ([msg.fromUser.userID containsString:@"videocall."]) {
                NSRange range = [msg.fromUser.userID rangeOfString:@"videocall."];
                NSMutableString *str = [msg.fromUser.userID mutableCopy];
                
                [str deleteCharactersInRange:range];
                
                
                msg.fromUser.userID = str;
            }
            [self handleRecvMsg:msg];
        }
    }
    
}

- (void)sendLocalSysNoteMsg:(IMMsg *)msg
{
    if (msg == nil || msg.msgType != IMMsgTypeNotice)
        return;
    
    //add videoChat  by yangyang
    if ([[msg.msgAttach objectForKey:@"lm_title"] isEqualToString:@"33"]) {
        msg.msgBody = [NSString stringWithFormat:@"您向%@发起了视频聊天",msg.fromUser.nickname];
    }
    
    [self handleRecvMsg:msg];
}

#pragma mark - Users
- (NSArray *)allFirstLetterAndUserInRoster
{
    NSArray *xUserArray = [xmppRosterStorage allUsers];
    NSMutableArray *letterArray = [NSMutableArray array];
    NSMutableDictionary *userArrayForLetter = [NSMutableDictionary dictionary];
    for (XMPPUserObject *xuser in xUserArray) {
        IMUserType type = 0;
        if (xuser.usertype == XMPPUserTypeUser) {
            type |= IMUserTypeP2P;
            //			[self.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:xuser.jidStr] ignoreStorage:YES];
        }
        else
            type |= IMUserTypeDiscuss;
        
        if (xuser.isAdmin)
            type |= IMUserTypeAdmin;
        
        IMUser *user = [_userMgr createCacheUserWithID:xuser.jidStr usertype:type nikename:xuser.nickname];
        NSString *letter = [NSString stringWithFormat:@"%c", xuser.firstLetter];
        if (![letterArray containsObject:letter])
            [letterArray addObject:letter];
        
        NSMutableArray *imusers = [userArrayForLetter objectForKey:letter];
        if (imusers == nil) {
            imusers = [NSMutableArray array];
            [userArrayForLetter setObject:imusers forKey:letter];
        }
        
        [imusers addObject:user];
        
    }
    
    NSArray *resultArray = [NSArray arrayWithObjects:letterArray, userArrayForLetter, nil];
    return resultArray;
}

- (NSArray *)searchFriendsWithKey:(NSString *)key
{
    NSArray *xUserArray = [xmppRosterStorage searchUsersWithKey:key];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (XMPPUserObject *xuser in xUserArray) {
        IMUserType type = 0;
        if (xuser.usertype == XMPPUserTypeUser)
            type |= IMUserTypeP2P;
        else
            type |= IMUserTypeDiscuss;
        
        if (xuser.isAdmin)
            type |= IMUserTypeAdmin;
        
        IMUser *user = [_userMgr createCacheUserWithID:xuser.jidStr usertype:type nikename:xuser.nickname];
        if (![resultArray containsObject:user]) {
            [resultArray addObject:user];
        }
    }
    return resultArray;
}

#pragma mark - push
- (void)enterBackground
{
    
    

    
    
    XMPPPresence *presence = [XMPPPresence presence];
    
    [presence addAttributeWithName:@"active" stringValue:@"0"];
    
    if(_deviceToken != nil)
        [presence addAttributeWithName:@"token" stringValue:_deviceToken];
    
    NSString* appver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSXMLElement *ver = [NSXMLElement elementWithName:@"ver" stringValue:appver];
    NSXMLElement *dev = [NSXMLElement elementWithName:@"device" stringValue:@"ios"];
    NSXMLElement *aw = [NSXMLElement elementWithName:@"show" stringValue:@"away"];
    [presence addChild:ver];
    [presence addChild:dev];
    [presence addChild:aw];
    [xmppStream sendElement:presence];
}

- (void)enterForeground
{
    if(xmppStream.isConnected)//进入前台，恢复在线状态
    {
        XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
        if(_deviceToken != nil)
            [presence addAttributeWithName:@"token" stringValue:_deviceToken];
        [presence addAttributeWithName:@"active" stringValue:@"1"];
        NSString* appver = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        NSXMLElement *ver = [NSXMLElement elementWithName:@"ver" stringValue:appver];
        NSXMLElement *dev = [NSXMLElement elementWithName:@"device" stringValue:@"ios"];
        [presence addChild:ver];
        [presence addChild:dev];
        [xmppStream sendElement:presence];
    }
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    if (deviceToken == nil) {
        return;
    }
    _deviceToken = [NSString stringWithString:deviceToken];
    if(xmppStream.isConnected)
    {
        XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
        [presence addAttributeWithName:@"token" stringValue:_deviceToken];
        [xmppStream sendElement:presence];
    }
}
@end
