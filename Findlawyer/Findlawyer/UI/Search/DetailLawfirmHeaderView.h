//
//  DetailLawfirmHeaderView.h
//  Find lawyer
//
//  Created by macmini01 on 14-8-29.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

// 用来显示律师的详细信息

#import <UIKit/UIKit.h>

@interface DetailLawfirmHeaderView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *mainImg; // 律所图片

@property (weak, nonatomic) IBOutlet UIScrollView *scPhoto; // 用来显示律师的滑动图片

@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (nonatomic,strong)IBOutlet UILabel *numStrLB;//执业人数：

@property (weak, nonatomic) IBOutlet UILabel *lbAdress;  // 显示地址信息
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;   // 显示电话
@property (weak, nonatomic) IBOutlet UILabel *lbNetAdress; // 显示地址
@property (weak, nonatomic) IBOutlet UILabel *lbFax;      // 显示传真
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;   // 显示详情

@property (nonatomic,strong) IBOutlet UIButton *leftBtn; //左翻页btn
@property (nonatomic,strong) IBOutlet UIButton *rightBtn; //又翻页btn

- (IBAction)turntoLeft:(id)sender;

- (IBAction)turntoRight:(id)sender;

// 配置此界面各种信息
- (void) configViewWithmainImage:(NSURL *)mainimageurl introimagelist:(NSArray *)imagelist Count:(NSNumber *)count adress:(NSString *)adress phone:(NSString *)phone netAdress:(NSString *)netadress fax:(NSString *)fax detailInfo: (NSString *)detailinfo;

@end
