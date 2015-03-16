//
//  ConsultListCell.m
//  Find lawyer
//
//  Created by leo on 15/3/10.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "ConsultListCell.h"

@interface ConsultListCell ()

@property (nonatomic,strong)IBOutlet UILabel        *titleLB;
@property (nonatomic,strong)IBOutlet UILabel        *descriptionLB;
@property (nonatomic,strong)IBOutlet UILabel        *timeLB;
@property (nonatomic,strong)IBOutlet UIImageView    *dotIV;

@end


@implementation ConsultListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
