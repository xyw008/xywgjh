//
//  AppSoundManager.m
//  PaintingBoard
//
//  Created by gnef_jp on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "ATAudioPlayManager.h"

#import "AppSoundManager.h"

#define kHomeBgMusicTag     1006
#define kPaintingSoundTag   1007

@implementation AppSoundManager

+ (void) playBtnSound
{
    [[ATAudioPlayManager shardManager] playAudioNamed:@"default_sound_btn.caf"];
}


+ (void) playTabSelectSound
{
    [[ATAudioPlayManager shardManager] playAudioNamed:@"default_sound_tab.aif"];
}


+ (void) playRefreshSound
{
    [[ATAudioPlayManager shardManager] playAudioNamed:@"default_sound_refresh.aif"];
}


+ (void) playPageSwitchSound
{
    [[ATAudioPlayManager shardManager] playAudioNamed:@"default_sound_page_switch.aif"];
}


+ (void) playWarningSound
{
    [[ATAudioPlayManager shardManager] playAudioNamed:@"default_sound_warning.aif"];
}


+ (void) playPaintingSoundWithPath:(NSString*)path
{
    [[ATAudioPlayManager shardManager] stopAudioDelegate:nil tag:kPaintingSoundTag animation:YES];
    [[ATAudioPlayManager shardManager] playAudioPath:path delegate:nil tag:kPaintingSoundTag];
}

@end
