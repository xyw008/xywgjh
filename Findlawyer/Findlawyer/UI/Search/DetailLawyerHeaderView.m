//
//  DetailLawyerHeaderView.m
//  Find lawyer
//
//  Created by HKW on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import "DetailLawyerHeaderView.h"
#import "UIImageView+WebCache.h"

@interface DetailLawyerHeaderView ()

@property (nonatomic,strong)IBOutlet UIView     *userInfoBgView;
@property (nonatomic,strong)IBOutlet UIView     *detailBgView;

@end

@implementation DetailLawyerHeaderView

- (void)awakeFromNib
{
    _lbDetail.textColor = [UIColor grayColor];
    _lbDetail.numberOfLines = 0;
    
    _lbCertificatiNum.textColor = Common_ThemeColor;
    _lbLawfirm.textColor = Common_ThemeColor;
    _lbSpecialArea.textColor = Common_ThemeColor;
    
    self.backgroundColor = Common_LiteWhiteGrayColor;
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

//    detailinfo = [NSString stringWithFormat:@"                       简介:%@",detailinfo];
    CGSize size = [detailinfo sizeWithFont:_lbDetail.font constrainedToWidth:_lbDetail.width];
    _lbDetail.text = detailinfo;
    
    _detailBgView.height = MAX(size.height, 14) + 8 + 8;
    
    self.height = CGRectGetMaxY(_detailBgView.frame);
    
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
