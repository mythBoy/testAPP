//
//  IMPicMsg.m
//  IMClient
//
//  Created by pengjay on 13-7-15.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMPicMsg.h"
#import "IMPathHelper.h"
#import "IMUser.h"
#import "YRJSONAdapter.h"
#import "IMContext.h"
#import "IMMsgStorage.h"
#import "IMConfiguration.h"

@implementation IMPicMsg
- (id)init
{
	self = [super init];
	if (self) {
		self.msgType = IMMsgTypePic;
	}
	return self;
}

- (NSString *)fileLocalPath
{
	if (_localPath == nil) {
		NSString *filename = [NSString stringWithFormat:@"%@.jpg", self.msgID];
		_localPath = [IMPathHelper thumbnailPathWithUserID:self.fromUser.userID fileName:filename];
	}
	return _localPath;
}


- (void)setOriginFileRemoteURL:(NSString *)originRemtoeURL
{
	if (originRemtoeURL.length <= 0)
		return;
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.msgAttach];
	[dic setObject:originRemtoeURL forKey:@"originurl"];
	self.msgAttach = dic;
}

- (void)setFileRemoteURL:(NSString *)remoteURL
{
	if (remoteURL.length <= 0)
		return;
	self.msgBody = remoteURL;
}

- (NSString *)originFileLocalPath
{
	if (_originFilePath == nil) {
		if (self.fromType == IMMsgFromLocalSelf) {
			NSString *filename = [NSString stringWithFormat:@"%@.jpg", self.msgID];
			_originFilePath = [IMPathHelper picPathWithUserID:self.fromUser.userID fileName:filename isSend:YES];
		} else {
			NSString *filename = [self.originFileRemoteUrl lastPathComponent];
			_originFilePath = [IMPathHelper picPathWithUserID:self.fromUser.userID fileName:filename isSend:NO];
		}
	}
	return _originFilePath;
}

- (NSString *)originFileRemoteUrl
{
	return [self.msgAttach objectForKey:@"originurl"];
}

- (NSUInteger)originFileSize
{
	return [[self.msgAttach objectForKey:@"size"] integerValue];
}

- (void)uploadFile
{
	if ( self.fromType != IMMsgFromLocalSelf) {
		return;
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.originFileLocalPath]) {
		return;
	}
	
	self.procState = IMMsgProcStateProcessing;
	
	/////////////Custom
	NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
	
	BOOL isp2p = self.fromUser.userType & IMUserTypeP2P;
	NSString *postType = [[IMConfiguration sharedInstance].configurator msgPostType:self.msgType isp2p:isp2p thumbnail:NO];
//	postDic = [NSDictionary dictionaryWithObject:postType forKey:@"type"];
	[postDic setObject:postType forKey:@"type"];
	[postDic setObject:@"280" forKey:@"width"];
	[postDic setObject:@"280" forKey:@"height"];
//    [postDic setObject:@"140" forKey:@"width"];
//    [postDic setObject:@"140" forKey:@"height"];
	
	////////////
	
	_fileUploader = [[IMFileUploader alloc]init];
	_fileUploader.delegate = self;
	
	[_fileUploader uploadFile:self.originFileLocalPath postURLStr:[self filePostUrl] postDic:postDic];
}

#pragma mark upload
- (void)imFileUploaderDidFinished:(IMFileUploader *)uploader resp:(NSString *)resp
{
	NSDictionary *dic = [resp objectFromJSONString];
	if ([dic[@"ok"] integerValue] == 1) {
 

		[self setOriginFileRemoteURL: [IMCoreUtil  isHttp:dic[@"url"]]];
		[self setFileRemoteURL:[IMCoreUtil  isHttp:dic[@"thumb"]]];
		
		self.procState = IMMsgProcStateSuc;
		[[IMContext sharedContext].msgStorage updateMsgState:self];
		[[IMContext sharedContext].msgStorage updateMsgBody:self];
		[[IMContext sharedContext].msgStorage updateMsgAttach:self];
	}
	else {
		self.procState = IMMsgProcStateFaied;
		[[IMContext sharedContext].msgStorage updateMsgState:self];
	}
	
	_fileUploader.delegate = nil;
	_fileUploader = nil;
	
}
@end
