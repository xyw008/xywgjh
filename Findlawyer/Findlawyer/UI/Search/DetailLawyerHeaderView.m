//
//  DetailLawyerHeaderView.m
//  Find lawyer
//
//  Created by HKW on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLawyerHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation DetailLawyerHeaderView

- (void)awakeFromNib
{
    _lbDetail.textColor = [UIColor grayColor];
    _lbDetail.numberOfLines = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}


- (void) configViewWithmainImage:(NSURL *)mainimageurl certificateNum:(NSString *)num lawfirmname:(NSString *)lawfirmname specailarea:(NSString *)specialarea detailInfo: (NSString *)detailinfo;
{
     [self.imgPhoto setImageWithURL:mainimageurl placeholderImage:[UIImage imageNamed:@"defaultlawyer"]];
    self.lbCertificatiNum.text = num;
    self.lbLawfirm.text = lawfirmname;
    self.lbSpecialArea.text = specialarea;

    detailinfo = [NSString stringWithFormat:@"                       简介:%@",detailinfo];
    CGSize size = [detailinfo sizeWithFont:_lbDetail.font constrainedToWidth:_lbDetail.width];
    _lbDetail.text = detailinfo;
    _lbDetail.height = MAX(size.height, 23);
    self.height = CGRectGetMaxY(_lbDetail.frame) + 10;
    
//    self.frame = CGRectMake(0, 0, 320,  (size.height > 25 ? 106:103)+size.height+10);
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,  (size.height > 25 ? 106:103), size.width,  (size.height > 25 ? size.height:25))];
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor grayColor];
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.adjustsFontSizeToFitWidth = YES;
//    label.text  = detailinfo;
//    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
//    label.font = [UIFont systemFontOfSize:13];
//    [self addSubview:label];

}

//- (CGSize)caculate:(NSString *)string
//{
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
//    
//    CGSize retSize = [string boundingRectWithSize:CGSizeMake(300, 2000)
//                                          options:
//                      NSStringDrawingTruncatesLastVisibleLine |
//                      NSStringDrawingUsesLineFragmentOrigin |
//                      NSStringDrawingUsesFontLeading
//                                       attributes:attribute
//                                          context:nil].size;
//    
//    return retSize;
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
