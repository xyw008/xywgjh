//
//  QConstant.h
//  QFramework
//
//  Created by qinwenzhou on 13-7-25.
//  Copyright (c) 2013年 ec. All rights reserved.
//


#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif


// ARC
#if __has_feature(objc_arc)
// compiling with ARC
#else
// compiling without ARC
#endif


// Debug log
#define QLog(fmt, ...) NSLog((@"%s <Line %d> " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#define QDLog(fmt, ...) NSLog((@"%s <Line %d> " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define QDLog(log, ...)
#endif


// System
#define SYSTEM_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SYSTEM_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])
#define IS_RETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN40 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


// Screen
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define X(FRAME) (FRAME.origin.x)
#define Y(FRAME) (FRAME.origin.y)
#define W(FRAME) (FRAME.size.width)
#define H(FRAME) (FRAME.size.height)


// Color
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

