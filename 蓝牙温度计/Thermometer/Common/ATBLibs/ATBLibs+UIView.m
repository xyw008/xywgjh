//
//  ATBLibs+UIView.m
//  ATBLibs
//
//  Created by HJC on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATBLibs+UIView.h"
#import "ATBLibs+NSString.h"
#import <QuartzCore/QuartzCore.h>


@implementation UIView(ATBLibsAddtions)


- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}


- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGSize)boundsSize 
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)newSize 
{
    self.bounds = CGRectMake(self.bounds.origin.x, 
                             self.bounds.origin.y,
                             newSize.width, 
                             newSize.height);
}


- (CGFloat) boundsHeight
{
    return self.bounds.size.height;
}

- (void) setBoundsHeight:(CGFloat)boundsHeight
{
    self.bounds = CGRectMake(self.bounds.origin.x, 
                             self.bounds.origin.y,
                             self.bounds.size.width, 
                             boundsHeight);
}



- (CGFloat) boundsWidth
{
    return self.bounds.size.width;
}

- (void) setBoundsWidth:(CGFloat)boundsWidth
{
    self.bounds = CGRectMake(self.bounds.origin.x, 
                             self.bounds.origin.y,
                             boundsWidth, 
                             self.bounds.size.height);
}



- (CGFloat) frameHeight
{
    return self.frame.size.height;
}

- (void) setFrameHeight:(CGFloat)frameHeight
{
    self.frame = CGRectMake(self.frame.origin.x, 
                            self.frame.origin.y,
                            self.frame.size.width, 
                            frameHeight);
}



- (CGFloat) frameWidth
{
    return self.frame.size.width;
}

- (void) setFrameWidth:(CGFloat)frameWidth
{
    self.frame = CGRectMake(self.frame.origin.x, 
                            self.frame.origin.y,
                            frameWidth, 
                            self.frame.size.height);
}


- (CGFloat)frameOriginX
{
    return self.frame.origin.x;
}

- (void)setFrameOriginX:(CGFloat)frameOriginX
{
    self.frame = CGRectMake(frameOriginX,
                            self.frame.origin.y,
                            self.frame.size.width,
                            self.frame.size.height);
}


- (CGFloat)frameOriginY
{
    return self.frame.origin.y;
}

- (void)setFrameOriginY:(CGFloat)frameOriginY
{
    self.frame = CGRectMake(self.frame.origin.x,
                            frameOriginY,
                            self.frame.size.width,
                            self.frame.size.height);
}



////////////////////////////////////////////////
- (id)  viewIsKindOf:(Class)cls recursive:(BOOL)recursive
{
    for (UIView* aView in self.subviews)
    {
        if ([aView isKindOfClass:cls])
        {
            return aView;
        }
    }
    
    if (recursive)
    {
        for (UIView* aView in self.subviews)
        {
            UIView* findView = [aView viewIsKindOf:cls recursive:YES];
            if (findView)
            {
                return findView;
            }
        }
    }
    return nil;
}


- (id)  viewWithTag:(NSInteger)tag recursive:(BOOL)recursive
{
    if (recursive)
    {
        return [self viewWithTag:tag];
    }
    
    for (UIView* aView in self.subviews)
    {
        if (aView.tag == tag)
        {
            return aView;
        }
    }
    return nil;
}



- (UIImage*) renderToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (id) loadFromNibNamed:(NSString*)name isKindOf:(Class)cls
{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:0];
    for (NSObject* object in array)
    {
        if ([object isKindOfClass:cls])
        {
            return object;
        }
    }
    return nil;
}


+ (id) loadFromNibNamed:(NSString*)name
{
    return [self loadFromNibNamed:name isKindOf:self];
}


+ (id) loadFromNib
{
    NSString* clsName = NSStringFromClass(self);
    return [self loadFromNibNamed:clsName isKindOf:self];
}



- (void) keepAutoresizingInMiddle
{
    self.autoresizingMask = 
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
}

- (void)keepAutoresizingInFull
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

