//
//  TimerManager.m
//  LearnCharacters
//
//  Created by HJC on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATTimerManager.h"


@interface _ATTimerInfo : NSObject 
{
@private
    NSInteger                   _timerId;           //  定时器id
    NSInteger                   _tag;               //  用户创建定时器时传进来的tag
    NSTimeInterval              _totalTime;         //  当时器开始后，运行了的总时间
    NSTimeInterval              _lastTime;          //  上一次触发定时器的时间点
    NSTimeInterval              _remainNextTime;    //  下一次触发定时器剩下的时间
    NSTimeInterval              _theoryInterval;    //  定时器理论上的间隔
//    id<ATTimerManagerDelegate>  _delegate;          //  代理
    BOOL                        _fireEachStep;      //  是否最快的定时器，也就是每次都触发
}
@property (nonatomic, assign)   id<ATTimerManagerDelegate>  delegate;
@property (nonatomic, assign)   NSInteger                   timerId;
@property (nonatomic, assign)   NSInteger                   tag;
@property (nonatomic, assign)   NSTimeInterval              totalTime;
@property (nonatomic, assign)   NSTimeInterval              lastTime;
@property (nonatomic, assign)   NSTimeInterval              theoryInterval;
@property (nonatomic, assign)   NSTimeInterval              remainNextTime;
@property (nonatomic, assign)   BOOL                        fireEachStep;
@end



@implementation _ATTimerInfo
@synthesize delegate = _delegate;
@synthesize lastTime = _lastTime;
@synthesize totalTime = _totalTime;
@synthesize timerId = _timerId;
@synthesize fireEachStep = _fireEachStep;
@synthesize theoryInterval = _theoryInterval;
@synthesize remainNextTime = _remainNextTime;
@synthesize tag = _tag;
@end


//////////////////////////////////////////////////////////////


@implementation ATTimerManager
@synthesize isPausingAllTimers = _isPausingAllTimers;

static ATTimerManager* s_timerManager = nil;


+ (ATTimerManager*) shardManager
{
    [super generateInstanceIfNeed:&s_timerManager];
    return s_timerManager;
}


- (id) init
{
    self = [super init];
    if (self)
    {
        _timerInfos = [[NSMutableArray alloc] initWithCapacity:8];
    }
    return self;
}


- (void) dealloc
{
//    [_timerInfos release];
    [_timer invalidate];
//    [_timer release];
//    [super dealloc];
}



- (_ATTimerInfo*) _createTimerInfoWithDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag
{
    NSInteger timerId = ATInvalide_TimerId + 1;
    if ([_timerInfos count] > 0)
    {
        _ATTimerInfo* lastInfo = [_timerInfos lastObject];
        timerId = lastInfo.timerId + 1;
    }
    
    _ATTimerInfo* timerInfo = [[_ATTimerInfo alloc] init];
    timerInfo.timerId = timerId;
    timerInfo.delegate = delegate;
    timerInfo.tag = tag;
    timerInfo.totalTime = 0;
    timerInfo.lastTime = [[NSDate date] timeIntervalSince1970];
    
    return timerInfo;
}




- (void) _startPublicTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:1.0 / 60.0
                                          target:self
                                        selector:@selector(_timerStep)
                                        userInfo:nil
                                         repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}




- (NSInteger) addTimerDelegate:(id<ATTimerManagerDelegate>)delegate 
                      interval:(NSTimeInterval)interval
                           tag:(NSInteger)tag
{
    _ATTimerInfo* timerInfo = [self _createTimerInfoWithDelegate:delegate tag:tag];
    if (fabs(interval) < DBL_MIN)
    {
        timerInfo.fireEachStep = YES;
    }
    else
    {
        timerInfo.theoryInterval = interval;
        timerInfo.remainNextTime = interval;
    }
    [_timerInfos addObject:timerInfo];
    
    if (!_isPausingAllTimers)
    {
        [self _startPublicTimer];
    }
        
    return timerInfo.timerId;
}



- (NSInteger) addTimerDelegate:(id<ATTimerManagerDelegate>)delegate interval:(NSTimeInterval)interval
{
    return [self addTimerDelegate:delegate interval:interval tag:0];
}


- (NSInteger) addFastestTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag
{
    return [self addTimerDelegate:delegate interval:0.0f tag:tag];
}


