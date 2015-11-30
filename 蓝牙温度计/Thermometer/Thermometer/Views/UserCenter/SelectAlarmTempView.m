//
//  SelectAlarmTempView.m
//  Thermometer
//
//  Created by leo on 15/11/30.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "SelectAlarmTempView.h"
#import "YSBLEManager.h"
#import "AccountStautsManager.h"

@interface SelectAlarmTempView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView        *_pickerView;
    
    NSArray             *_bigNumArray;
    NSArray             *_smallNumArray;
    
    NSString            *_bigSelectValue;
    NSString            *_smallSelectValue;
}

@end

@implementation SelectAlarmTempView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        ViewRadius(self, 5);
        
        self.userInteractionEnabled = YES;
        _bigNumArray = @[@(30),@(31),@(32),@(33),@(34),@(35),@(36),@(37),@(38),@(39),@(40)];
        _smallNumArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake((self.width - 130)/2, 15, 130, self.height - 70)];
        
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        [self addSubview:_pickerView];
        
        UILabel *unitLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_pickerView.frame) + 3, CGRectGetMaxY(_pickerView.frame) - _pickerView.height / 2 - 15, 34, 34)];
        unitLB.text = @"度";
        unitLB.font = [UIFont systemFontOfSize:22.0];
        unitLB.textColor = Common_BlackColor;
        [self addSubview:unitLB];
        
        CGFloat btnHeight = 44;
        UIButton *submitBtn = InsertButton(self, CGRectMake(-1, self.height - btnHeight + ThinLineWidth, self.width/2 + 1, btnHeight), 1000, @"确定", self, @selector(btnTouch:));
        [submitBtn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
        submitBtn.titleLabel.font = SP15Font;
        
        UIButton *cancelBtn = InsertButton(self, CGRectMake(CGRectGetMaxX(submitBtn.frame) - ThinLineWidth, submitBtn.frameOriginY, submitBtn.width, btnHeight), 1001, @"取消", self, @selector(btnTouch:));
        [cancelBtn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = SP15Font;
        
        /*
        ViewBorderRadius(submitBtn, 0, ThinLineWidth, CellSeparatorColor);
        ViewBorderRadius(cancelBtn, 0, ThinLineWidth, CellSeparatorColor);
         */
        [submitBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0XF6F6F6)]
                             forState:UIControlStateHighlighted];
        [cancelBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0XF6F6F6)]
                             forState:UIControlStateHighlighted];
        
        [submitBtn addLineWithPosition:ViewDrawLinePostionType_Top
                             lineColor:CellSeparatorColor
                             lineWidth:ThinLineWidth];
        [submitBtn addLineWithPosition:ViewDrawLinePostionType_Right
                             lineColor:CellSeparatorColor
                             lineWidth:ThinLineWidth];
        [cancelBtn addLineWithPosition:ViewDrawLinePostionType_Top
                             lineColor:CellSeparatorColor
                             lineWidth:ThinLineWidth];
        [self setRadius:5];
        
    }
    return self;
}

- (void)btnTouch:(UIButton*)btn
{
    if (_btnCallBack)
    {
        BOOL isSubmitBtn = NO;
        CGFloat value = 0;
        if (btn.tag == 1000)
        {
            isSubmitBtn = YES;
            
            NSString *valueStr = [NSString stringWithFormat:@"%@.%@",_bigSelectValue,_smallSelectValue];
            value = [valueStr floatValue];
        }
        _btnCallBack(isSubmitBtn,value);
    }
}

- (void)nowSelectTemp:(CGFloat)temp
{
    NSString *tempStr = [NSString stringWithFormat:@"%.1lf",temp];
    NSArray *tempArray = [tempStr componentsSeparatedByString:@"."];
    
    NSInteger bigNum = [[tempArray objectAtIndex:0] integerValue];
    NSString *smallStr = [tempArray objectAtIndex:1];
    
    if ([_bigNumArray containsObject:@(bigNum)])
    {
        _bigSelectValue = [NSString stringWithFormat:@"%ld", (long)bigNum];
        
        NSInteger index = [_bigNumArray indexOfObject:@(bigNum)];
        [_pickerView selectRow:index inComponent:0 animated:NO];
    }
    
    if ([_smallNumArray containsObject:smallStr]) {
        
        _smallSelectValue = smallStr;
        
        NSInteger index = [_smallNumArray indexOfObject:smallStr];
        [_pickerView selectRow:index inComponent:1 animated:NO];
    }
}


#pragma mark - UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {
        return _bigNumArray.count;
    }
    return _smallNumArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel = InsertLabel(nil, CGRectMake(0, 0, _pickerView.boundsWidth / 3, 20), NSTextAlignmentCenter, nil, SP16Font, [UIColor blackColor], NO);
    
    switch (component)
    {
        case 0:
        {
            titleLabel.text = [self getBigValueStr:row];
            return titleLabel;
        }
            break;
        case 1:
        {
            titleLabel.text = [_smallNumArray objectAtIndex:row];
            return titleLabel;
        }
        default:
        {
            return nil;
        }
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        _bigSelectValue = [self getBigValueStr:row];
    }
    else
    {
        _smallSelectValue = [_smallNumArray objectAtIndex:row];
    }
}

- (NSString*)getBigValueStr:(NSInteger)index
{
    CGFloat bigNum = [[_bigNumArray objectAtIndex:index] floatValue];
    if ([[YSBLEManager sharedInstance] isFUnit]) {
        bigNum = [BLEManager getFTemperatureWithC:bigNum];
    }
    return [NSString stringWithFormat:@"%.0lf",bigNum];
}

@end
