//
//  ToolView.m
//  Find lawyer
//
//  Created by macmini01 on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "ToolView.h"

@implementation ToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configViewWithPhone:(NSString *)phone
{
    self.lbPhone.text = @"";
    if (phone.length > 0)
    {
        self.lbPhone.text = phone;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnCall:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedToolView:btnTag:)])
    {
        [self.delegate selectedToolView:self btnTag:1];
    }

}

- (IBAction)btnConsult:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedToolView:btnTag:)])
    {
        [self.delegate selectedToolView:self btnTag:0];
    }
}

- (IBAction)btnSms:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedToolView:btnTag:)])
    {
        [self.delegate selectedToolView:self btnTag:2];
    }
}
@end
