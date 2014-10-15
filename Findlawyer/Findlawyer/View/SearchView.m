//
//  SearchView.m
//  Find lawyer
//
//  Created by kadis on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "SearchView.h"

@interface SearchView()<UITextFieldDelegate>


@end

@implementation SearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
