//
//  ExamineVersionBC.h
//  o2o
//
//  Created by leo on 14-9-16.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successHandle) (id successInfoObj,BOOL hasNewVersion);
typedef void (^failedHandle)  (NSError *error);

@interface ExamineVersionBC : NSObject<NetRequestDelegate>

//是否有新版本
@property (nonatomic,assign,readonly)BOOL       hasNewVersion;

/**
 * 检测版本
 * 输入参数   是否自动显示提示
 */
- (void)ExamineVersionRequestAutoShowHUD:(BOOL)show SuccessHandle:(successHandle)success failedHandle:(failedHandle)failed ;

//现实提示升级的alert
- (void)showAlertChoiceUpdate;

@end
