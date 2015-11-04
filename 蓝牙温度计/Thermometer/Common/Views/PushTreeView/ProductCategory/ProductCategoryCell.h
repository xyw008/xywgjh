//
//  ProductCategoryCell.h
//  o2o
//
//  Created by swift on 14-8-6.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCategoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cellImageView;
@property (nonatomic, weak) IBOutlet UILabel     *cellTextLabel;
@property (nonatomic, weak) IBOutlet UILabel     *cellDetailTextLabel;

@end
