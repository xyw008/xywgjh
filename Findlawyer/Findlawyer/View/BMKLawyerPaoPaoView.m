//
//  BMKLawyerPaoPaoView.m
//  Find lawyer
//
//  Created by swift on 14-10-14.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BMKLawyerPaoPaoView.h"

@implementation BMKLawyerPaoPaoView

- (void)loadViewData:(LBSLawyer *)lawyerEntity
{
    if (lawyerEntity)
    {
        [_lawyerHeaderImageView gjh_setImageWithURL:lawyerEntity.mainImageURL placeholderImage:[UIImage imageNamed:@"lawyerMapAnnotationUserHeaderDefault"] imageShowStyle:ImageShowStyle_None success:nil failure:nil];
        
        _lawyerNameLabel.text = [NSString stringWithFormat:@"%@律师",lawyerEntity.name];
        _lawfirmNameLabel.text = lawyerEntity.lawfirmName;
        _certificateNoLabel.text = [NSString stringWithFormat:@"执业证号:%@",lawyerEntity.certificateNo];
        _specialAreaLabel.text = [NSString stringWithFormat:@"擅长领域:%@",lawyerEntity.specialArea];
        _distanceLabel.text = lawyerEntity.distance > 0 ? [NSString stringWithFormat:@"%.0f米",lawyerEntity.distance] : nil;
    }
}

@end
