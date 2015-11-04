//
//  ATPinyinUtils.m
//  ATBLibs
//
//  Created by HJC on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATPinyin+NSString.h"

typedef struct
{
    unichar tone[4];
} s_pinyinTone;

// 这个表格要按照字母顺序, 表示对应字母的四个声调的写法
static s_pinyinTone s_pinyinTable[26] = {
    { 257, 225, 462, 224 }, // a
    { 'b', 'b', 'b', 'b' },
    { 'c', 'c', 'c', 'c' },
    { 'd', 'd', 'd', 'd' },
    { 275, 233, 283, 232 }, // e
    { 'f', 'f', 'f', 'f' },
    { 'g', 'g', 'g', 'g' },
    { 'h', 'h', 'h', 'h' },
    { 299, 237, 464, 236 }, // i
    { 'j', 'j', 'j', 'j' },
    { 'k', 'k', 'k', 'k' },
    { 'l', 'l', 'l', 'l' },
    { 'm', 'm', 'm', 'm' },
    { 'n', 'n', 'n', 'n' },
    { 333, 243, 466, 242 }, // o
    { 'p', 'p', 'p', 'p' },
    { 'q', 'q', 'q', 'q' },
    { 'r', 'r', 'r', 'r' },
    { 's', 's', 's', 's' },
    { 't', 't', 't', 't' },
    { 363, 250, 468, 249 }, // u
    { 470, 472, 474, 476 }, // v
    { 'w', 'w', 'w', 'w' },
    { 'x', 'x', 'x', 'x' },
    { 'y', 'y', 'y', 'y' },
    { 'z', 'z', 'z', 'z' },
};



@implementation NSString(ATBPinyinAddtions)


+ (NSString*) pinyinFromQuickWriting:(NSString*) quickWriting
{
    NSInteger length = [quickWriting length];
    unichar   result[length];   // 最终结果不可能比length还长, 这里不会溢出
    int       numResult = 0;
    
    for (int idx = 0; idx < length; idx++)
    {
        unichar c = [quickWriting characterAtIndex:idx];
        // 是字母，需要检查
        if (c >= 'a' && c <= 'z' && (idx + 1 < length))
        {
            // 向前看一个字符，如果是数字就表示声调
            unichar c1 = [quickWriting characterAtIndex:idx + 1];
            if (c1 >= '0' && c1 <= '9')
            {
                idx++;
                int toneIdx = c1 - '1';
                // 要转换成对应的声调
                if (toneIdx >= 0 && toneIdx < 4)
                {
                    int tableIdx = (c - 'a');
                    c = s_pinyinTable[tableIdx].tone[toneIdx];
                }
            }
        }
        
        // v对应一韵母
        if (c == 'v')
        {
            c = 252;
        }
        
        // 如果是\开头，直接转换为\后面的字符，比如\v为v, \\还是'\'
        // 这是防止字母后面跟着数字写不出来
        if ((c == '\\' || c == '/') && (idx + 1 < length))
        {
            idx++;
            c = [quickWriting characterAtIndex:idx];
        }
        
        result[numResult++] = c;
    }
    
    return [NSString stringWithCharacters:result length:numResult];
}


@end
