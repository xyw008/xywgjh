//
//  BMKLawyerPaoPaoView.m
//  Find lawyer
//
//  Created by swift on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BMKLawyerPaoPaoView.h"
#import "GCDThread.h"

@implementation BMKLawyerPaoPaoView

- (void)awakeFromNib
{
    [self setup];
}

- (void)configureViewsProperties
{
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel *)subView;
            
            label.textColor = Common_GrayColor;
        }
    }
    
    _lawyerNameLabel.textColor = Common_ThemeColor;
}

- (void)setup
{
    // 设置属性
    [self configureViewsProperties];
}

//////////////////////////////////////////////////////////////////////

- (void)loadViewData:(LBSLawyer *)lawyerEntity
{
    if (lawyerEntity)
    {
        [_lawyerHeaderImageView gjh_setImageWithURL:lawyerEntity.mainImageURL placeholderImage:[UIImage imageNamed:@"lawyerMapAnnotationUserHeaderDefault"] imageShowStyle:ImageShowStyle_None options:SDWebImageCacheMemoryOnly success:^(UIImage *image) {
            
            [GCDThread enqueueForeground:^{
                
                UIImage *newImage = [image imageCroppedToRect:CGRectMake(0, 0, 150, 174)];
                _lawyerHeaderImageView.image = newImage;
            }];
            
        } failure:^(NSError *error) {
            
        }];
        
        _lawyerNameLabel.text = [NSString stringWithFormat:@"%@律师",lawyerEntity.name];
        _lawfirmNameLabel.text = lawyerEntity.lawfirmName;
        _certificateNoLabel.text = [NSString stringWithFormat:@"执业证号:%@",lawyerEntity.certificateNo];
        _specialAreaLabel.text = [NSString stringWithFormat:@"擅长领域:%@",lawyerEntity.specialArea];
        _distanceLabel.text = lawyerEntity.distance > 0 ? [NSString stringWithFormat:@"%.0f米",lawyerEntity.distance] : nil;
    }
}

@end
