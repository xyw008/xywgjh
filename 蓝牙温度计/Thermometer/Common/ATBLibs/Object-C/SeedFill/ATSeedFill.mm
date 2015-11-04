//
//  ATSeedFill.m
//  PaintingBoard
//
//  Created by HJC on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ATSeedFill.h"
#import <stack>


typedef struct
{
    int     y;
    int     xLeft;
    int     xRight;
    int     parent_y;
    int     parent_xLeft;
    int     parent_xRight;
} SeedSegment;



static inline BOOL _isInside(const ATSeedFillInput* input)
{
    return (input->x < input->width &&
            input->y < input->height);
}




static void SeedScan(unsigned int* ptr, 
                     int left, 
                     int right, 
                     unsigned int oldColor, 
                     unsigned int newColor,
                     SeedSegment& segment, 
                     std::stack<SeedSegment>& stack)
{
    while (left <= right)
    {
        if (ptr[left] == oldColor)
        {
            segment.xLeft = left;
            do
            {
                segment.xRight = left;
                ptr[left] = newColor;
                left++;
            } while(left <= right && ptr[left] == oldColor);
            stack.push(segment);
        }
        else
        {
            left++;
        }
    }
}



extern BOOL ATSeedFill(ATSeedFillOutput* ouput, const ATSeedFillInput* input)
{
    // 不在里面，不可以填充
    if (!_isInside(input))
    {
        return NO;
    }
    
    unsigned int*   pixels  = input->pixels;
    unsigned int    width   = input->width;
    unsigned int    height  = input->height;
    unsigned int    x       = input->x;
    unsigned int    y       = input->y;
    
    unsigned int oldColor = pixels[width * y + x];
    unsigned int newColor = input->fillColor;
    
    if (oldColor == newColor)
    {
        return NO;
    }
    
    SeedSegment tmpSegment;
    tmpSegment.y = tmpSegment.parent_y = y;
    tmpSegment.xLeft = tmpSegment.parent_xLeft = x;
    tmpSegment.xRight = tmpSegment.parent_xRight = x;
    
    pixels[width * y + x] = newColor;
    
    std::stack<SeedSegment> segmentStack;
    segmentStack.push(tmpSegment);
    
    NSMutableData* data = [NSMutableData data];
    NSInteger minX = x, minY = y;
    NSInteger maxX = x, maxY = y;
    
    while (!segmentStack.empty())
    {
        SeedSegment segment = segmentStack.top();
        segmentStack.pop();
        
        unsigned int* ptr = &pixels[width * segment.y];
        int left = segment.xLeft - 1;
        while (left >= 0 && ptr[left] == oldColor)
        {
            ptr[left] = newColor;
            segment.xLeft = left;
            left--;
        }
        
        int right = segment.xRight + 1;
        while (right < width && ptr[right] == oldColor)
        {
            ptr[right] = newColor;
            segment.xRight = right;
            right++;
        }
        
        ATSeedFillSegment tmp;
        tmp.y = segment.y;
        tmp.xLeft = segment.xLeft;
        tmp.xRight = segment.xRight;
        [data appendBytes:&tmp length:sizeof(tmp)];
        
        minX = MIN(minX, tmp.xLeft);
        maxX = MAX(maxX, tmp.xRight);
        
        minY = MIN(minY, tmp.y);
        maxY = MAX(maxY, tmp.y);
        
        if (segment.y - 1 >= 0)
        {
            SeedSegment topSegment;
            topSegment.parent_y = segment.y;
            topSegment.parent_xLeft = segment.xLeft;
            topSegment.parent_xRight = segment.xRight;
            topSegment.y = segment.y - 1;
            
            unsigned int* ptr = &pixels[width * topSegment.y];
            if (topSegment.y == segment.parent_y)
            {
                SeedScan(ptr, segment.xLeft, segment.parent_xLeft, oldColor, newColor, topSegment, segmentStack);
                SeedScan(ptr, segment.parent_xRight, segment.xRight, oldColor, newColor, topSegment, segmentStack);
            }
            else
            {
                SeedScan(ptr, segment.xLeft, segment.xRight, oldColor, newColor, topSegment, segmentStack);
            }
        }
        
        if (segment.y + 1 < height)
        {
            SeedSegment bottom;
            bottom.parent_y = segment.y;
            bottom.parent_xLeft = segment.xLeft;
            bottom.parent_xRight = segment.xRight;
            bottom.y = segment.y + 1;
            
            unsigned int* ptr = &pixels[width * bottom.y];
            if (bottom.y == segment.parent_y)
            {
                SeedScan(ptr, segment.xLeft, segment.parent_xLeft, oldColor, newColor, bottom, segmentStack);
                SeedScan(ptr, segment.parent_xRight, segment.xRight, oldColor, newColor, bottom, segmentStack);
            }
            else
            {
                SeedScan(ptr, segment.xLeft, segment.xRight, oldColor, newColor, bottom, segmentStack);
            }
        }
    }
    
    ouput->bounds = CGRectMake(minX, minY, maxX - minX + 1, maxY - minY + 1);
    ouput->segments = (ATSeedFillSegment*)[data bytes];
    ouput->numOfSegments = [data length] / sizeof(ATSeedFillSegment);
    
    return YES;
}


