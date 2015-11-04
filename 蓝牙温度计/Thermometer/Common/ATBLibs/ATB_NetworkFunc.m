//
//  NetworkFunc.m
//  used only above IOS 5.0 SDK
//
//  Created by gehaitong on 11-12-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_NetworkFunc.h"
#import <MobileCoreServices/MobileCoreServices.h>

BOOL IsValidIpAddress(const char *Str){
	int nPt = 0;
	int nCom = 0;
	int sIP = 0;
	
	for (int i=0; i<(int)strlen(Str); i++){
		if (Str[i] > '9' || Str[i] < '0'){
			if (Str[i] == '.'){
				nPt++;
				sIP = 0;
				//error
				if (nPt > 3) return NO;
			}else if (Str[i] == ':'){
				nCom++;
				sIP = 0;
				if (nPt != 3) return NO;
				if (nCom > 1) return NO;
			}else{
				return NO;
			}
		}else{
			if (0 == nCom){
				sIP*=10;
				sIP+=Str[i]-'0';
				if (sIP > 254) return NO;
			}else{
				sIP*=10;
				sIP+=Str[i]-'0';
				if (sIP > 99999) return NO;
			}
		}
	}
	return YES;
}

NSString *GetMIMEType(NSString *pExt){
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)pExt, NULL);
    
    CFStringRef MIMETYPE = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    
    return (__bridge __autoreleasing NSString*)MIMETYPE;
}

NSURLConnection *ConnectToURLAndGetData(NSString* path, id delegate){
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"GET"];
    
    return [[NSURLConnection alloc] initWithRequest:request delegate:delegate];
}


