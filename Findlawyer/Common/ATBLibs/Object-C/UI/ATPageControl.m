//
//  MyPageControll.m
//  KidsPainting
//
//  Created by HJC on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ATPageControl.h"

@implementation ATPageControl 
@synthesize numberOfPages = _numberOfPages;
@synthesize hidesForSinglePage = _hidesForSinglePage;
@synthesize currentPage = _currentPage;
@synthesize normalPointImage = _normalPointImage;
@synthesize currentPointImage = _currentPointImage;


- (void) dealloc
{
    [_normalPointImage release];
    [_currentPointImage release];
    [super dealloc];
}


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void) setCurrentPage:(NSInteger)currentPage
{
    if (_currentPage != currentPage)
    {
        _currentPage = currentPage;
        [self setNeedsDisplay];
    }
}


- (void) setNumberOfPages:(NSInteger)numberOfPages
{
    if (_numberOfPages != numberOfPages)
    {
        _numberOfPages = numberOfPages;
        [self setNeedsDisplay];
    }
}


- (void) drawRect:(CGRect)rect
{
    if (_numberOfPages == 0)
    {
        return;
    }
    
    if (_numberOfPages == 1 && _hidesForSinglePage)
    {
        return;
    }
    
    UIImage* normalImage = _normalPointImage;
    UIImage* currentImage = _currentPointImage;
    CGSize imageSize = normalImage.size;
    
    CGFloat space = 10;
    CGFloat totalWidth = imageSize.width * _numberOfPages;
    totalWidth += (_numberOfPages - 1) * space;
    
    CGFloat xpos = ceilf((CGRectGetWidth(self.bounds) - totalWidth) * 0.5);
    CGFloat ypos = ceilf((CGRectGetHeight(self.bounds) - normalImage.size.height) * 0.5);
    
    for (NSInteger idx = 0; idx < _numberOfPages; idx++)
    {
        CGPoint pt = CGPointMake(xpos, ypos);
        if (idx == _currentPage)
        {
            [currentImage drawAtPoint:pt];
        }
        else
        {
            [normalImage drawAtPoint:pt];
        }
        xpos += (space + imageSize.width);
    }
}


@end
