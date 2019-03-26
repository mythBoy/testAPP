//
//  IMChatSession.m
//  IMClient
//
//  Created by pengjay on 13-7-9.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMChatSession.h"
#import "IMMsg.h"
#import "IMUser.h"
@implementation IMChatSession
- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ unread[%d][%@]", self.fromUser, self.unreadNum, self.msg];
}

- (NSString *)sessionBody
{
	NSString *prefix = @"";
	if (self.fromUser.userType & IMUserTypeDiscuss) {
		if (self.msg.msgUser.nickname.length > 0)
			prefix = [NSString stringWithFormat:@"%@:", self.msg.msgUser.nickname];
	}
	
	if (self.msg == nil)
	{
		return @"";
	}
	
	if (self.msg.msgType == IMMsgTypePic)
	{
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"图片", nil)];
	}
	else if (self.msg.msgType == IMMsgTypeAudio)
	{
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"语音", nil)];
	}
	else if (self.msg.msgType == IMMsgTypeVideo)
	{
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"视频", nil)];
	}
	else if (self.msg.msgType == IMMsgTypeFile)
	{
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"文件", nil)];
	}
	else if (self.msg.msgType == IMMsgTypeLocatioin)
	{
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"位置消息", nil)];
	}
	else if (self.msg.msgType == IMMsgTypeGift) {
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"礼物消息", nil)];
	}
    else if (self.msg.msgType == IMMsgTypeCard) {
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"名片", nil)];
	}
    else if (self.msg.msgType == IMMsgTypeWebFile) {
		return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"网盘文件", nil)];
    }
    else if (self.msg.msgType == IMMsgTypeShangQuan) {
        return [NSString stringWithFormat:@"%@[%@]", prefix, NSLocalizedString(@"分享商品", nil)];
    }
	else
		return [NSString stringWithFormat:@"%@%@", prefix, self.msg.msgBody];;
	
}
@end
