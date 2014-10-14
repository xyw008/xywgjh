//
//  ATB_Math.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATB_Math.h"


inline static void _swapInt(NSInteger* a, NSInteger* b)
{
    NSInteger tmp = *a;
    *a = *b;
    *b = tmp;
}


static void _diffRandIntsLess(NSInteger* result, NSInteger count, NSInteger min, NSInteger max)
{
    NSInteger len = max - min;
    for (NSInteger idx = 0; idx < count; idx++)
    {
        NSInteger randNum = rand() % len + min;
        BOOL needRetry = TRUE;
        while (needRetry)
        {
            needRetry = FALSE;
            for (NSInteger j = 0; j < idx; j++)
            {
                if (result[j] == randNum)
                {
                    needRetry = TRUE;
                    randNum = rand() % len + min;
                    break;
                }
            }
        }
        result[idx] = randNum;
    }
}



static void _diffRandIntMuch(NSInteger* result, NSInteger count, NSInteger min, NSInteger max)
{
    NSInteger len = max - min;
    NSInteger numbers[len];
    
    for (NSInteger idx = 0; idx < len; idx++)
    {
        numbers[idx] = min + idx;
    }
    
    for (NSInteger idx = 0; idx < count; idx++)
    {
        NSInteger tmp = rand() % len;
        _swapInt(&numbers[tmp], &numbers[idx]);
    }
    
    for (NSInteger idx = 0; idx < count; idx++)
    {
        result[idx] = numbers[idx];
    }
}



extern BOOL ATDiffRandInts(NSInteger* result, NSInteger count, NSInteger min, NSInteger max)
{
    NSInteger len = max - min;
    if (len < count)
    {
        return FALSE;
    }
    
    if (count * 3 < len)
    {
        _diffRandIntsLess(result, count, min, max);
    }
    else
    {
        _diffRandIntMuch(result, count, min, max);
    }
    return TRUE;
}
