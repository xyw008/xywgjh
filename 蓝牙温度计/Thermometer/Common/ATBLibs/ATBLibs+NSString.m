//
//  ATBLibs+NSString.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+NSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation  NSString(ATBLibsAddtions)


+ (NSString*) md5FromBytes:(const void*)bytes length:(NSInteger)length
{
	unsigned char result[16];
	CC_MD5(bytes, length, result);
	NSString *MD5Str = [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
    return [MD5Str lowercaseString];
}



- (NSString*) stringByEncodingToMd5
{
    const char *cStr = [self UTF8String];
    return [NSString md5FromBytes:cStr length:strlen(cStr)];
}



+ (NSString*) md5FromData:(NSData*)data
{
    return [self md5FromBytes:data.bytes length:data.length];
}



+ (NSString*) stringWithInt:(NSInteger)value
{
    return [NSString stringWithFormat:@"%d", value];
}


+ (NSString*) stringWithFloat:(CGFloat)value
{
    return [NSString stringWithFormat:@"%g", value];
}


+ (NSString*) UUIDString
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef uuidString = CFUUIDCreateString(NULL, theUUID);
	
	NSString* string = [NSString stringWithString:(__bridge NSString*)uuidString];
	
	CFRelease(theUUID);
	CFRelease(uuidString);
	
	return string;
}



+ (NSDictionary*) urlArgsDictionaryFromString:(NSString*)string
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



- (NSString *)URLEncodedString 
{
//    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                           (CFStringRef)self,
//                                                                           NULL,
//																		   CFSTR("!*'();:@&=+$,/?%#[]"),
//                                                                           kCFStringEncodingUTF8);
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
    
//    [result autorelease];
	return result;
}


- (NSString*)URLDecodedString
{
//	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
//																						   (CFStringRef)self,
//																						   CFSTR(""),
//																						   kCFStringEncodingUTF8);
    
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8));
//    [result autorelease];
	return result;
}



+ (NSString*)  urlArgsStringFromDictionary:(NSDictionary*)dict
{
    NSMutableArray* keyValues = [NSMutableArray arrayWithCapacity:[dict count]];
    for (NSString* key in dict)
    {
        NSString* value = [dict objectForKey:key];
        NSString* keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
        [keyValues addObject:keyValue];
    }
    return [keyValues componentsJoinedByString:@"&"];
}



- (NSString*) stringByAppendingMultPathComponents:(NSString*)path, ...
{
    va_list list;
    va_start(list, path);
    
    NSString* tmpPath = va_arg(list, NSString*);
    while (tmpPath)
    {
        path = [path stringByAppendingPathComponent:tmpPath];
        tmpPath = va_arg(list, NSString*);
    }
    
    va_end(list);
    
    return [self stringByAppendingPathComponent:path];
}

+ (NSDate *)dateFromString:(NSString *)string withFormatter:(NSString *)formatter
{
    if (!string || 0 == string.length || !formatter || 0 == formatter.length) return nil;
    
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:formatter];
    NSDate *date = [dateFormatter dateFromString:string];
    
    return date;
}

- (NSString *)replaceHtmlTagsWithString:(NSString *)replacement
{
    NSString *tempStr = [self stringByReplacingOccurrencesOfRegex:@"<[^>]+>" withString:replacement options:RKLNoOptions range:NSMakeRange(0, self.length) error:NULL];
    return [tempStr stringByReplacingOccurrencesOfRegex:@"<[^>]+" withString:replacement options:RKLNoOptions range:NSMakeRange(0, self.length) error:NULL];
}

- (NSString *)replaceJavaScriptTagsWithString:(NSString *)replacement
{
    NSString *tempStr = [self stringByReplacingOccurrencesOfRegex:@"<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>" withString:replacement options:RKLNoOptions range:NSMakeRange(0, self.length) error:NULL];
    return [tempStr stringByReplacingOccurrencesOfRegex:@"<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>" withString:replacement options:RKLNoOptions range:NSMakeRange(0, self.length) error:NULL];
}

- (NSString *)replaceJsonTypeSpecialSymbolsWithString:(NSString *)replacement
{
    NSString *tempStr = [self stringByReplacingOccurrencesOfString:@"\n" withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\b" withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\f" withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\r" withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
    return [tempStr stringByReplacingOccurrencesOfString:@"\t" withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGSize size = CGSizeZero;
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        // iOS7 methods
        CGRect strRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil];
        
        size = strRect.size;
    }
    else
    {
        // Pre-iOS7 methods
        size = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
    }
    
    return size;
}

- (CGSize)stringSizeWithFont:(UIFont*)font
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        return [self sizeWithAttributes:@{NSFontAttributeName : font}];
    }
    else
    {
        return [self sizeWithFont:font];
    }
}

@end



/////////////////////////////////////////////////////////////////


@interface ExpStackItem : NSObject 
{
@private
    NSString*   _str;
    NSInteger   _priority;
}
@property (nonatomic, assign)   NSInteger   priority;
@property (nonatomic, retain)   NSString*   str;

+ (ExpStackItem*) itemWithStr:(NSString*)str priority:(NSInteger)priority;

@end


@implementation ExpStackItem
@synthesize str = _str;
@synthesize priority = _priority;

- (void) dealloc
{
//    [_str release];
//    [super dealloc];
}


