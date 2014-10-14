//
//  NetworkFunc.h
//  huangpu
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

BOOL IsValidIpAddress(const char *Str);
NSString *GetMIMEType(NSString *pExt);
NSURLConnection *ConnectToURLAndGetData(NSString* path, id delegate);

