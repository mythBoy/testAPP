//
//  IMFileMsg.m
//  IMClient
//
//  Created by pengjay on 13-7-12.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMFileMsg.h"
#import "IMPathHelper.h"
#import "IMUser.h"
#import "IMContext.h"
#import "IMMsgStorage.h"
#import "YRJSONAdapter.h"
#import "IMConfiguration.h"
#import "IMDefaultConfigurator.h"

@implementation IMFileMsg
- (id)init
{
	self = [super init];
	if (self) {
		self.msgType = IMMsgTypeFile;
	}
	return self;
}

- (void)cancelProcessing
{
	if (self.fromType == IMMsgFromLocalSelf) {
		[self cancelUpload];
	} else {
		[self cancelDownload];
	}
}

- (NSString *)fileLocalPath
{
	if (_localPath == nil) {
		if (self.fromType == IMMsgFromLocalSelf && [self.msgAttach objectForKey:@"zhuanfa"] == nil) {
//			_localPath = [self.msgAttach objectForKey:@"localpath"];
            _localPath = [self.msgAttach objectForKey:@"localpath"];
			if (!_localPath) {
				NSString *filename = [NSString stringWithFormat:@"%@.jpg", self.msgID];
				_localPath = [IMPathHelper docFilePathWithUserID:self.fromUser.userID fileName:filename isSend:YES];
			}
		} else {
 
            NSString *filename = [self.msgAttach objectForKey:@"displayname"];
            //	 NSString *filename = [self.fileRemoteUrl lastPathComponent];
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *downloadDirectories = [NSString stringWithFormat:@"%@/DownloadFile",cachesPath];
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:downloadDirectories]) {
                [fm createDirectoryAtPath:downloadDirectories withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            _localPath = [NSString stringWithFormat:@"%@/%@",downloadDirectories,filename];
		}
	}
    
    if (_localPath != nil) {
        NSArray *array = [_localPath componentsSeparatedByString:@"/Library/Caches/DownloadFile"];
        _localPath = [_localPath stringByReplacingOccurrencesOfString:[array firstObject] withString:NSHomeDirectory()];
    }
    
	return _localPath;
}

- (void)setFileLocalPath:(NSString *)path
{
	if (path.length <= 0) {
		return;
	}
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.msgAttach];
	[dic setObject:path forKey:@"localpath"];
    [dic setObject:path forKey:@"url"];
	self.msgAttach = dic;
}

- (NSString *)fileRemoteUrl
{
	return self.msgBody;
}

- (void)downloadFile
{
	if (self.procState == IMMsgProcStateProcessing || self.fromType == IMMsgFromLocalSelf) {
		return;
	}
	
	if (self.procState == IMMsgProcStateSuc && [[NSFileManager defaultManager] fileExistsAtPath:self.fileLocalPath]) {
		return;
	}
	
	if (self.fileRemoteUrl == nil) {
		return;
	}
	
	self.procState = IMMsgProcStateProcessing;
	_fileDownloader = [[IMFileDownloader alloc]init];
	_fileDownloader.delegate = self;
	
	[_fileDownloader downloadWithFileURLstr:self.fileRemoteUrl savePath:self.fileLocalPath];
	
}

- (void)zhuanFaDownloadFile
{
    if (self.procState == IMMsgProcStateProcessing) {
        return;
    }
    
    if (self.procState == IMMsgProcStateSuc && [[NSFileManager defaultManager] fileExistsAtPath:self.fileLocalPath]) {
        return;
    }
    
    if (self.fileRemoteUrl == nil) {
        return;
    }
    if (self.fromType == IMMsgFromLocalSelf&&self.procState == IMMsgProcStateFaied) {
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.fileLocalPath]) {
            return;
        }
    }else{
        
        self.procState = IMMsgProcStateProcessing;
    }
    _fileDownloader = [[IMFileDownloader alloc]init];
    _fileDownloader.delegate = self;
    
    [_fileDownloader downloadWithFileURLstr:self.fileRemoteUrl savePath:self.fileLocalPath];
    
}


