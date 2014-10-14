//
//  UpdataAppModel.h
//  zmt
//
//  Created by ygsoft on 13-8-25.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//网络请求头文件
#import "NetRequestManager.h"
#import "ASIFormDataRequest.h"

@interface UpdataAppModel : NSObject <ASIHTTPRequestDelegate,NetRequestDelegate,UIAlertViewDelegate>

+ (UpdataAppModel *)shareUpdataAppModel;

+ (void)updataAppVersion;

- (void)updateAppVersionWithAppID:(NSString *)appID;

@end
