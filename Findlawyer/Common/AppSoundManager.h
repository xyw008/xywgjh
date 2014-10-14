//
//  AppSoundManager.h
//  PaintingBoard
//
//  Created by gnef_jp on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSoundManager : NSObject

+ (void) playBtnSound;


+ (void) playTabSelectSound;


+ (void) playRefreshSound;


+ (void) playPageSwitchSound;


+ (void) playWarningSound;


+ (void) playPaintingSoundWithPath:(NSString*)path;

@end
