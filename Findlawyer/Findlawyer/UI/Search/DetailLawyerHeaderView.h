//
//  DetailLawyerHeaderView.h
//  Find lawyer
//
//  Created by HKW on 14-9-3.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailLawyerHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;//相片
@property (weak, nonatomic) IBOutlet UILabel *lbCertificatiNum;// 营业执照
@property (weak, nonatomic) IBOutlet UILabel *lbLawfirm; //律所
@property (weak, nonatomic) IBOutlet UILabel *lbSpecialArea;// 专业领域
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;//具体详情


//配置此页面的数据
- (void) configViewWithmainImage:(NSURL *)mainimageurl certificateNum:(NSString *)num lawfirmname:(NSString *)lawfirmname specailarea:(NSString *)specialarea detailInfo: (NSString *)detailinfo;

@end
