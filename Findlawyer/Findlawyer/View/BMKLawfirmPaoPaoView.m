//
//  BMKLawfirmPaoPaoView.m
//  Find lawyer
//
//  Created by leo on 14-10-15.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "BMKLawfirmPaoPaoView.h"




@implementation BMKLawfirmPaoPaoView


- (void)loadViewData:(LBSLawfirm *)lawfirmEntity
{
    if(lawfirmEntity)
    {
        [_lawyfirmHeaderImageView gjh_setImageWithURL:lawfirmEntity.mainImageURL placeholderImage:[UIImage imageNamed:@"defaultLawfirm_samll.png"] imageShowStyle:ImageShowStyle_None success:nil failure:nil];
        
        _lawfirmNameLabel.text = lawfirmEntity.name;
        _distanceLabel.text = [NSString stringWithFormat:@"%d米",lawfirmEntity.distance];
        
//        CGSize size = [lawfirmEntity.address sizeWithFont:_lawfirmAddressLabel.font constrainedToWidth:_lawfirmAddressLabel.width];
//        
//        //改变地址Label的高度和Y,执业人数Label的Y
//        if (size.height > 19)
//        {
//            _lawfirmAddressLabel.height = 37;
//            DLog(@"max y  = %f",CGRectGetMaxY(_lawfirmNameLabel.frame));
//            _lawfirmAddressLabel.frameOriginY -= 7;
//            _lawyerNumLabel.frameOriginY -= 6;
////            _lawfirmAddressLabel.frameOriginY = CGRectGetMaxY(_lawfirmNameLabel.frame);
////            _lawyerNumLabel.frameOriginY = CGRectGetMaxY(_lawfirmAddressLabel.frame);
//        }
//        else
//        {
//            _lawfirmAddressLabel.height = 19;
//            _lawfirmAddressLabel.frameOriginY = CGRectGetMaxY(_lawfirmNameLabel.frame) + 7;
//            _lawyerNumLabel.frameOriginY = CGRectGetMaxY(_lawfirmAddressLabel.frame) + 6;
//        }
        
        _lawfirmAddressLabel.text = [NSString stringWithFormat:@"%@",lawfirmEntity.address];
        _lawyerNumLabel.text = [NSString stringWithFormat:@"执业人数: %@",lawfirmEntity.memberCount];
        
    }
}

@end
