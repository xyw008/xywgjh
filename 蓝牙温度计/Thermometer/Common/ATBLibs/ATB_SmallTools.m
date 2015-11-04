//
//  ATB_SmallTools.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_SmallTools.h"


void SafelyRelease(NSObject* p)
{
    if (p)
    {
//        [p release];
        p = nil;
    }
}


void SafelyRetain(NSObject** p, NSObject* rhs)
{
    if (*p != rhs)
    {
//        [*p release];
        *p = rhs;
//        *p = [rhs retain];
    }
}


void SafelyCopy(NSObject** p, NSObject* rhs)
{
    if (*p != rhs)
    {
//        [*p release];
        *p = [rhs copy];
    }
}