- (NSInteger) addFastestTimerDelegate:(id<ATTimerManagerDelegate>)delegate
{
    return [self addTimerDelegate:delegate interval:0.0f tag:0];
}



- (void) _fireTimerInfo:(_ATTimerInfo*)info currentTime:(NSTimeInterval)currentTime
{
    ATTimerStepInfo stepInfo;
    stepInfo.timerId = info.timerId;
    stepInfo.tag = info.tag;
    stepInfo.stepTime = (currentTime - info.lastTime);
    stepInfo.totalTime = info.totalTime + stepInfo.stepTime;

    info.lastTime = currentTime;
    info.totalTime = stepInfo.totalTime;
    [info.delegate timerManager:self timerFireWithInfo:stepInfo];
}



- (void) _timerStep
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSArray* tmpTimerInfos = [NSArray arrayWithArray:_timerInfos];
    
    // 循环时候，用户有可能会使用stopTimerId函数，引起_timerInfos改变，所以这里用tmpTimerInfos遍历
    for (_ATTimerInfo* info in tmpTimerInfos)
    {
        if (info.fireEachStep)
        {
            [self _fireTimerInfo:info currentTime:currentTime];
        }
        else
        {
            NSTimeInterval divTime = currentTime - info.lastTime;
            if (divTime >= info.remainNextTime)
            {
                info.remainNextTime = (info.remainNextTime - divTime) + info.theoryInterval;
                if (info.remainNextTime < 0)
                {
                    info.remainNextTime = info.theoryInterval;
                }
                [self _fireTimerInfo:info currentTime:currentTime];
            }
        }
    }
}


- (void) stopTimerId:(NSInteger)timerId
{
    for (_ATTimerInfo* info in _timerInfos)
    {
        if (info.timerId == timerId)
        {
            [_timerInfos removeObject:info];
            break;
        }
    }
    
    if ([_timerInfos count] == 0)
    {
        [_timer invalidate];
//        [_timer release];
        _timer = nil;
    }
}


- (void) _stopTimerDelegate:(id<ATTimerManagerDelegate>)delegate onlyOne:(BOOL)onlyOne
{
    BOOL loop = YES;
    while (loop)
    {
        loop = NO;
        for (_ATTimerInfo* info in _timerInfos)
        {
            if (info.delegate == delegate)
            {
                [_timerInfos removeObject:info];
                loop = !onlyOne;
                break;
            }
        }
    }
    
    if ([_timerInfos count] == 0)
    {
        [_timer invalidate];
//        [_timer release];
        _timer = nil;
    }
}


- (void) stopTimerDelegate:(id<ATTimerManagerDelegate>)delegate
{
    [self _stopTimerDelegate:delegate onlyOne:NO];
}


- (void) stopTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag
{
    for (_ATTimerInfo* info in _timerInfos)
    {
        if (info.delegate == delegate && info.tag == tag)
        {
            [_timerInfos removeObject:info];
            break;
        }
    }
    
    if ([_timerInfos count] == 0)
    {
        [_timer invalidate];
//        [_timer release];
        _timer = nil;
    }
}


- (BOOL) hasTimerId:(NSInteger)timerId
{
    for (_ATTimerInfo* info in _timerInfos)
    {
        if (info.timerId == timerId)
        {
            return YES;
        }
    }
    return NO;
}



- (BOOL) hasTimerDelegate:(id<ATTimerManagerDelegate>)delegate
{
    for (_ATTimerInfo* info in _timerInfos)
    {
        if (info.delegate == delegate)
        {
            return YES;
        }
    }
    return NO;
}


- (BOOL) hasTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag
{
    for (_ATTimerInfo* info in _timerInfos)
    {
        if (info.delegate == delegate && info.tag == tag)
        {
            return YES;
        }
    }
    return NO;
}



- (void) pauseAllTimers
{
    _isPausingAllTimers = YES;
    if (_timer)
    {
        [_timer invalidate];
//        [_timer release];
        _timer = nil;
    }
}


- (void) resumeAllTimers
{
    if (_isPausingAllTimers)
    {
        _isPausingAllTimers = NO;
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        for (_ATTimerInfo* info in _timerInfos)
        {
            info.lastTime = currentTime;
        }
        
        if ([_timerInfos count] > 0)
        {
            [self _startPublicTimer];
        }
    }
}


@end
