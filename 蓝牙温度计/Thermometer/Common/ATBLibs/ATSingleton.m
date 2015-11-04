//
//  ATSingleton.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATSingleton.h"

@implementation ATSingleton


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


//- (id)retain 
//{
//    return self;
//}


//- (NSUInteger)retainCount 
//{
//    return UINT_MAX;  // denotes an object that cannot be released
//}


//- (void)release 
//{
//    //do nothing
//}


//- (id)autorelease 
//{
//    return self;
//}


+ (void)  generateInstanceIfNeed:(NSObject*__strong *)sharedInstance
{
    if (*sharedInstance == nil)
    {
        @synchronized(self)
        {
            if (*sharedInstance == nil)
            {
                *sharedInstance = [[self alloc] init];
            }
        }
    }
}

@end
