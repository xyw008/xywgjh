//
//  ATLayout+UIView.m
//  UITest
//
//  Created by  on 12-2-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATLayout+UIView.h"


static CGFloat _MaxWidth(NSArray* views)
{
    CGFloat maxWidth = 0;
    for (UIView* aView in views)
    {
        maxWidth = MAX(maxWidth, aView.frame.size.width);
    }
    return maxWidth;
}


static CGFloat _MaxHeight(NSArray* views)
{
    CGFloat maxHeight = 0;
    for (UIView* aView in views)
    {
        maxHeight = MAX(maxHeight, aView.frame.size.height);
    }
    return maxHeight;
}


static CGFloat _TotalWidth(NSArray* views)
{
    CGFloat totalWidth = 0;
    for (UIView* aView in views)
    {
        totalWidth += aView.frame.size.width;
    }
    return totalWidth;
}


static CGFloat _TotalHeight(NSArray* views)
{
    CGFloat totalHeight = 0;
    for (UIView* aView in views)
    {
        totalHeight += aView.frame.size.height;
    }
    return totalHeight;
}


static inline void ArrayReplace(float* begin, float* end, float oldValue, float newValue)
{
    for (float* ptr = begin; ptr != end; ptr++)
    {
        if (*ptr == oldValue)
        {
            *ptr = newValue;
        }
    }
}


static inline void ArrayFill(float* begin, float* end, float value)
{
    for (float* ptr = begin; ptr != end; ptr++)
    {
        *ptr = value;
    }
}


static inline void SetViewFrameOrigin(UIView* aView, CGPoint origin)
{
    CGRect rt = aView.frame;
    rt.origin.x = ceilf(origin.x);
    rt.origin.y = ceilf(origin.y);
    aView.frame = rt;
}


static inline NSString* TrimmingSpaces(NSString* text)
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}



ATLayoutInfo ATLayoutInfoZero = { {0, 0, 0, 0}, NULL , NULL, FALSE, FALSE };


typedef enum
{
    ATLocX_Center,
    ATLocX_Left,
    ATLocX_Right,
} ATLocXType;


typedef enum
{
    ATLocY_Center,
    ATLocY_Top,
    ATLocY_Bottom,
} ATLocYType;


typedef struct
{
    ATLocXType  x;
    ATLocYType  y;
} ATLocation;




/////////////////////////////
static ATLocation ParseLocation(NSString* text);

static CGPoint BeginPos(CGSize parentSize, CGSize size, UIEdgeInsets edge, ATLocation loc);
static CGPoint Offset(CGSize parentSize, CGSize size, ATLocation loc);
static CGFloat OffsetY(CGFloat totalHeight, CGFloat height, ATLocYType type);
static CGFloat OffsetX(CGFloat totalWidth, CGFloat width, ATLocXType type);

static CGFloat FillSpaces(CGFloat* spaces, 
                          NSInteger count, 
                          CGFloat totalSpace, 
                          ATLayoutInfo* layoutInfo);




//////////////////////////////////////////////////////////////////////

@implementation UIView(ATLayoutAddtions)


- (void) layoutSubview:(UIView*)aView withInfo:(ATLayoutInfo*)info
{   
    if (info == NULL)
    {
        return;
    }
    
    ATLocation location = ParseLocation(info->location);
    CGPoint pos = BeginPos(self.bounds.size, aView.frame.size, info->edge, location);
    SetViewFrameOrigin(aView, pos);
}


- (void) _vspaceSubViews:(NSArray*)views withInfo:(ATLayoutInfo*)info
{
    CGFloat contentHeight = self.bounds.size.height - info->edge.top - info->edge.bottom;
    CGSize totalSize = CGSizeMake(_MaxWidth(views), _TotalHeight(views));
    NSInteger spaceCount = [views count] - 1;
    CGFloat spaces[spaceCount + 1];
    
    CGFloat totalSpaceWidth = FillSpaces(spaces, spaceCount, 
                                         contentHeight - totalSize.height, 
                                         info);
    totalSize.height += totalSpaceWidth;
    
    ATLocation loc = ParseLocation(info->location);
    CGPoint pos = BeginPos(self.bounds.size, totalSize, info->edge, loc);
    
    NSInteger aViewIndex = 0;
    for (UIView* aView in views)
    {
        CGPoint tmpPos = pos;
        tmpPos.x += OffsetX(totalSize.width, aView.frame.size.width, loc.x);
        SetViewFrameOrigin(aView, tmpPos);
        pos.y += aView.frame.size.height + spaces[aViewIndex++];
    }
}


