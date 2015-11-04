//
//  KeepLoginSessionConnection.h
//  financialCommunity
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 fanyixing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    // 后台
    KeepLoginSessionConnectionType_Background,
    // 前台
    KeepLoginSessionConnectionType_Foreground,
    
}KeepLoginSessionConnectionType;

@interface KeepLoginSessionConnection : NSObject

/**
 * 方法描述: 单例模式
 * 输入参数: 无
 * 返回值: 单例对象
 * 创建人: 龚俊慧
 * 创建时间: 2014-05-19
 */
AS_SINGLETON(KeepLoginSessionConnection);

/**
 * 方法描述: 保持登录会话在线
 * 输入参数: 运行类型
 * 返回值: VIOD
 * 创建人: 龚俊慧
 * 创建时间: 2014-05-19
 */
- (void)keepLoginSessionConnectionWithType:(KeepLoginSessionConnectionType)type;

/// 开始后台运行
- (void)runInBackground;

/// 停止后台运行
- (void)stopInBackground;

@end
