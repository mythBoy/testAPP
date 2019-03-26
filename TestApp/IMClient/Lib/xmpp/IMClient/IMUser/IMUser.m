//
//  IMUser.m
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "IMUser.h"

@implementation IMUser
- (NSString *)description
{
	return [NSString stringWithFormat:@"[%@:%@:%d]", self.userID,self.nickname, self.userType];
}

- (BOOL)isEqual:(id)object
{
	if ([object isKindOfClass:[IMUser class]]) {
		IMUser *other = (IMUser *)object;
		if ([other.userID isEqualToString:self.userID] && self.userType == other.userType) {
			return YES;
		}
	}
	return NO;
}

+ (IMUserType)userTypeForUserJidStr:(NSString *)jidStr
{
	NSArray *array = [jidStr componentsSeparatedByString:@"@"];
	if (array.count >= 2) {
		NSString *flagStr = [array objectAtIndex:1];
		if ([flagStr hasPrefix:@"qz"]) {
			return IMUserTypeDiscuss;
		}
        else if ([flagStr hasPrefix:@"broadcast"])
        {
            return IMUserTypeBoradcast;
        }
	}
	return IMUserTypeP2P;
}

- (NSString *)bareUserID
{
	return [[self.userID componentsSeparatedByString:@"@"] objectAtIndex:0];
}

+ (IMUser *)friendCenterUser
{
	IMUser *user = [[IMUser alloc]init];
	user.userID = @"friendCenterUser@friend";
	user.nickname = @"好友验证通知";
	user.userType = IMUserTypeFriendCenter;
	return user;
}
-(void)setAvatarPath:(NSString *)avatarPath
{
    _avatarPath = avatarPath;
}
-(void)setNickname:(NSString *)nickname
{
    _nickname = nickname;
}
@end
