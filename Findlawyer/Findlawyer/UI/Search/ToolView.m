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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self newToolLayout];
}

- (void)newToolLayout
{
    //7:_lbPhoneLB 和咨询按钮间距离 12:smsbtn 和right的距离
    CGFloat btnTotalWeight = self.width - CGRectGetMaxX(_lbPhone.frame) - 7 - 12;
    CGFloat btnBetweenSpace = (btnTotalWeight - _CallBtn.width * 3)/2;
    _CallBtn.frameOriginX = CGRectGetMaxX(_ConsultBtn.frame) + btnBetweenSpace;
    _SmsBtn.frameOriginX = CGRectGetMaxX(_CallBtn.frame);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToolView:didBtnType:)])
    {
        [self.delegate ToolView:self didBtnType:ToolBtnTouchType_Call];
    }

}

- (IBAction)btnConsult:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToolView:didBtnType:)])
    {
        [self.delegate ToolView:self didBtnType:ToolBtnTouchType_Consult];
    }
}

- (IBAction)btnSms:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ToolView:didBtnType:)])
    {
        [self.delegate ToolView:self didBtnType:ToolBtnTouchType_Sms];
    }
}
@end
