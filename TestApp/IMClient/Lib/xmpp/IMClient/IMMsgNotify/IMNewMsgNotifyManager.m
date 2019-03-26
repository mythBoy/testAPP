//
//  IMNewMsgNotifyManager.m
//  IMClient
//
//  Created by pengjay on 13-7-18.
//  Copyright (c) 2013年 pengjay.cn@gmail.com. All rights reserved.
//

#import "IMNewMsgNotifyManager.h"
#import "IMConfiguration.h"
#import "IMDefaultConfigurator.h"
#import "IMMsgQueueManager.h"
#import "IMUser.h"
#import "IMMsg.h"
@implementation IMNewMsgNotifyManager

- (instancetype)initWithMsgQueueMgr:(IMMsgQueueManager *)msgQueueMgr
{
	self = [super init];
	if (self) {
		_msgQueueMgr = msgQueueMgr;
		[[self class] ambientAudioSession];
		
		NSURL *comeinSound   = [IMConfiguration sharedInstance].configurator.alertSoundURLForNewMsg;
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)comeinSound, &newmsgTintObject);
	}
	return self;
}

- (void)dealloc
{
	AudioServicesDisposeSystemSoundID(newmsgTintObject);
//	[_newMsgTintPlayer stop];
}

+ (void)playrecordAudioSession
{
	AVAudioSession *session = [AVAudioSession sharedInstance];
	[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	UInt32 doChangeDefaultRoute = 1;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
	[session setActive:YES error:nil];
}

+ (void)inActiveAudioSession
{
	AVAudioSession *session = [AVAudioSession sharedInstance];
	if ([[UIDevice currentDevice].systemVersion floatValue] > 5.9) {
		[session setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
	}
	else {
		[session setActive:NO error:nil];
	}
	
}

+ (void)ambientAudioSession
{
	AVAudioSession *session = [AVAudioSession sharedInstance];
	[session setCategory:AVAudioSessionCategoryAmbient error:nil];
}

- (void)deliverMsg:(IMMsg *)msg
{
	if ([_msgQueueMgr msgQueueActiving:msg.fromUser])
		return;
	
	if (msg.fromType != IMMsgFromOther) {
		return;
	}
	
	if (!(msg.fromUser.userType & IMUserTypeP2P)) {
		return;
	}
	
//	if (_newMsgTintPlayer == nil) {
//		_newMsgTintPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[IMConfiguration sharedInstance].configurator.alertSoundURLForNewMsg
//																  error:nil];
//	}
	
	BOOL playSound = [[IMConfiguration sharedInstance].configurator shouldAlertNewMsgIn];
	BOOL playVibrate = [[IMConfiguration sharedInstance].configurator shouldVibrateNewMsgIn];
	
//	if (playSound && !_newMsgTintPlayer.isPlaying && _msgQueueMgr.isQueueRecording == NO) {
//		[_newMsgTintPlayer play];
//	}
	static time_t lastPlayTime = 0;
	time_t n = time(NULL);
	if (n - lastPlayTime < 2) {
		return;
	}
	lastPlayTime = n;
	if (playSound && _msgQueueMgr.isQueueRecording == NO) {
		AudioServicesPlaySystemSound(newmsgTintObject);
	}
	
	if (playVibrate) {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
}

@end
