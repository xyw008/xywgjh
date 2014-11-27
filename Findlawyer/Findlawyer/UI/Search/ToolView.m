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

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGFloat btnTotalWeight = IPHONE_WIDTH - CGRectGetMaxX(_lbPhone.frame);
    CGFloat btnBetweenSpace = (btnTotalWeight - _CallBtn.width * 3) / 4;
    
    [_lbPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_ConsultBtn.mas_left).with.offset(-btnBetweenSpace);
    }];
    [_ConsultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_CallBtn.mas_left).with.offset(-btnBetweenSpace);
    }];
    [_CallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_SmsBtn.mas_left).with.offset(-btnBetweenSpace);
    }];
}

- (void)newToolLayout
{
    /*
    //7:_lbPhoneLB 和咨询按钮间距离 12:smsbtn 和right的距离
    CGFloat btnTotalWeight = self.width - CGRectGetMaxX(_lbPhone.frame);
    CGFloat btnBetweenSpace = (btnTotalWeight - _CallBtn.width * 3) / 4;
    
    _ConsultBtn.frameOriginX = CGRectGetMaxX(_lbPhone.frame) + btnBetweenSpace;
    _CallBtn.frameOriginX = CGRectGetMaxX(_ConsultBtn.frame) + btnBetweenSpace;
    _SmsBtn.frameOriginX = CGRectGetMaxX(_CallBtn.frame) + btnBetweenSpace;
    
    _ConsultBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _CallBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _SmsBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
     */
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
