//
//  ATPinyinUtils.h
//  ATBLibs
//
//  Created by HJC on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(ATBPinyinAddtions)

// 为了快速的输入拼音, 这里定义了一种格式, 比如
// píng guǒ shù, 可以写成 pi2ng guo3 shu4, 字母后面加数字就表示对应的声调
// 经过下面函数可以还原对应的拼音字符
// 如果你本意是想输出 pi1ng 可以写成 pi/1ng, 加上转义字符\或/，可以表示字符的原来含义
+ (NSString*) pinyinFromQuickWriting:(NSString*)quickWriting;

@end

