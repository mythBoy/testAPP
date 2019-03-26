//
//  IMFileMsg.h
//  IMClient
//
//  Created by pengjay on 13-7-12.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMMsg.h"
#import "IMFileDownloader.h"
#import "IMFileUploader.h"
@interface IMFileMsg : IMMsg <IMFileDownloaderDelegate, IMFileUploaderDelegate>
{
	IMFileDownloader *_fileDownloader;
	IMFileUploader *_fileUploader;
	NSString *_localPath;
}
@property (nonatomic) NSUInteger procSize;
@property (nonatomic) NSUInteger totalSize;
- (NSString *)fileLocalPath;
- (NSString *)filePostUrl;
- (NSString *)fileRemoteUrl;

- (void)setFileLocalPath:(NSString *)path;

- (void)downloadFile;
- (void)cancelDownload;

- (void)zhuanFaDownloadFile; // 转发下载

- (void)uploadFile;
- (void)cancelUpload;
- (void)cancelProcessing;
@end