+ (ExpStackItem*) itemWithStr:(NSString*)str priority:(NSInteger)priority
{
//    ExpStackItem* item = [[[ExpStackItem alloc] init] autorelease];
    ExpStackItem* item = [[ExpStackItem alloc] init];
    item.priority = priority;
    item.str = str;
    return item;
}

@end




@implementation NSString(ATBLibsAddtionsSuffixExpression)


static NSString* _nextToken(NSString* infix, NSInteger* pIndex) 
{
    NSInteger beginIndex = *pIndex;
    NSInteger length = [infix length];
    
    if (beginIndex >= length)
    {
        return nil;
    }
    
    // 去掉前面的空格
    while (beginIndex < length)
    {
        unichar c = [infix characterAtIndex:beginIndex];
        if ((c != ' ') && (c != '\t'))
        {
            break;
        }
        beginIndex++;
    }
    
    NSInteger endIndex = beginIndex;
    for ( ; endIndex < length; endIndex++)
    {
        unichar c = [infix characterAtIndex:endIndex];
        if (c == ' ')
        {
            break;
        }
        else if (c == '+' || c == '-' || c == '*' || c == '/' || c == '(' || c == ')')
        {
            if (endIndex == beginIndex)
            {
                endIndex = endIndex + 1;
            }
            break;
        }
    }
    
    *pIndex = endIndex;
    if (endIndex > beginIndex)
    {
        NSRange range = NSMakeRange(beginIndex, endIndex - beginIndex);
        return [infix substringWithRange:range];
    }
    
    return nil;
}



static void _pushStack(NSMutableArray* stack, NSMutableArray* results, ExpStackItem* item)
{
    while ([stack count] > 0)
    {
        ExpStackItem* top = [stack lastObject];
        if (top.priority <= item.priority)
        {
            [results addObject:top.str];
            [stack removeLastObject];
        }
        else
        {
            break;
        }
    }
    [stack addObject:item];
}



static void _popStackLB(NSMutableArray* stack, NSMutableArray* results)
{
    while ([stack count] > 0)
    {
        ExpStackItem* item = [stack lastObject];
        if ([item.str isEqualToString:@"("])
        {
            [stack removeLastObject];
            break;
        }
        else
        {
            [results addObject:item.str];
            [stack removeLastObject];
        }
    }
}




+ (NSString*) suffixExpressionFromInfix:(NSString*)infix
{
    NSInteger index = 0;
    NSString* token = nil;
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray* stack = [NSMutableArray arrayWithCapacity:0];
    
    while ( (token = _nextToken(infix, &index)) != nil)
    {
        if ([token length] > 1)
        {
            [results addObject:token];
        }
        else 
        {
            unichar c = [token characterAtIndex:0];
            switch (c) 
            {
                case '(':
                    [stack addObject:[ExpStackItem itemWithStr:token priority:2]];
                    break;
                    
                case ')':
                    _popStackLB(stack, results);
                    break;
                    
                case '+':
                case '-':
                {
                    ExpStackItem* item = [ExpStackItem itemWithStr:token priority:1];
                    _pushStack(stack, results, item);
                }
                    break;
                    
                case '*':
                case '/':
                {
                    ExpStackItem* item = [ExpStackItem itemWithStr:token priority:0];
                    _pushStack(stack, results, item);
                }
                    break;
                    
                default:
                    [results addObject:token];
                    break;
            }
        }
    }
    
    _popStackLB(stack, results);
    return [results componentsJoinedByString:@" "];
}



static BOOL _stackCompute(NSMutableArray* stack, unichar c)
{
    if ([stack count] >= 2)
    {
        CGFloat v0 = [[stack lastObject] floatValue];
        [stack removeLastObject];
        CGFloat v1 = [[stack lastObject] floatValue];
        [stack removeLastObject];
        
        if (c == '-')
        {
            v0 = v1 - v0;
        }
        else if (c == '/')
        {
            v0 = v1 / v0;
        }
        else if (c == '*')
        {
            v0 = v1 * v0;
        }
        else if (c == '+')
        {
            v0 = v1 + v0;
        }
        [stack addObject:[NSNumber numberWithFloat:v0]];
        return YES;
    }
    return FALSE;
}



+ (CGFloat) suffixExperssionCompute:(NSString *)suffix block:(CGFloat(^)(NSString* str))block
{
    NSArray* tokens = [suffix componentsSeparatedByString:@" "];
    NSMutableArray* stack = [NSMutableArray arrayWithCapacity:2];
    
    for (NSString* token in tokens)
    {
        if ([token length] == 1)
        {
            unichar c = [token characterAtIndex:0];
            switch (c) 
            {
                case '*':
                case '-':
                case '+':
                case '/':
                    if (!_stackCompute(stack, c))
                    {
                        return 0.0;
                    }
                    break;
                    
                default:
                {
                    CGFloat value = block(token);
                    [stack addObject:[NSNumber numberWithFloat:value]];
                }
                    break;
            }
        }
        else
        {
            CGFloat value = block(token);
            [stack addObject:[NSNumber numberWithFloat:value]];
        }
    }
    
    if ([stack count] == 1)
    {
        return [[stack lastObject] floatValue];
    }
    return 0.0;
}




+ (CGFloat) suffixExperssionCompute:(NSString*)suffix
{
    return [self suffixExperssionCompute:suffix 
                                   block:^CGFloat(NSString* token)
            {
                return [token floatValue];
            }];
}


@end


