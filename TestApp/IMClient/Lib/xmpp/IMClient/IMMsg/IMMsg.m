//
//  IMMsg.m
//  iPhoneXMPP
//
//  Created by pengjay on 13-7-8.
//
//

#import "IMMsg.h"
@implementation IMMsg
+ (NSString*)generateMessageID
{
	NSString *result = nil;
	
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	if (uuid)
	{
		result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
	}
	
	return result;
}

- (id)init
{
	if((self = [super init]))
	{
		self.msgTime = [NSDate date];
		self.msgID = [[self class] generateMessageID];
		_readState = IMMsgReadStateUnRead;
		_procState = IMMsgProcStateUnproc;
		_playState = IMMsgPlayStateUnPlay;
		_fromType = IMMsgFromOther;
		_msgVer = MSG_VERSION;
		_msgType = IMMsgTypeText;
	}
	return self;
}

- (id)initSendMsg
{
	if((self = [super init]))
	{
		self.msgTime = [NSDate date];
		self.msgID = [[self class] generateMessageID];
		_msgType = IMMsgTypeText;
		_readState = IMMsgReadStateUnRead;
		_procState = IMMsgProcStateUnproc;
		_playState = IMMsgPlayStatePlayed;
		_fromType = IMMsgFromLocalSelf;
		_msgVer = MSG_VERSION;
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"IMMsg:user[%@]type[%d]msgbody[%@]msgdate[%@]", self.msgUser, self.msgType, self.msgBody, self.msgTime];
}

//wwb
- (void)checkType
{
    NSDictionary *dic = self.msgAttach;
    
    if ([[dic objectForKey:@"type"] isEqualToString:@"imagetextsharelink"] ) {
        

        self.msgBody = [dic objectForKey:@"sharetitle"];
        
        self.msgType = IMMsgTypeImageText;
    }
    if ([[dic objectForKey:@"type"] isEqualToString:@"videolink"] ) {
        
//        self.msgBody = [dic objectForKey:@"sharetitle"];  //注释与2016.2.24  by 杨扬  修改原因：短视频不显示图片    有需要打开注释的需求与洋洋协商
    
        self.msgType = IMMsgTypeVideo;
    }

}
-(void)setProcState:(IMMsgProcState)procState
{
    _procState = procState;
}
-(void)setMsgBody:(NSString *)msgBody
{
    _msgBody = msgBody;
}
@end
