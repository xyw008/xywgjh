//
//  ATStyledLabel.m
//  LearnPinyin
//
//  Created by HJC on 12-1-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATStyledLabel.h"
#import "ATBLibs+UIColor.h"


@class _StyledAttribute;
static NSArray* ParseStyledText(NSString* styledText, _StyledAttribute* initAttribute);


//////////////////////////////////////////////////////////////////
@interface _StyledAttribute : NSObject 
{
@private
    UIColor*    _color;
    UIFont*     _font;
}
@property (nonatomic, retain)   UIColor*    color;
@property (nonatomic, retain)   UIFont*     font;

- (id) copyMe;

@end



@implementation _StyledAttribute
@synthesize color = _color;
@synthesize font = _font;

- (void) dealloc
{
    [_color release];
    [_font release];
    [super dealloc];
}


- (id) copyMe
{
    _StyledAttribute* obj = [[[_StyledAttribute alloc] init] autorelease];
    obj.font = _font;
    obj.color = _color;
    return obj;
}

@end

//////////////////////////////////////////////

@interface _StyledFrament : NSObject 
{
@private
    NSString*           _text;
    UIColor*            _color;
    UIFont*             _font;
    CGSize              _size;
}
@property (nonatomic, copy)     NSString*           text;
@property (nonatomic, retain)   UIColor*            color;
@property (nonatomic, retain)   UIFont*             font;
@property (nonatomic, assign)   CGSize              size;


@end


@implementation _StyledFrament
@synthesize text = _text;
@synthesize font = _font;
@synthesize color = _color;
@synthesize size = _size;

- (void) dealloc
{
    [_text release];
    [_font release];
    [_color release];
    [super dealloc];
}


- (void) drawAtPoint:(CGPoint)pt inContext:(CGContextRef)context
{
    CGContextSetFillColorWithColor(context, _color.CGColor);
    CGRect rect = CGRectMake(pt.x, pt.y, _size.width, _size.height);
    [_text drawInRect:rect withFont:_font lineBreakMode:UILineBreakModeClip];
}

@end




////////////////////////////////////////////////////////////
@interface ATStyledLabel()
- (void) _parseStyledText;
@end



@implementation ATStyledLabel
@synthesize font = _font;
@synthesize styledText = _styledText;
@synthesize textColor = _textColor;
@synthesize textAlignment = _textAlignment;


- (void) dealloc
{
    [_textColor release];
    [_font release];
    [_styledText release];
    [_framents release];
    [super dealloc];
}



- (id) initWithStyledText:(NSString*)styledText font:(UIFont*)font
{
    self = [super init];
    if (self)
    {
        self.styledText = styledText;
        self.font = font;
        self.textColor = [UIColor blackColor];
        [self _parseStyledText];
        self.frame = CGRectMake(0, 0, _suiableSize.width, _suiableSize.height);
        self.backgroundColor = [UIColor whiteColor];
        _textAlignment = UITextAlignmentLeft;
    }
    return self;
}



- (id) init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _textAlignment = UITextAlignmentLeft;
    }
    return self;
}



- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _textAlignment = UITextAlignmentLeft;
    }
    return self;
}


- (void) setFont:(UIFont *)font
{
    if (_font != font)
    {
        [_font release];
        _font = [font retain];
        [_framents release];
        _framents = nil;
        [self setNeedsDisplay];
    }
}


- (void) setTextColor:(UIColor *)textColor
{
    if (_textColor != textColor)
    {
        [_textColor release];
        _textColor = [textColor retain];
        [_framents release];
        _framents = nil;
        [self setNeedsDisplay];
    }
}


- (void) setStyledText:(NSString *)styledText
{
    if (_styledText != styledText)
    {
        [_styledText release];
        _styledText = [styledText retain];
        [_framents release];
        _framents = nil;
        [self setNeedsDisplay];
    }
}


- (void) setTextAlignment:(UITextAlignment)textAlignment
{
    if (_textAlignment != textAlignment)
    {
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
    }
}



- (void) _parseStyledText
{
    _StyledAttribute* initAtt = [[[_StyledAttribute alloc] init] autorelease];
    initAtt.font = _font ? _font : [UIFont boldSystemFontOfSize:16];
    initAtt.color = self.textColor;
    
    NSArray* framents = ParseStyledText(self.styledText, initAtt);
    [_framents release];
    _framents = [framents retain];
    
    _suiableSize.width = 0;
    _suiableSize.height = 0;
    
    for (_StyledFrament* frament in _framents)
    {
        CGSize size = [frament.text sizeWithFont:frament.font];
        frament.size = size;
        _suiableSize.width += size.width;
        _suiableSize.height = MAX(size.height, _suiableSize.height);
    }
}


