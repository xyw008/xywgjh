//
//  TimerManager.h
//  LearnCharacters
//
//  Created by HJC on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATSingleton.h"


// 这个类，简化NSTimer的使用过程
// 调用timerIdAfterAddDelegate的函数，就可以监听回调的
// - (void) timerManager:(ATTimerManager*)manager timerFireWithInfo:(ATTimerStepInfo)info;
// 内部实现的时候，最多只生成一个NSTimer，也可以节约资源


#define ATInvalide_TimerId    0


/////////////////////////////////////
typedef struct 
{
    NSInteger       timerId;        // 定时器id
    NSInteger       tag;            // 定时器tag
    NSTimeInterval  totalTime;      // 定时器开始计算的总时间
    NSTimeInterval  stepTime;       // 跟上一次激发之后的时间间隔
} ATTimerStepInfo;



@class ATTimerManager;
@protocol ATTimerManagerDelegate <NSObject>
@required
- (void) timerManager:(ATTimerManager*)manager timerFireWithInfo:(ATTimerStepInfo)info;
@end



//////////////////////////////////////////
// 计时器管理, 最大不能超过每秒60帧
@interface ATTimerManager : ATSingleton 
{  
@private
    NSMutableArray* _timerInfos;
    NSTimer*        _timer;
    BOOL            _isPausingAllTimers;
}
@property (nonatomic, readonly) BOOL    isPausingAllTimers;    // 是否在暂停所有的定时器

+ (ATTimerManager*) shardManager;


// 注意，下面传进来的代理是 assign方式，并非retain
// 添加定时器, 返回ID, 之后可以使用这个ID停止定时器, 可以指定间隔秒数
- (NSInteger) addTimerDelegate:(id<ATTimerManagerDelegate>)delegate 
                      interval:(NSTimeInterval)interval
                           tag:(NSInteger)tag;

- (NSInteger) addTimerDelegate:(id<ATTimerManagerDelegate>)delegate 
                      interval:(NSTimeInterval)interval;


// 最短间隔的定时器，最短间隔为1/60秒
- (NSInteger) addFastestTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag;
- (NSInteger) addFastestTimerDelegate:(id<ATTimerManagerDelegate>)delegate;


// 判断是否已生成定时器
- (BOOL) hasTimerId:(NSInteger)timerId;
- (BOOL) hasTimerDelegate:(id<ATTimerManagerDelegate>)delegate;
- (BOOL) hasTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag;


// 停止定时器
- (void) stopTimerId:(NSInteger)timerId;
- (void) stopTimerDelegate:(id<ATTimerManagerDelegate>)delegate;
- (void) stopTimerDelegate:(id<ATTimerManagerDelegate>)delegate tag:(NSInteger)tag;


// 暂停, 回复所有定时器
- (void) pauseAllTimers;
- (void) resumeAllTimers;

@end
