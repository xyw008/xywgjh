//
//  ATAudioPlayManager.m
//  ChineseCharacters
//
//  Created by HJC on 11-6-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATAudioPlayManager.h"



@interface _ATAudioPlayerInfo : NSObject 
{
@private
    AVAudioPlayer*                  _player;
    NSInteger                       _tag;
//    id<ATAudioPlayManagerDelegate>  _delegate;
}
@property (nonatomic, retain)   AVAudioPlayer*                  player;
@property (nonatomic, assign)   NSInteger                       tag;
@property (nonatomic, assign)   id<ATAudioPlayManagerDelegate>  delegate;
@end


@implementation _ATAudioPlayerInfo
@synthesize player = _player;
@synthesize tag = _tag;
@synthesize delegate = _delegate;

- (void) dealloc
{
//    [_player release];
//    [super dealloc];
}

@end


///////////////////////////////////////////////////////////////////////////


@implementation ATAudioPlayManager
static ATAudioPlayManager* s_audioPlayManager = nil;

+ (ATAudioPlayManager*)   shardManager
{
    [self generateInstanceIfNeed:&s_audioPlayManager];
    return s_audioPlayManager;
}


- (void) dealloc
{
//    [_audioPlaying release];
//    [super dealloc];
}



- (AVAudioPlayer*) playAudioPath:(NSString *)audioPath delegate:(id)delegate tag:(NSInteger)tag
{
    // 声音正在播放，直接返回
    _ATAudioPlayerInfo* audioInfo = [_audioPlaying objectForKey:audioPath];
    if (audioInfo)
    {
        return audioInfo.player;
    }
    
    NSURL *soundURL = [NSURL fileURLWithPath:audioPath];
    AVAudioPlayer* audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    if (audioPlayer == nil)
    {
        return nil;
    }
    audioPlayer.delegate = self;
    [audioPlayer play];
    
    // 加入正在播放的列表
    if (_audioPlaying == nil)
    {
        _audioPlaying = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    audioInfo = [[_ATAudioPlayerInfo alloc] init];
    audioInfo.player = audioPlayer;
    audioInfo.tag = tag;
    audioInfo.delegate = delegate;
    
    [_audioPlaying setObject:audioInfo forKey:audioPath];
    
    return audioPlayer;
}


- (AVAudioPlayer*) playAudioNamed:(NSString *)name delegate:(id)delegate tag:(NSInteger)tag
{
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
    return [self playAudioPath:path delegate:delegate tag:tag];
}


- (AVAudioPlayer*) playAudioPath:(NSString *)effectPath
{
    return [self playAudioPath:effectPath delegate:nil tag:0];
}


- (AVAudioPlayer*) playAudioNamed:(NSString*)name
{
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
    return [self playAudioPath:path delegate:nil tag:0];
}


- (void) _finishAudioPlayer:(AVAudioPlayer*)player error:(NSError*)error
{
    for(NSString *key in _audioPlaying)
	{
		_ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
		if(player == info.player)
		{
            if ([info.delegate respondsToSelector:@selector(audioPlayerManager:finishPlayTag:error:)])
            {
                [info.delegate audioPlayerManager:self finishPlayTag:info.tag error:error];
            }
			[_audioPlaying removeObjectForKey:key];
			break;
		}
	}
}


-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self _finishAudioPlayer:player error:nil];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self _finishAudioPlayer:player error:error];
}


- (void) stopAllAudio
{
    for (NSString* key in _audioPlaying)
    {
        _ATAudioPlayerInfo* info = [_audioPlaying objectForKey:key];
        [info.player stop];
    }
    [_audioPlaying removeAllObjects];
}


- (void) _stopAnimation:(NSDictionary*)userInfo
{
    NSInteger time = [[userInfo valueForKey:@"Time"] intValue];
    _ATAudioPlayerInfo *info = [userInfo objectForKey:@"PlayInfo"];
    NSString* key = [userInfo valueForKey:@"Key"];
    
    if (info != nil && key != nil)
    {
        if (time > 0)
        {
            info.player.volume = MIN(time * 0.1, info.player.volume);
            
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSString stringWithInt:(time - 1)], @"Time",
                                                                           info, @"PlayInfo",
                                                                            key, @"Key", nil];
            [self performSelector:@selector(_stopAnimation:)
                       withObject:dict
                       afterDelay:0.1];
        }
        else
        {
            [info.player stop];
            [_audioPlaying removeObjectForKey:key];
        }
    }
}


- (void) stopAudioDelegate:(id)delegate tag:(NSInteger)tag animation:(BOOL)animation
{
    for (NSString* key in _audioPlaying)
	{
		_ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
        if (info.delegate == delegate && info.tag == tag)
		{
            
            if (animation)
            {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:@"9", @"Time",
                                                                                info, @"PlayInfo",
                                                                                 key, @"Key", nil];
                [self performSelector:@selector(_stopAnimation:)
                           withObject:dict
                           afterDelay:0.1];
            }
            else
            {
                [info.player stop];
                [_audioPlaying removeObjectForKey:key];
            }
            
			break;
		}
	}
}


- (void) stopAudioDelegate:(id)delegate tag:(NSInteger)tag
{ 
    for (NSString* key in _audioPlaying)
	{
		_ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
        if (info.delegate == delegate && info.tag == tag)
		{
            [info.player stop];
			[_audioPlaying removeObjectForKey:key];
			break;
		}
	}
}


- (void) stopAudioDelegate:(id)delegate
{
    NSArray* keys = [_audioPlaying allKeys];
    for (NSString* key in keys)
    {
        _ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
        if (info.delegate == delegate)
		{
            [info.player stop];
			[_audioPlaying removeObjectForKey:key];
		}
    }
}


- (BOOL) hasAudioDelegate:(id)delegate
{
    for (NSString* key in _audioPlaying)
	{
		_ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
        if (info.delegate == delegate)
		{
            return YES;
		}
	}
    return NO;
}


- (BOOL) hasAudioDelegate:(id)delegate tag:(NSInteger)tag
{
    for (NSString* key in _audioPlaying)
	{
		_ATAudioPlayerInfo *info = [_audioPlaying objectForKey:key];
        if (info.delegate == delegate && info.tag == tag)
		{
            return YES;
		}
	}
    return NO;
}

@end