- (void) _hspaceSubViews:(NSArray*)views withInfo:(ATLayoutInfo*)info
{
    CGFloat contentWidth = self.bounds.size.width - info->edge.left - info->edge.right;
    CGSize totalSize = CGSizeMake(_TotalWidth(views), _MaxHeight(views));
    NSInteger spaceCount = [views count] - 1;
    CGFloat spaces[spaceCount + 1];
    
    CGFloat totalSpaceWidth = FillSpaces(spaces, spaceCount, 
                                         contentWidth - totalSize.width, 
                                         info);
    totalSize.width += totalSpaceWidth;
    
    ATLocation loc = ParseLocation(info->location);
    CGPoint pos = BeginPos(self.bounds.size, totalSize, info->edge, loc);
    
    NSInteger aViewIndex = 0;
    for (UIView* aView in views)
    {
        CGPoint tmpPos = pos;
        tmpPos.y += OffsetY(totalSize.height, aView.frame.size.height, loc.y);
        SetViewFrameOrigin(aView, tmpPos);
        pos.x += aView.frame.size.width + spaces[aViewIndex++];
    }
}



- (void) _hgridSubViews:(NSArray*)views withInfo:(ATLayoutInfo*)info
{
    CGFloat contentWidth = self.bounds.size.width - info->edge.left - info->edge.right;
    CGSize totalSize = CGSizeMake(contentWidth, _MaxHeight(views));
    
    ATLocation loc = ParseLocation(info->location);
    CGPoint pos = BeginPos(self.bounds.size, totalSize, info->edge, loc);
    
    CGSize eachSize = CGSizeMake(contentWidth / [views count], totalSize.height);
    
    for (UIView* aView in views)
    {
        CGPoint offset = Offset(eachSize, aView.frame.size, loc);
        CGPoint tmpPos = CGPointMake(pos.x + offset.x, pos.y + offset.y);
        SetViewFrameOrigin(aView, tmpPos);
        pos.x += eachSize.width;
    }
}



- (void) _vgridSubViews:(NSArray*)views withInfo:(ATLayoutInfo*)info
{
    CGFloat contentHeight = self.bounds.size.height - info->edge.top - info->edge.bottom;
    CGSize totalSize = CGSizeMake(_MaxWidth(views), contentHeight);
    
    ATLocation loc = ParseLocation(info->location);
    CGPoint pos = BeginPos(self.bounds.size, totalSize, info->edge, loc);
    
    CGSize eachSize = CGSizeMake(totalSize.width, totalSize.height / [views count]);
    
    for (UIView* aView in views)
    {
        CGPoint offset = Offset(eachSize, aView.frame.size, loc);
        CGPoint tmpPos = CGPointMake(pos.x + offset.x, pos.y + offset.y);
        SetViewFrameOrigin(aView, tmpPos);
        pos.y += eachSize.height;
    }
}




- (void) layoutSubviews:(NSArray*)views withInfo:(ATLayoutInfo*)info
{
    if ([views count] == 0 || info == NULL)
    {
        return;
    }
    
    if ([views count] == 1)
    {
        [self layoutSubview:[views objectAtIndex:0] withInfo:info];
        return;
    }
    
    if (info->isVertical)
    {
        if (info->isGrid)
        {
            [self _vgridSubViews:views withInfo:info];
        }
        else
        {
            [self _vspaceSubViews:views withInfo:info];
        }
    }
    else
    {
        if (info->isGrid)
        {
            [self _hgridSubViews:views withInfo:info];
        }
        else
        {
            [self _hspaceSubViews:views withInfo:info];
        }
    }
}


@end



static CGPoint BeginPos(CGSize parentSize, CGSize size, UIEdgeInsets edge, ATLocation loc)
{
    parentSize.width -= (edge.left + edge.right);
    parentSize.height -= (edge.top + edge.bottom);
    
    CGPoint pos = Offset(parentSize, size, loc);
    pos.x += edge.left;
    pos.y += edge.top;
    
    return pos;
}



