//
//  ATSequenceImageView.m
//  LearnPinyin
//
//  Created by HJC on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATSequenceImageView.h"

@implementation ATSequenceImageView
@synthesize seqImages = _seqImages;
@synthesize seqInterval = _seqInterval;
@synthesize isSeqAnimating = _isSeqAnimating;
@synthesize seqRepeatCount = _seqRepeatCount;
@synthesize delegate = _delegate;


- (void) dealloc
{
    [[ATTimerManager shardManager] stopTimerDelegate:self];
//    [_seqImages release];
    if (_indices.bytes)
    {
        free(_indices.bytes);
    }
//    [super dealloc];
}



- (void) _resetFirstImage
{
    if (_indices.length != 0 && [_seqImages count] != 0)
    {
        UIImage* image = [_seqImages objectAtIndex:_indices.bytes[0]];
        self.image = image;
    }
}



- (id) initWithSeqImages:(NSArray*)images rules:(NSString*)rules
{
    self = [super init];
    if (self)
    {
        self.seqRules = rules;
        self.seqImages = images;
        [self _resetFirstImage];
        self.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    }
    return self;
}



- (void) setSeqRules:(NSString *)seqRules
{
    NSArray* array = [seqRules componentsSeparatedByString:@","];
    struct
    {
        int     index;
        int     count;
    } indices[[array count]];
    
    NSInteger realCount = 0;
    NSInteger totalFrame = 0;
    
    for (NSString* str in array)
    {
        NSInteger index = 0;
        NSInteger indexCount = 0;
        
        NSArray* tmp = [str componentsSeparatedByString:@"*"];
        if ([tmp count] == 1)
        {
            index = [[tmp objectAtIndex:0] intValue];
            indexCount = 1;
        }
        else 
        {
            index = [[tmp objectAtIndex:0] intValue];
            indexCount = [[tmp objectAtIndex:1] intValue];
        }
        
        if (index >= 0 && indexCount >= 1)
        {
            indices[realCount].index = index;
            indices[realCount].count = indexCount;
            realCount++;
            totalFrame += indexCount;
        }
    }
    
    _indices.bytes = realloc(_indices.bytes, totalFrame);
    _indices.length = totalFrame;
    
    unsigned char* bytesPtr = _indices.bytes;
    for (NSInteger idx = 0; idx < realCount; idx++)
    {
        memset(bytesPtr, indices[idx].index, indices[idx].count);
        bytesPtr += indices[idx].count;
    }
}



- (NSString*) seqRules
{
    if (_indices.bytes == nil || _indices.length == 0)
    {
        return nil;
    }
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:_indices.length];
    for (NSInteger idx = 0; idx < _indices.length; idx++)
    {
        NSString* str = [NSString stringWithFormat:@"%d", (int)_indices.bytes[idx]];
        [array addObject:str];
    }
    return [array componentsJoinedByString:@","];
}



- (void) startSeqAnimation
{
    if (!self.isSeqAnimating)
    {
        _isSeqAnimating = YES;
        [[ATTimerManager shardManager] addTimerDelegate:self interval:_seqInterval];
        _segFrameCount = 0;
        _seqRestCount = _seqRepeatCount;
        [self _resetFirstImage];
    }
}


- (void) stopSeqAnimation
{
    if (_isSeqAnimating)
    {
        _isSeqAnimating = NO;
        [[ATTimerManager shardManager] stopTimerDelegate:self];
        _seqRepeatCount = 0;
    }
}



- (void) timerManager:(ATTimerManager*)manager timerFireWithInfo:(ATTimerStepInfo)info
{
    if (_indices.length == 0 || [_seqImages count] == 0)
    {
        return;
    }
    
    unsigned char oldIndex = _indices.bytes[_segFrameCount];
    _segFrameCount++;
    if (_segFrameCount == _indices.length)
    {
        _segFrameCount = 0;
        if (_seqRepeatCount >= 0)
        {
            _seqRestCount--;
            if (_seqRestCount == 0)
            {
                [self stopSeqAnimation];
                if ([_delegate respondsToSelector:@selector(ATSequenceImageViewDidStopSeqAnimation:)])
                {
                    [_delegate ATSequenceImageViewDidStopSeqAnimation:self];
                }
                return;
            }
        }
    }
    
    unsigned char newIndex = _indices.bytes[_segFrameCount];
    if (oldIndex != newIndex)
    {
        if (newIndex < [_seqImages count])
            self.image = [_seqImages objectAtIndex:newIndex];
    }
}


@end
