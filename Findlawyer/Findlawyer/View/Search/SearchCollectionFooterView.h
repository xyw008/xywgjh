//
//  SearchCollectionFooterView.h
//  Find lawyer
//
//  Created by swift on 15/1/17.
//  Copyright (c) 2015年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCollectionFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

+ (CGSize)getViewSize;

@end
