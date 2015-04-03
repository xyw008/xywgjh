//
//  BMKLawfirmPaoPaoView.m
//  Find lawyer
//
//  Created by leo on 14-10-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BMKLawfirmPaoPaoView.h"

@implementation BMKLawfirmPaoPaoView

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            
            label.textColor = Common_GrayColor;
        }
    }
    
    _lawfirmNameLabel.textColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

- (void)loadViewData:(LBSLawfirm *)lawfirmEntity
{
    if(lawfirmEntity)
    {
        UIImage *placeholderImage = [UIImage imageNamed:@"defaultLawfirm_samll.png"];
        CGSize size = _lawyfirmHeaderImageView.boundsSize;
        
        [_lawyfirmHeaderImageView gjh_setImageWithURL:lawfirmEntity.mainImageURL placeholderImage:[placeholderImage resize:size] imageShowStyle:ImageShowStyle_None success:nil failure:nil];
        
        _lawfirmNameLabel.text = lawfirmEntity.name;
        // _distanceLabel.text = [NSString stringWithFormat:@"%d米",lawfirmEntity.distance];
        
        _lawfirmAddressLabel.text = [NSString stringWithFormat:@"地址: %@",lawfirmEntity.address];
        _lawyerNumLabel.text = [NSString stringWithFormat:@"执业人数: %@",lawfirmEntity.memberCount];
        
        _distanceLabel.text = nil;
        if (lawfirmEntity.distance > 0)
        {
            if (lawfirmEntity.distance > 9999)
            {
                _distanceLabel.text = [NSString stringWithFormat:@"%.1lf千米",lawfirmEntity.distance / 1000];
            }
            else
            {
                _distanceLabel.text = [NSString stringWithFormat:@"%.0lf米",lawfirmEntity.distance];
            }
        }
    }
}

@end
