//
//  CallBCManager.h
//  Find lawyer
//
//  Created by leo on 14-10-18.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MessageSendResultType_Cancelled,
    MessageSendResultType_Success,
    MessageSendResultType_Failed,
}MessageSendResultType;

typedef void (^CallBlock)(NSTimeInterval duration);
typedef void (^CallCancelBlock)(void);

typedef void (^MessageBloack)(MessageSendResultType type);

@interface CallAndMessageManager : NSObject


AS_SINGLETON(CallAndMessageManager)

/**
 *  打电话
 *
 *  @param number 电话号码
 *  @param call   通话
 *  @param cancel 取消通话回调
 */
+ (void)callNumber:(NSString*)number
              call:(CallBlock)call
        callCancel:(CallCancelBlock)cancel;


/**
 *  发短信
 *
 *  @param number 电话号码
 *  @param result 发短信结果block
 */
+ (void)sendMessageNumber:(NSString*)number resultBlock:(MessageBloack)result;


@end

