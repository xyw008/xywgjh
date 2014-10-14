//
//  SearchSortView.m
//  Find lawyer
//
//  Created by leo on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//


#import "SearchSortView.h"

#define kSortBtnStartTag 1000
#define kBtnDafaultBgColor [UIColor whiteColor]

@interface SortBtn : UIButton

@end

////////////////////////////////////////////////////////////

@implementation SortBtn

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = ATColorRGBMake(20, 139, 230);
    }else{
        self.backgroundColor = kBtnDafaultBgColor;
    }
}

@end


////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////

@interface SearchSortView()
{
    UILabel                 *_tilteLB;//标题
}

@end

@implementation SearchSortView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title sortNameArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _tilteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        _tilteLB.backgroundColor = [UIColor clearColor];
        _tilteLB.font = SP18Font;
        _tilteLB.textColor = ATColorRGBMake(97, 97, 97);
        _tilteLB.text = title;
        [self addSubview:_tilteLB];
        
        CGFloat startX = 0;
        CGFloat startY = CGRectGetMaxY(_tilteLB.frame) + 10;
        CGFloat defaultBtnWidth = self.width/3;
        CGFloat defaultBtnHeight = 40;
        for (int i=0; i<array.count; i++)
        {
            SortBtn *btn = [[SortBtn alloc] initWithFrame:CGRectMake(startX, startY, defaultBtnWidth, defaultBtnHeight)];
            btn.backgroundColor = kBtnDafaultBgColor;
            btn.tag = kSortBtnStartTag + i;
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = SP15Font;
            btn.titleLabel.textColor = [UIColor blackColor];
            [btn addTarget:self action:@selector(sortBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            startX += defaultBtnWidth;
            if (0 == (i+1)%3)
            {
                startY += defaultBtnHeight;
                startX = 0;
            }
        }
        self.height = startY + defaultBtnHeight + 10;
    }
    return self;
}

- (void)sortBtnTouch:(SortBtn*)btn
{
    if ([_delegate respondsToSelector:@selector(SearchSortView:didTouchIndex:)]) {
        [_delegate SearchSortView:self didTouchIndex:btn.tag - kSortBtnStartTag];
    }
    
}

@end
