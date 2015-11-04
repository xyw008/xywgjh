//
//  ATSequenceImageView.h
//  LearnPinyin
//
//  Created by HJC on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATTimerManager.h"


@class ATSequenceImageView;
@protocol ATSequenceImageViewDelegate<NSObject>
@optional
- (void) ATSequenceImageViewDidStopSeqAnimation:(ATSequenceImageView*)seqView;
@end


/////////////////////////////////////////////////////////////////////
// 播放动画桢
@interface ATSequenceImageView : UIImageView<ATTimerManagerDelegate>
{
@public
    NSArray*                        _seqImages;
    CGFloat                         _seqInterval;
    NSInteger                       _segFrameCount;
    NSInteger                       _seqRepeatCount;
    NSInteger                       _seqRestCount;
    BOOL                            _isSeqAnimating;
//    id<ATSequenceImageViewDelegate> _delegate;
    struct
    {
        unsigned char*  bytes;
        unsigned int    length;
    } _indices;
}
@property (nonatomic, strong)   NSArray*    seqImages;      // 多张图片
@property (nonatomic, assign)   CGFloat     seqInterval;    // 每一桢的间隔
@property (nonatomic, assign)   NSInteger   seqRepeatCount; // 动画重复的次数, 为负数表示总是重复
@property (nonatomic, assign)   id          delegate;       // 代理
@property (nonatomic, readonly) BOOL        isSeqAnimating; // 是否在播放

// 图片的播放方式, 格式为 "1*50, 2 * 10, 1"
@property (nonatomic, copy)     NSString*   seqRules;   

- (id) initWithSeqImages:(NSArray*)images rules:(NSString*)rules;

- (void) startSeqAnimation;
- (void) stopSeqAnimation;


@end
