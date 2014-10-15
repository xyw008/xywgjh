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
        self.backgroundColor = [UIColor clearColor];
        _tilteLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, self.width, 18)];
        _tilteLB.backgroundColor = [UIColor clearColor];
        _tilteLB.textColor = ATColorRGBMake(97, 97, 97);
        _tilteLB.text = title;
        _tilteLB.font = SP15Font;
        [self addSubview:_tilteLB];
        
        CGFloat startX = 0;
        CGFloat startY = CGRectGetMaxY(_tilteLB.frame) + 6;
        CGFloat defaultBtnWidth = self.width/3;
        CGFloat defaultBtnHeight = 35;
        CGFloat defaultBtnLineWidth = .5;
        for (int i=0; i<array.count; i++)
        {
            SortBtn *btn = [[SortBtn alloc] initWithFrame:CGRectMake(startX, startY, defaultBtnWidth, defaultBtnHeight)];
            btn.tag = kSortBtnStartTag + i;
            btn.backgroundColor = kBtnDafaultBgColor;
            btn.layer.borderColor = ATColorRGBMake(224, 224, 224).CGColor;
            btn.layer.borderWidth = defaultBtnLineWidth;
            btn.titleLabel.font = SP14Font;
            btn.titleLabel.lineBreakMode = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(sortBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            startX += defaultBtnWidth - defaultBtnLineWidth;
            if (0 == (i+1)%3 && i != array.count - 1)
            {
                startY += defaultBtnHeight - defaultBtnLineWidth;
                startX = 0;
            }
        }
        self.height = startY + defaultBtnHeight + 8;
    }
    return self;
}

- (void)sortBtnTouch:(SortBtn*)btn
{
    if ([_delegate respondsToSelector:@selector(SearchSortView:didTouchIndex:didBtnTitle:)]) {
        [_delegate SearchSortView:self didTouchIndex:btn.tag - kSortBtnStartTag didBtnTitle:btn.titleLabel.text];
    }
    
}

@end
