//
//  RecorderManager.h
//  learnTest
//
//  Created by 龚 俊慧 on 13-7-22.
//  Copyright (c) 2013年 龚 俊慧. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RecorderManager : NSObject


+ (RecorderManager *)shareRecorderManager;

- (void)recordAudioWithFilePath:(NSString *)filePath;

- (void)stopRecordAudio;

- (NSTimeInterval)lengthOfAudioWithFilePath:(NSString *)filePath error:(NSError *)error;

- (void)playAudioWithFilePath:(NSString *)filePath;

- (void)stopPlayAudio;

@end
