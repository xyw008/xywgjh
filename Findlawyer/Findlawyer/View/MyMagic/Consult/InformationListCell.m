//
//  InformationListCell.m
//  Find lawyer
//
//  Created by leo on 15/3/11.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import "InformationListCell.h"

@interface InformationListCell ()

@property (nonatomic,strong)IBOutlet UILabel        *titleLB;
@property (nonatomic,strong)IBOutlet UILabel        *descriptionLB;
@property (nonatomic,strong)IBOutlet UIImageView    *previewIV;

@end

@implementation InformationListCell

- (void)awakeFromNib {
    UIView *lineView = [[UIView alloc] init];
    [self.contentView addSubview:lineView];
    
    lineView.backgroundColor = CellSeparatorColor;
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        make.left.equalTo(self.mas_left).offset(_previewIV.frameOriginX);
        make.right.equalTo(self.mas_right).offset(-_previewIV.frameOriginX);
        make.height.equalTo(0.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)testLoadDescription:(NSString *)description
{
    _descriptionLB.text = description;
}

@end
