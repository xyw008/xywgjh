//
//  ECSignal.h
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Q_SIGNAL_APP_TERMINATE               @"Q_SIGNAL_APP_TERMINATE"
#define Q_SIGNAL_APP_BECOME_ACTIVE           @"Q_SIGNAL_APP_BECOME_ACTIVE"
#define Q_SIGNAL_APP_RESIGN_ACTIVE           @"Q_SIGNAL_APP_RESIGN_ACTIVE"
#define Q_SIGNAL_APP_ENTER_BACKGROUND        @"Q_SIGNAL_APP_ENTER_BACKGROUND"
#define Q_SIGNAL_APP_ENTER_FOREGROUND        @"Q_SIGNAL_APP_ENTER_FOREGROUND"

@interface QSignal : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *userInfo;


+ (QSignal *)signalWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;

@end
