//
//  TemperatureRecordTabHeaderView.h
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/15.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "ParallaxHeaderView.h"

@class TemperatureRecordTabHeaderView;

typedef NS_ENUM(NSInteger, HeaderViewOperationType)
{
    /// 上一个日期
    HeaderViewOperationType_DatePre = 0,
    /// 下一个日期
    HeaderViewOperationType_DateNext,
};

typedef void (^HeaderViewOperationHandle) (TemperatureRecordTabHeaderView *view,
                                           HeaderViewOperationType type);

@interface TemperatureRecordTabHeaderView : ParallaxHeaderView

@property (nonatomic, copy) HeaderViewOperationHandle operationHandle;

@end