- (void)cancelDownload
{
	if (self.fromType != IMMsgFromLocalSelf) {
		[_fileDownloader cancelDownload];
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)filePostUrl
{
	return [IMConfiguration sharedInstance].configurator.fileUploadURL.absoluteString;
}

- (void)cancelUpload
{
	if (self.procState == IMMsgProcStateProcessing && self.fromType == IMMsgFromLocalSelf) {
		[_fileUploader cancelUpload];
		self.procState = IMMsgProcStateFaied;
        if([IMContext checkContextExist]){
            [[IMContext sharedContext].msgStorage updateMsgState:self];
        }
	}
}

- (void)uploadFile
{
	if ( self.fromType != IMMsgFromLocalSelf) {
		return;
	}
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.fileLocalPath]) {
		return;
	}
	
	self.procState = IMMsgProcStateProcessing;

	/////////////Custom
	NSDictionary *postDic = nil;
	
	BOOL isp2p = self.fromUser.userType & IMUserTypeP2P;
	NSString *postType = [[IMConfiguration sharedInstance].configurator msgPostType:self.msgType isp2p:isp2p thumbnail:NO];
	postDic = [NSDictionary dictionaryWithObject:postType forKey:@"type"];
	////////////
	
	_fileUploader = [[IMFileUploader alloc]init];
	_fileUploader.delegate = self;
	
	[_fileUploader uploadFile:self.fileLocalPath postURLStr:[self filePostUrl] postDic:postDic];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -DownLoad Delegate
- (void)imFileDownloaderDidStarted:(IMFileDownloader *)downloader
{
    if (self.fromType == IMMsgFromLocalSelf&&self.procState == IMMsgProcStateFaied) {
        return;
    }
	self.procState = IMMsgProcStateProcessing;
}

- (void)imFileDownloaderDidFinished:(IMFileDownloader *)downloader
{
    
    if (self.fromType == IMMsgFromLocalSelf&&self.procState == IMMsgProcStateFaied) {
        return;
    }
	self.procState = IMMsgProcStateSuc;
    if([IMContext checkContextExist]){
        [[IMContext sharedContext].msgStorage updateMsgState:self];
    }
//#warning add note
	[[NSNotificationCenter defaultCenter] postNotificationName:@"filedownloaderSuc" object:self];
	
	_fileUploader.delegate = nil;
	_fileDownloader = nil;
}

- (void)imFileDownloaderDidFailed:(IMFileDownloader *)downloader
{
	self.procState = IMMsgProcStateFaied;
    if([IMContext checkContextExist]){
        [[IMContext sharedContext].msgStorage updateMsgState:self];
    }
	_fileUploader.delegate = nil;
	_fileDownloader = nil;
}

- (void)imFileDownloader:(IMFileDownloader *)downloader processSize:(NSUInteger)proSize TotalSize:(NSUInteger)total
{
	self.procSize = proSize;
	self.totalSize = total;
}

- (void)imFileDownloader:(IMFileDownloader *)downloader procProgress:(CGFloat)progress
{
	self.progress = progress;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UpLoadDelegate
- (void)imFileUploaderDidStarted:(IMFileUploader *)uploader
{
	self.procState = IMMsgProcStateProcessing;
}

- (void)imFileUploaderDidFinished:(IMFileUploader *)uploader resp:(NSString *)resp
{
	NSDictionary *dic = [resp objectFromJSONString];
	if ([dic[@"ok"] integerValue] == 1) {
		self.msgBody = [IMCoreUtil  isHttp:dic[@"url"] ];
		self.procState = IMMsgProcStateSuc;
        if([IMContext checkContextExist]){
            
            [[IMContext sharedContext].msgStorage updateMsgState:self];
            [[IMContext sharedContext].msgStorage updateMsgBody:self];
        }
	}
	else {
		self.procState = IMMsgProcStateFaied;
        if([IMContext checkContextExist]){
            [[IMContext sharedContext].msgStorage updateMsgState:self];
        }
	}
	
	_fileUploader.delegate = nil;
	_fileUploader = nil;
	
}

- (void)imFileUploaderDidFailed:(IMFileUploader *)uploader
{
	self.procState = IMMsgProcStateFaied;
    if([IMContext checkContextExist]){
        [[IMContext sharedContext].msgStorage updateMsgState:self];
    }
	
	_fileUploader.delegate = nil;
	_fileUploader = nil;
}


- (void)imFileUploader:(IMFileUploader *)uploader processSize:(NSUInteger)proSize TotalSize:(NSUInteger)total
{
	self.procSize = proSize;
	self.totalSize = total;
}

- (void)imFileUploader:(IMFileUploader *)uploader procProgress:(CGFloat)progress
{
	self.progress = progress;
}
@end
