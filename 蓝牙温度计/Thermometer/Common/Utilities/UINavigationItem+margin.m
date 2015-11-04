//
//  UIBarButtonItem+margin.m
//  zmt
//
//  Created by apple on 13-10-25.
//  Copyright (c) 2013年 com.ygsoft. All rights reserved.
//

#import "UINavigationItem+margin.h"

@implementation UINavigationItem (margin)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
//#if defined(__IPHONE_7_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    if (IOS7)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = _leftBarButtonItem.customView ? -10 : 0;
        
        if (_leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, _leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setLeftBarButtonItem:_leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    if (IOS7)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = _rightBarButtonItem .customView ? -10 : 0;
        
        if (_rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[negativeSeperator, _rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setRightBarButtonItem:_rightBarButtonItem animated:NO];
    }
}

#endif

@end
