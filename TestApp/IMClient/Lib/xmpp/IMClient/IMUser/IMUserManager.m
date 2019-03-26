//
//  IMUserManager.m
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "IMUserManager.h"
#import "IMUser.h"
#import "NSData+XMPP.h"
#import "IMBaseClient.h"
@implementation IMUserManager

//+ (IMUserManager *)sharedIMUserMgr
//{
//	static dispatch_once_t once;
//    static IMUserManager *__singleton__;
//    dispatch_once(&once, ^ { __singleton__ = [[[self class] alloc] init]; });
//    return __singleton__;
//}

- (id)initWithClient:(IMBaseClient *)client
{
	self = [super init];
	if (self)
	{
		_userCache = [[NSCache alloc]init];
		[_userCache setCountLimit:200];
		
		_client = client;
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upUserInfo:) name:@"updataImMsgManager" object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearMemory
{
	[_userCache removeAllObjects];
}

///////////////
#pragma mark - Lib
- (NSString *)userKeyWithUserid:(NSString *)userid
{
    NSAssert(userid != nil, @"userid is nil");
    NSString *key = [NSString stringWithFormat:@"%@", userid];
	key = [[key dataUsingEncoding:NSUTF8StringEncoding] md5HashStr];
    return key;
}

#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IMUser *)createCacheUserWithID:(NSString *)userID usertype:(IMUserType)type
{
	return [self createCacheUserWithID:userID usertype:type nikename:nil];
}

- (IMUser *)createCacheUserWithID:(NSString *)userID usertype:(IMUserType)type nikename:(NSString *)nickName
{
	return [self createCacheUserWithID:userID usertype:type nikename:nickName avatar:nil];
}

- (IMUser *)createCacheUserWithID:(NSString *)userID usertype:(IMUserType)type nikename:(NSString *)nickName
						   avatar:(NSString *)avatarURL
{
	if (userID == nil)
		return nil;
	
	if ([nickName isEqual:[NSNull null]]) {
		nickName = nil;
	}
	//create hash key with 'type' and 'userid'
	NSString *key = [self userKeyWithUserid:userID];
	IMUser *user = [self.userCache objectForKey:key];
	
	if (user == nil || (user.userType&type) != type) {
		user = [[IMUser alloc]init];
		user.userID = userID;
		user.userType = type;
		
		//read nickname and avatarURL from vcard
		if ((nickName == nil || avatarURL == nil) && (type&IMUserTypeP2P) == IMUserTypeP2P) {
			XMPPvCardTemp *temp = [self.client.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:userID]
																	   shouldFetch:YES];
			if (temp) {
				if (nickName.length <= 0) {
					nickName = temp.nickname;
				}
				
				if (avatarURL.length <= 0) {
					avatarURL = temp.description;
				}
			}
		}
		
		user.nickname = nickName;
		user.avatarPath = avatarURL;
		
		[self.userCache setObject:user forKey:key];
	}
	else {
		//update from new nickname and avatarURL
		if (nickName.length > 0) {
			user.nickname = nickName;
		}
		
		if (avatarURL.length > 0) {
			user.avatarPath = avatarURL;
		}
		
		if (user.nickname.length <= 0) {
			XMPPvCardTemp *temp = [self.client.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:userID]
																	   shouldFetch:YES];
			if (temp) {
				if (nickName.length <= 0) {
					nickName = temp.nickname;
				}
				
				if (avatarURL.length <= 0) {
					avatarURL = temp.description;
				}
			}
		}
        
        if ([user.userID  hasPrefix:@"pub"]) {
          
            XMPPvCardTemp *temp = [self.client.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:user.userID]
                                                                           shouldFetch:YES];
            avatarURL = temp.description;
            user.avatarPath = avatarURL;
            NSLog(@"sxasadsad===%@",user.avatarPath);
            if (user.avatarPath==nil||[user.avatarPath  isEqualToString:@""]||[user.avatarPath  isEqualToString:NULL]) {
                
                //公众号。。。。。。。----
                //存放  公众号图片类方法
                NSString   *MYGuanZhuGongZhong =([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/guanzhuGongZhong"]);
                NSArray  *arryGongzhonghao=[NSArray  arrayWithContentsOfFile:MYGuanZhuGongZhong];
                for (NSDictionary *gongZhongDic  in arryGongzhonghao) {
                    if ([[gongZhongDic  valueForKey:@"public_id"]isEqualToString:[[user.userID  substringFromIndex:3] stringByReplacingOccurrencesOfString:@"@yuyu.com" withString:@""]]) {
                        user.avatarPath=[gongZhongDic  valueForKey:@"pic"];
                        break;
                    }
                }
                
                
            }
        }
        
        
	}
	return user;
}

- (void)updateCacheUserWithvCard:(XMPPvCardTemp *)vCard
{
	NSString *userID = [[vCard jid] bare];
	NSString *key = [self userKeyWithUserid:userID];
	IMUser *user = [self.userCache objectForKey:key];

	if (user) {
		if ([vCard nickname].length <= 0 && user.nickname.length <= 0) {
			user.nickname = userID;
		} else if (user.nickname.length <= 0)
			user.nickname = [vCard nickname];
		user.avatarPath = [vCard description];
	}
	return;
}

- (IMUser *)getIMUserFromCache:(NSString *)userID userType:(IMUserType )userType
{
	NSString *key = [self userKeyWithUserid:userID];
	IMUser *user = [self.userCache objectForKey:key];
	return user;
}

- (void)updateCacheUser:(NSString *)userID userType:(IMUserType)userType nickName:(NSString *)nickName
				 avatar:(NSString *)avatarURL
{
	if (userID == nil) {
		return;
	}
	
	NSString *key = [self userKeyWithUserid:userID];
	IMUser *user = [self.userCache objectForKey:key];
	
	if (user && userType == user.userType) {
		if (nickName) {
			user.nickname = nickName;
		}
		
		if (avatarURL) {
			user.avatarPath = avatarURL;
		}
	}
	
	return;
}
//add by 杨扬   本地用户更换头像后更新usercaghe

-(void)upUserInfo:(NSNotification *)notif
{
    NSDictionary *dic = (NSDictionary *)notif.userInfo;
    NSString *avatarPath = [dic objectForKey:@"avatarPath"];
    
    NSString *key = nil;
    
    if ([[dic objectForKey:@"userid"] containsString:@"@yuyu.com"]) {
        key = [self userKeyWithUserid:[dic objectForKey:@"userid"]];
    }else{
        
        key = [self userKeyWithUserid:[NSString stringWithFormat:@"%@@yuyu.com",[dic objectForKey:@"userid"]]];
    }
    
    IMUser *user = [self.userCache objectForKey:key];
    
    if (avatarPath) {
        user.avatarPath = avatarPath;
    }
}

@end
