//
//  RecorderManager.m
//  learnTest
//
//  Created by 龚 俊慧 on 13-7-22.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import "RecorderManager.h"
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "TPOscilloscopeLayer.h"
#import "lame.h"
//#import "VoiceConverter.h"

static RecorderManager *staticRecorderManager;

@interface RecorderManager ()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation RecorderManager

@synthesize audioController;
@synthesize recorder;
@synthesize player;
@synthesize HUD;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:YES];
        self.audioController.preferredBufferDuration = 0.005;
        [self.audioController start:NULL];
        
        //加HUD
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.HUD = [[MBProgressHUD alloc] initWithWindow:delegate.window];
        [self.HUD setMode:MBProgressHUDModeCustomView];
        
        //录音的音波显示视图
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        TPOscilloscopeLayer *outputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioController:self.audioController];
        outputOscilloscope.frame = customView.bounds;
        outputOscilloscope.lineColor = [UIColor yellowColor];
        [customView.layer addSublayer:outputOscilloscope];
        [self.audioController addOutputReceiver:outputOscilloscope];
        [outputOscilloscope start];
        
        TPOscilloscopeLayer *inputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioController:self.audioController];
        inputOscilloscope.frame = customView.bounds;
        inputOscilloscope.lineColor = [UIColor redColor];
        [customView.layer addSublayer:inputOscilloscope];
        [self.audioController addInputReceiver:inputOscilloscope];
        [inputOscilloscope start];
                
        self.HUD.customView = customView;
        [delegate.window addSubview:HUD];
    }
    return self;
}

- (void)dealloc
{
    if (self.player)
    {
        NSMutableArray *channelsToRemove = [NSMutableArray arrayWithObjects:self.player, nil];
        
        [self.audioController removeChannels:channelsToRemove];

        self.player = nil;
    }
    
    self.audioController = nil;
    self.recorder = nil;
    self.HUD = nil;
}

+ (RecorderManager *)shareRecorderManager
{
    if (!staticRecorderManager)
        staticRecorderManager = [[RecorderManager alloc] init];
    return staticRecorderManager;
}

- (void)recordAudioWithFilePath:(NSString *)filePath
{
    if (self.recorder)
    {
        [self.recorder finishRecording];
        [self.audioController removeOutputReceiver:self.recorder];
        [self.audioController removeInputReceiver:self.recorder];
        self.recorder = nil;
    }
    else
    {
        self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
        NSError *error = nil;
        if (![self.recorder beginRecordingToFileAtPath:filePath fileType:kAudioFileAIFFType error:&error] )
        {
            [[[UIAlertView alloc] initWithTitle:AlertTitle
                                         message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                        delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:Confirm, nil] show];
            self.recorder = nil;
            return;
        }
        
        [self.audioController addOutputReceiver:self.recorder];
        [self.audioController addInputReceiver:self.recorder];
        
        [self.HUD show:YES];
    }
}

- (void)stopRecordAudio
{
    if (self.recorder)
    {
        [self.recorder finishRecording];
        [self.audioController removeOutputReceiver:self.recorder];
        [self.audioController removeInputReceiver:self.recorder];
        self.recorder = nil;
        
        [self.HUD hide:YES afterDelay:0];
    }
}

- (NSTimeInterval)lengthOfAudioWithFilePath:(NSString *)filePath error:(NSError *)error
{
    AEAudioFilePlayer *audioPlayer = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:filePath] audioController:self.audioController error:&error];
    
    if (!audioPlayer)
        return 0.0;
    else
        return audioPlayer.duration;
}

- (void)playAudioWithFilePath:(NSString *)filePath
{
    if (self.player)
    {
        [self.audioController removeChannels:[NSArray arrayWithObject:self.player]];
        self.player = nil;
    }
    else
    {
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) return;
        
        NSError *error = nil;
        self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:filePath] audioController:self.audioController error:&error];
        
        if (!self.player)
        {
            [[[UIAlertView alloc] initWithTitle:AlertTitle
                                         message:[NSString stringWithFormat:@"无法播放此音频: %@", [error localizedDescription]]
                                        delegate:nil
                               cancelButtonTitle:nil
                               otherButtonTitles:Confirm, nil] show];
            return;
            /*
            [self audio_PCMtoMP3WithFilePaht:filePath];
             */
        }
        else
        {
            self.player.removeUponFinish = YES;
            self.player.completionBlock = ^{
                self.player = nil;
            };
            [self.audioController addChannels:[NSArray arrayWithObject:self.player]];
        }
    }
}

//android端上传的音频不能播放,要转成MP3格式才能播放
- (void)audio_PCMtoMP3WithFilePaht:(NSString *)filePath
{
    NSString *ExtensionStr = [filePath pathExtension];
    
    NSMutableString *mp3FilePath = [NSMutableString stringWithString:filePath];
    [mp3FilePath replaceOccurrencesOfString:ExtensionStr withString:@"mp3" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mp3FilePath.length)];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    //判断之前有没有转换过,如果有就直接播放
    if([fileManager fileExistsAtPath:mp3FilePath])
    {
        [self playAudioWithFilePath:mp3FilePath];
    }
    else
    {
        @try {
            int read, write;
            
            FILE *pcm = fopen([filePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);//44100.0,11025.0
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
        }
        @finally {
            /*
            [self performSelectorOnMainThread:@selector(convertMp3Finish) withObject:nil waitUntilDone:YES];
             */
            [self playAudioWithFilePath:mp3FilePath];
        }
    }
}

- (void)convertMp3Finish
{
    
}

- (void)stopPlayAudio
{
    if (self.player)
    {
        [self.audioController removeChannels:[NSArray arrayWithObject:self.player]];
        self.player = nil;
    }
}

@end
