//
//  AppPropertiesInitialize.h
//  o2o
//
//  Created by swift on 14-7-22.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkStatusManager.h"
#import "IQKeyboardManager.h"
#import "LanguagesManager.h"
#import "CoreData+MagicalRecord.h"
#import "UIFactory.h"

@interface AppPropertiesInitialize : NSObject

/**
 @ 方法描述    进行应用程序一系列属性的初始化设置
 @ 输入参数    无
 @ 返回值      void
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-22
 */
+ (void)startAppPropertiesInitialize;


/**
 @ 方法描述    对键盘事件进行设置取消or开启
 @ 输入参数    是否取消
 @ 返回值      void
 @ 创建人      熊耀文
 @ 创建时间    2014-09-24
 */
+ (void)setKeyboardManagerEnable:(BOOL)enable;

@end
