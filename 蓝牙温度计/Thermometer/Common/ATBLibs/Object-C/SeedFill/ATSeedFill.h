//
//  ATSeedFill.h
//  PaintingBoard
//
//  Created by HJC on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#if defined(__cplusplus)
#define SEEDFILL_EXTERN extern "C"
#else
#define SEEDFILL_EXTERN extern
#endif


typedef struct
{
    unsigned short  y;
    unsigned short  xLeft;
    unsigned short  xRight;
} ATSeedFillSegment;



typedef struct
{
    CGRect              bounds;
    ATSeedFillSegment*  segments;
    unsigned int        numOfSegments;
} ATSeedFillOutput;




typedef struct
{
    unsigned int*   pixels;
    unsigned int    width;
    unsigned int    height;
    unsigned int    x;
    unsigned int    y;
    unsigned int    fillColor;
} ATSeedFillInput;



// 实现种子填充算法
SEEDFILL_EXTERN BOOL ATSeedFill(ATSeedFillOutput* ouput, const ATSeedFillInput* input);




