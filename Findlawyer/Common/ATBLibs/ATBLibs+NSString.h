//
//  ATBLibs+NSString.h
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"

@interface NSString(ATBLibsAddtions)


// 将字符串转成使用md5来编码
- (NSString*) stringByEncodingToMd5;


+ (NSString*) md5FromData:(NSData*)data;
+ (NSString*) md5FromBytes:(const void*)bytes length:(NSInteger)length;


// 生成全局唯一字符串
+ (NSString*) UUIDString;


// 将浮点数转成字符串,　会忽略小数点后面多余的0
+ (NSString*) stringWithFloat:(CGFloat)value;
+ (NSString*) stringWithInt:(NSInteger)value;


// 将形式为　key1=value1&key2=value2&key3=value3　的字符串和字典之间相互转换
+ (NSDictionary*) urlArgsDictionaryFromString:(NSString*)string;
+ (NSString*)     urlArgsStringFromDictionary:(NSDictionary*)dict;


- (NSString*) stringByAppendingMultPathComponents:(NSString*)path, ...;


- (NSString*) URLEncodedString;
- (NSString*) URLDecodedString;

//按照制定格式字符串转NSDate
+(NSDate *)dateFromString:(NSString *)string withFormatter:(NSString *)formatter;

// 替换html标签
- (NSString *)replaceHtmlTagsWithString:(NSString *)replacement;

// 替换javaScript标签
- (NSString *)replaceJavaScriptTagsWithString:(NSString *)replacement;

// 替换json格式里不能存在的特殊字符串
- (NSString *)replaceJsonTypeSpecialSymbolsWithString:(NSString *)replacement;

// 根据给定的限定宽度和字体大小,计算字符串的高度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;

// 计算指定字体大小，计算字符串的size
- (CGSize)stringSizeWithFont:(UIFont*)font;

@end





@interface NSString(ATBLibsAddtionsSuffixExpression)

// 将一个中缀表达式转成后缀表达式, 支持运算　+ - * /, 另外可以嵌套括号
// 比如　(1 + 2) * (34 * 55) --> 1  2 + 34 55 * *
+ (NSString*) suffixExpressionFromInfix:(NSString*)infix;

// 计算后缀表达式
+ (CGFloat) suffixExperssionCompute:(NSString*)suffix;
+ (CGFloat) suffixExperssionCompute:(NSString *)suffix block:(CGFloat(^)(NSString* token))block;

@end



