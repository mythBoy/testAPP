//
//  QMAudioPlayer.m
//  IMSDK-OC
//
//  Created by haochongfeng on 2017/8/17.
//  Copyright © 2017年 HCF. All rights reserved.
//

#import "QMAudioPlayer.h"
#import "QMAudioAnimation.h"

@implementation QMAudioPlayer

static QMAudioPlayer * instance = nil;

+ (QMAudioPlayer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

//- (void)startAudioPlayer: (CustomMessage *)message withDelegate: (id)audioPlayerDelegate {
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive:YES error:nil];
//    
//    NSString *playUrl;
//    NSString *fileName;
//    if ([self existFile:message.message]) {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",message.message];
//        fileName = message.message;
//    }else if ([self existFile:[NSString stringWithFormat:@"%@", message._id]]) {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", message._id]];
//        fileName = message._id;
//    }else {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", message._id]];
//        fileName = message._id;
//        NSURL *fileUrl = [NSURL URLWithString:message.remoteFilePath];
//        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
//        
//        [data writeToFile:playUrl atomically:YES];
//    }
//    
//    NSURL *fileURL = [NSURL URLWithString:playUrl];
//    
//    if (self.player) {
//        if (self.player.isPlaying == YES && [self.fileName isEqualToString:fileName]) {
//            [[QMAudioAnimation sharedInstance] stopAudioAnimation];
//            [self.player stop];
//            return;
//        }
//    }
//    
//    self.fileName = fileName;
//    
//    NSError *playError = nil;
//    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playError];
//    audioPlayer.delegate = audioPlayerDelegate;
//    [audioPlayer prepareToPlay];
//    self.player = audioPlayer;
//    if (playError == nil) {
//        [self.player play];
//    }else {
//        
//    }
//}

- (void)startAudioPlayer:(NSString *)fileName withDelegate:(id)audioPlayerDelegate {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    NSString *playUrl = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",fileName];
//    NSString *fileName;
//    if ([self existFile:message.message]) {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",message.message];
//        fileName = message.message;
//    }else if ([self existFile:[NSString stringWithFormat:@"%@", message._id]]) {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", message._id]];
//        fileName = message._id;
//    }else {
//        playUrl = [NSString stringWithFormat:@"%@/%@/%@", NSHomeDirectory(), @"Documents", [NSString stringWithFormat:@"%@", message._id]];
//        fileName = message._id;
//        NSURL *fileUrl = [NSURL URLWithString:message.remoteFilePath];
//        NSData *data = [NSData dataWithContentsOfURL:fileUrl];
//        
//        [data writeToFile:playUrl atomically:YES];
//    }
    
    NSURL *fileURL = [NSURL URLWithString:playUrl];
    
    if (self.player) {
        if (self.player.isPlaying == YES && [self.fileName isEqualToString:fileName]) {
            [[QMAudioAnimation sharedInstance] stopAudioAnimation];
            [self.player stop];
            return;
        }
    }
    
    self.fileName = fileName;
    
    NSError *playError = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&playError];
    audioPlayer.delegate = audioPlayerDelegate;
    [audioPlayer prepareToPlay];
    self.player = audioPlayer;
    if (playError == nil) {
        [self.player play];
    }else {
        
    }
}

- (void)stopAudioPlayer {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
}

- (BOOL)isPlaying:(NSString *)fileName {
    if (self.player && [self.fileName isEqualToString:fileName]) {
        return self.player.isPlaying;
    }else {
        return NO;
    }
}
@end
