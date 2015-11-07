//
//  RegisterBC.h
//  o2o
//
//  Created by swift on 14-8-5.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetRequestManager.h"

typedef void (^successHandle) (id successInfoObj);
typedef void (^failedHandle)  (NSError *error);

@interface RegisterBC : NSObject <NetRequestDelegate>

/// 获取验证码
- (void)getVerificationCodeWithMobilePhoneNumber:(NSString *)phoneNumber
                                   successHandle:(successHandle)success
                                    failedHandle:(failedHandle)failed;

/// 手机注册
- (void)registerWithMobilePhoneUserName:(NSString *)userName
                               password:(NSString *)password
                        passwordConfirm:(NSString *)passwordConfirm
                       verificationCode:(NSString *)verificationCode
                          successHandle:(successHandle)success
                           failedHandle:(failedHandle)failed;

/// 邮箱注册
- (void)registerWithEmailUserName:(NSString *)userName
                         password:(NSString *)password
                  passwordConfirm:(NSString *)passwordConfirm
                    successHandle:(successHandle)success
                     failedHandle:(failedHandle)failed;

/// 普通用户名注册
- (void)registerWithNormalUserName:(NSString *)userName
                          password:(NSString *)password
                   passwordConfirm:(NSString *)passwordConfirm
                     successHandle:(successHandle)success
                      failedHandle:(failedHandle)failed;

@end
