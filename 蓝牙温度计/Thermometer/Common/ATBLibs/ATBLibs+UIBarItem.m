//
//  ATBLibs+UIBarItem.m
//  MakeStoryRoler
//
//  Created by HJC on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+UIBarItem.h"

////////////////////////////

@implementation UIBarButtonItem(ATBLibsAddtions)



static NSDictionary* dictFromString(NSString* string)
{
    NSArray* array = [string componentsSeparatedByString:@"&"];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:[array count]];
    
    for (NSString* keyValue in array)
    {
        NSRange range = [keyValue rangeOfString:@"="];
        if (range.location == NSNotFound)
        {
            [dict setValue:@"" forKey:keyValue];
        }
        else
        {
            NSString* key = [keyValue substringToIndex:range.location];
            NSString* value = [keyValue substringFromIndex:range.location + range.length];
            [dict setValue:value forKey:key];
        }
    }
    return dict;
}



+ (UIBarButtonItem*) buttonItemWithTarget:(id)target info:(NSString*)info
{
    NSDictionary* dict = dictFromString(info);
    NSString* system = [dict objectForKey:@"system"];
    if (system == nil)
    {
        system = [dict objectForKey:@"sys"];
    }
    
    NSString* actionStr = [dict objectForKey:@"action"];
    SEL action = actionStr ? NSSelectorFromString(actionStr) : nil;
    if (system)
    {
        UIBarButtonSystemItem sysItem = UIBarButtonSystemItemFlexibleSpace;
        if ([system isEqualToString:@"flexible"] || [system isEqualToString:@"flex"])
        {
            sysItem = UIBarButtonSystemItemFlexibleSpace;
        }
        return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:sysItem
                                                              target:target
                                                              action:action];
    }
    else
    {
        NSString* title = [dict objectForKey:@"title"];
        UIBarButtonItemStyle itemStyle = UIBarButtonItemStyleBordered;
        NSString* styleStr = [dict objectForKey:@"style"];
        if (styleStr)
        {
            if ([styleStr isEqualToString:@"done"])
            {
                itemStyle = UIBarButtonItemStyleDone;
            }
            else if ([styleStr isEqualToString:@"plain"])
            {
                itemStyle = UIBarButtonItemStylePlain;
            }
            else if ([styleStr isEqualToString:@"bordered"])
            {
                itemStyle = UIBarButtonItemStyleBordered;
            }
        }
        
        
        return [[UIBarButtonItem alloc] initWithTitle:title
                                                 style:itemStyle
                                                target:target
                                                action:action];
        
    }
    return nil;
}




+ (NSArray*) buttonItemsWithTarget:(id)target infos:(NSString*)info, ...
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:1];
    
    va_list list;
    va_start(list, info);
    
    while (info)
    {
        UIBarButtonItem* buttonItem = [UIBarButtonItem buttonItemWithTarget:target info:info];
        [array addObject:buttonItem];
        info = va_arg(list, NSString*);
    }
    va_end(list);
    
    return [NSArray arrayWithArray:array];
}

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg target:(id)target action:(SEL)action
{
    return [self barButtonItemWithFrame:frame tag:8888 normalImg:normalImg highlightedImg:highlightedImg target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg target:(id)target action:(SEL)action
{
    return [self barButtonItemWithFrame:frame tag:tag normalImg:normalImg highlightedImg:highlightedImg title:nil target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg title:(NSString *)title target:(id)target action:(SEL)action
{
    return [self barButtonItemWithFrame:frame tag:tag normalImg:normalImg highlightedImg:highlightedImg title:title titleFont:SP15Font titleColor:[UIColor whiteColor] target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action
{
    UIButton *btn = InsertImageButtonWithTitle(nil, frame, tag, normalImg, highlightedImg, title, UIEdgeInsetsZero, titleFont, titleColor, target, action);
    
    // 调整点击范围扩大的问题
    UIView *backView = [[UIView alloc] initWithFrame:btn.bounds];
//    backView.bounds = CGRectOffset(backView.bounds, -5, 0);
    [backView addSubview:btn];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];

    return barButtonItem;
}

@end