+ (void) animateWithDuration:(NSTimeInterval)duration
                     options:(UIViewAnimationOptions)options 
                  animations:(void (^)(void))animations
{
    [self animateWithDuration:duration delay:0 options:options animations:animations completion:nil];
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    NSString *gestureDesc = [NSString stringWithFormat:@"%@-%@",NSStringFromClass([target class]),NSStringFromSelector(action)];
//    [tapGesture setValue:gestureDesc forUndefinedKey:@"gestureDesc"];
    [tapGesture setAccessibilityValue:gestureDesc];
    
    [self addGestureRecognizer:tapGesture];
}

- (void)removeGestureWithTarget:(id)target andAction:(SEL)action
{
    NSArray *gestures = self.gestureRecognizers;
    NSString *gestureDesc = [NSString stringWithFormat:@"%@-%@",NSStringFromClass([target class]),NSStringFromSelector(action)];
    
    [gestures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIGestureRecognizer *gesture = (UIGestureRecognizer *)obj;
        
//        NSString *desc = [gesture valueForUndefinedKey:@"gestureDesc"];
        NSString *desc = gesture.accessibilityValue;
        
        if (desc && [desc isKindOfClass:[NSString class]] && [desc isEqualToString:gestureDesc])
        {
            [self removeGestureRecognizer:gesture];
        }
    }];
}

- (void)addBorderToViewWitBorderColor:(UIColor *)borderColor borderWidth:(float)borderWidth
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)shadowWithShadowColor:(UIColor *)color shadowRadius:(float)radius shadowOffset:(CGSize)offset shadowOpacity:(float)opacity
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    self.layer.shadowPath = bezierPath.CGPath;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowRadius = radius;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
}

- (void)setRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

@end


//////////////////////////

@implementation UIViewController(ATBLibsAddtions)

+ (id) loadFromNibNamed:(NSString*)name
{
    return [[self alloc] initWithNibName:name bundle:nil];
}


+ (id) loadFromNib
{
    NSString* clsName = NSStringFromClass(self);
    return [[self alloc] initWithNibName:clsName bundle:nil];
}

@end



@implementation UILabel(ATBLibsAddtions)

- (id) initWithText:(NSString*)text font:(UIFont*)font
{
    self = [self initWithFrame:CGRectZero];
    if (self)
    {
        self.font = font;
        self.text = text;
        CGRect rt = [self textRectForBounds:CGRectMake(0, 0, FLT_MAX, FLT_MAX) 
                     limitedToNumberOfLines:1];
        self.frame = rt;
    }
    return self;
}

@end



@implementation UISegmentedControl(ATBLibsAddtions)

+ (UISegmentedControl*) barSegmentWithTitles:(NSString*)title, ...
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:1];
    va_list list;
    va_start(list, title);
    while (title)
    {
        [array addObject:title];
        title = va_arg(list, NSString*);
    }
    va_end(list);
    
    UISegmentedControl* segment = [[UISegmentedControl alloc] initWithItems:array];
    segment.selectedSegmentIndex = 0;
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    return segment;
}

@end



////////////////////////////////////////////////////////////////////////

CGFloat ATMaxWidthOfViews(NSArray* views)
{
    CGFloat maxWidth = 0;
    for (UIView* aView in views)
    {
        maxWidth = MAX(maxWidth, aView.frame.size.width);
    }
    return maxWidth;
}


CGFloat ATMaxHeightOfViews(NSArray* views)
{
    CGFloat maxHeight = 0;
    for (UIView* aView in views)
    {
        maxHeight = MAX(maxHeight, aView.frame.size.height);
    }
    return maxHeight;
}


CGFloat ATTotalWidthOfViews(NSArray* views)
{
    CGFloat totalWidth = 0;
    for (UIView* aView in views)
    {
        totalWidth += aView.frame.size.width;
    }
    return totalWidth;
}


CGFloat ATTotalHeightOfViews(NSArray* views)
{
    CGFloat totalHeight = 0;
    for (UIView* aView in views)
    {
        totalHeight += aView.frame.size.height;
    }
    return totalHeight;
}
