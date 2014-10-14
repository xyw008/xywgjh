//
//  ChooseTable.m
//  Find lawyer
//
//  Created by macmini01 on 14-9-13.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ChooseTable.h"

@implementation ChooseTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)chooseLawyerDone:(id)sender
{
    [self btnTouch:0];
}

- (IBAction)chooseLawfirm:(id)sender
{
    [self btnTouch:1];
}

- (void)btnTouch:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(ChooseTable:didSelectIndex:)]) {
        [_delegate ChooseTable:self didSelectIndex:index];
    }
}

@end
