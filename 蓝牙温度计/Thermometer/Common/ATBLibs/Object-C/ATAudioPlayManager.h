//
//  ATAudioPlayManager.h
//  ChineseCharacters
//
//  Created by HJC on 11-6-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ATSingleton.h"



@class ATAudioPlayManager;
@protocol ATAudioPlayManagerDelegate<NSObject> 
@optional
- (void) audioPlayerManager:(ATAudioPlayManager*)manager finishPlayTag:(NSInteger)tag error:(NSError*)error;
@end




// 管理音频的播放, 封装了AVAudioPlayer
@interface ATAudioPlayManager : ATSingleton<AVAudioPlayerDelegate>
{    
@private    
    NSMutableDictionary* _audioPlaying;
}

+ (ATAudioPlayManager*)   shardManager;

- (AVAudioPlayer*) playAudioPath:(NSString*)audioPath;
- (AVAudioPlayer*) playAudioNamed:(NSString*)name;

// 代理是assign, 并非retain
- (AVAudioPlayer*) playAudioPath:(NSString *)audioPath delegate:(id)delegate tag:(NSInteger)tag;
- (AVAudioPlayer*) playAudioNamed:(NSString *)name delegate:(id)delegate tag:(NSInteger)tag;

// 停止声音
- (void) stopAudioDelegate:(id)delegate tag:(NSInteger)tag animation:(BOOL)animation;
- (void) stopAudioDelegate:(id)delegate tag:(NSInteger)tag;
- (void) stopAudioDelegate:(id)delegate;
- (void) stopAllAudio;

// 判断是否有声音
- (BOOL) hasAudioDelegate:(id)delegate;
- (BOOL) hasAudioDelegate:(id)delegate tag:(NSInteger)tag;


@end