static ATLocation ParseLocation(NSString* text)
{
    ATLocation loc = { ATLocX_Center, ATLocY_Center };
    
    if ([text length] == 0)
    {
        return loc;
    }
    
    NSArray* array = [text componentsSeparatedByString:@","];
    if ([array count] != 2)
    {
        return loc;
    }
    
    NSString* xStr = TrimmingSpaces([array objectAtIndex:0]);
    NSString* yStr = TrimmingSpaces([array objectAtIndex:1]);
    
    // x
    if ([xStr isEqualToString:@"left"])
    {
        loc.x = ATLocX_Left;
    }
    else if ([xStr isEqualToString:@"right"])
    {
        loc.x = ATLocX_Right;
    }
    else if ([xStr isEqualToString:@"middle"] || [xStr isEqualToString:@"center"])
    {
        loc.x = ATLocX_Center;
    }
    
    // y
    if ([yStr isEqualToString:@"top"])
    {
        loc.y = ATLocY_Top;
    }
    else if ([yStr isEqualToString:@"bottom"])
    {
        loc.y = ATLocY_Bottom;
    }
    else if ([yStr isEqualToString:@"middle"] || [xStr isEqualToString:@"center"])
    {
        loc.y = ATLocY_Center;
    }
    
    return loc;
}


static CGFloat OffsetX(CGFloat totalWidth, CGFloat width, ATLocXType type)
{
    CGFloat xpos = 0;
    if (type == ATLocX_Right)
    {
        xpos = totalWidth - width;
    }
    else if (type == ATLocX_Center)
    {
        xpos = (totalWidth - width) * 0.5f;
    }
    return xpos;
}


static CGFloat OffsetY(CGFloat totalHeight, CGFloat height, ATLocYType type)
{
    CGFloat ypos = 0;
    if (type == ATLocY_Bottom)
    {
        ypos = totalHeight - height;
    }
    else if (type == ATLocY_Center)
    {
        ypos = (totalHeight - height) * 0.5f;
    }
    return ypos;
}



static CGPoint Offset(CGSize parentSize, CGSize size, ATLocation loc)
{
    CGFloat xpos = OffsetX(parentSize.width, size.width, loc.x);
    CGFloat ypos = OffsetY(parentSize.height, size.height, loc.y);
    return CGPointMake(xpos, ypos);
}


static CGFloat FillSpaces(CGFloat* spaces, 
                          NSInteger spaceCount, 
                          CGFloat totalSpace, 
                          ATLayoutInfo* info)
{
    ArrayFill(spaces, spaces + spaceCount, 0);
    
    NSArray* spaceTextArray = [info->spaces componentsSeparatedByString:@","];
    if ([spaceTextArray count] == 0)
    {
        return 0;
    }
    
    CGFloat totalSpaceWidth = 0;
    NSInteger textCount = MIN([spaceTextArray count], spaceCount);
    NSInteger autoCount = 0;
    
    for (NSInteger idx = 0; idx < textCount; idx++)
    {
        NSString* text = TrimmingSpaces([spaceTextArray objectAtIndex:idx]);
        
        if ([text isEqualToString:@"auto"] || [text isEqualToString:@"flex"])
        {
            autoCount++;
            spaces[idx] = FLT_MAX;  // for auto
        }
        else
        {
            spaces[idx] = [text floatValue];
            totalSpaceWidth += spaces[idx];
        }
    }
    
    if (textCount < spaceCount)
    {
        CGFloat lastValue = spaces[textCount - 1];
        if (lastValue == FLT_MAX)
        {
            autoCount += (spaceCount - textCount);
        }
        ArrayFill(spaces + textCount, spaces + spaceCount, lastValue);
    }
    
    
    if (autoCount != 0)
    {
        CGFloat autoWidth = (totalSpace - totalSpaceWidth) / autoCount;
        totalSpaceWidth = totalSpace;
        ArrayReplace(spaces, spaces + spaceCount, FLT_MAX, autoWidth);
    }
    
    return totalSpaceWidth;
}


