//
//  ZSDrawLineUIView.h
//  SunnyFace
//
//  Created by 龚 俊慧 on 12-12-29.
//  Copyright (c) 2012年 龚 俊慧. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DrawLinePostionType_Top,
    DrawLinePostionType_Bottom,
    DrawLinePostionType_Left,
    DrawLinePostionType_Right,
    
}DrawLinePostionType;

@interface DrawLineUIBtn : UIButton

- (void)addLineWithPosition:(DrawLinePostionType)position  lineColor:(UIColor *)lineColor lineWidth:(float)lineWidth;

@end
