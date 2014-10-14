//
//  ATBLibs+UIBarItem.h
//  MakeStoryRoler
//
//  Created by HJC on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem(ATBLibsAddtions)


// info格式为title=Hello&action=Hello:
// type取值             done,plain或bordered，默认为bordered
// system,或sys取值为　  flexible,flex
+ (UIBarButtonItem *)buttonItemWithTarget:(id)target info:(NSString*)info;
+ (NSArray *)buttonItemsWithTarget:(id)target infos:(NSString*)info, ...;

/// 自定义导航栏item
+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg title:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithFrame:(CGRect)frame tag:(int)tag normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end