- (void) drawRect:(CGRect)rect
{
    if (_framents == nil && _styledText)
    {
        [self _parseStyledText];
    }
    
    CGFloat xpos = 0;
    if (_textAlignment == UITextAlignmentCenter)
    {
        xpos = (CGRectGetWidth(self.bounds) - _suiableSize.width) * 0.5;
        xpos = ceilf(xpos);
    }
    else if (_textAlignment == UITextAlignmentRight)
    {
        xpos = CGRectGetWidth(self.bounds) - _suiableSize.width; 
    }
    
    CGFloat ypos = (CGRectGetHeight(self.bounds) - _suiableSize.height) * 0.5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (_StyledFrament* frament in _framents)
    {
        [frament drawAtPoint:CGPointMake(xpos, ypos) inContext:context];
        xpos += frament.size.width;
    }
}



@end



///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////
typedef NSMutableArray  _AttributeStack;
inline static _AttributeStack*  New_Stack()
{
    return [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
}

inline static _StyledAttribute* Stack_Top(_AttributeStack* stack)
{
    return (_StyledAttribute*)[stack lastObject];
}

inline static void Stack_Push(_AttributeStack* stack, _StyledAttribute* obj)
{
    [stack addObject:obj];
}

inline static void Stack_Pop(_AttributeStack* stack)
{
    [stack removeLastObject];
}


static inline _StyledFrament* parseFrament(_AttributeStack* stack, NSString* text, BOOL needCheck)
{
    if (needCheck)
	{
		text = [text stringByReplacingOccurrencesOfString:@"\\{" withString:@"{"];
		text = [text stringByReplacingOccurrencesOfString:@"\\}" withString:@"}"];
		text = [text stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
	}
    
    _StyledAttribute* attribute = Stack_Top(stack);
	_StyledFrament* frament = [[[_StyledFrament alloc] init] autorelease];
    frament.text = text;
    frament.font = attribute.font;
    frament.color = attribute.color;
    return frament;
}



static void parseAttribute(_AttributeStack* stack, NSString* key, NSString* value)
{
    if ([key isEqualToString:@"push"])
    {
        _StyledAttribute* attribute = [Stack_Top(stack) copyMe];
        Stack_Push(stack, attribute);
    }
    else if ([key isEqualToString:@"pop"])
    {
        Stack_Pop(stack);
    }
    else if ([key isEqualToString:@"color"])
    {
        UIColor* color = [UIColor colorFromString:value];
        Stack_Top(stack).color = color;
    }
}



static void parseAttributes(_AttributeStack* stack, NSString* text)
{
    NSArray* array = [text componentsSeparatedByString:@";"];
    for (NSString* string in array)
    {
        NSString* key = string;
        NSString* value = nil;
        
        NSRange range = [string rangeOfString:@":"];
        if (range.location != NSNotFound)
        {
            key = [string substringToIndex:range.location];
            value = [string substringFromIndex:(range.location + range.length)];
        }
        
        key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        parseAttribute(stack, key, value);
    }
}



static NSArray* ParseStyledText(NSString* styledText, _StyledAttribute* initAttribute)
{
    NSMutableArray* framents = [NSMutableArray arrayWithCapacity:1];
    
    _AttributeStack* stack = New_Stack();
    Stack_Push(stack, initAttribute);
    
    NSInteger length = [styledText length];
    NSInteger savedIdex = 0;
	BOOL needCheck = NO;
    
    for (NSInteger scanIdx = 0 ; scanIdx < length; scanIdx++)
    {
        unichar c = [styledText characterAtIndex:scanIdx];
		if (c == '\\')
		{
			scanIdx++;
			c = [styledText characterAtIndex:scanIdx];
			if ( c == '\\' || c == '{' || c == '}')
			{
				needCheck = YES;
			}
		}
		else if (c == '{')
		{
			NSRange subRange = { savedIdex, scanIdx - savedIdex };
			if (subRange.length != 0)
			{
				NSString* subText = [styledText substringWithRange:subRange];
                _StyledFrament* frament = parseFrament(stack, subText, needCheck);
                [framents addObject:frament];
				needCheck = NO;
			}
			
			NSRange searchRange = { scanIdx, length - scanIdx };
			subRange = [styledText rangeOfString:@"}" options:0 range:searchRange];
			if (subRange.location != NSNotFound)
			{
				NSRange range = { scanIdx + 1, subRange.location - (scanIdx + 1)};
				NSString* subText = [styledText substringWithRange:range];
                parseAttributes(stack, subText);
				scanIdx = (subRange.location + subRange.length);
				savedIdex = scanIdx;
			}
			else
			{
				scanIdx = length - 1;
			}
		}
    }
    
    NSRange range = { savedIdex, length - savedIdex };
	if (range.length != 0)
	{
		NSString* subText = [styledText substringWithRange:range];
        _StyledFrament* frament = parseFrament(stack, subText, needCheck);
        [framents addObject:frament];
	}
    return framents;
}
