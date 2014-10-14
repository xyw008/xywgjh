//
//  ChooseTable.h
//  Find lawyer
//
//  Created by macmini01 on 14-9-13.
//  Copyright (c) 2014年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooseTable;

@protocol ChooseTableDelegate <NSObject>

/**
 *  btn 点击触发
 *
 *  @param view  self
 *  @param index index
 */
- (void)ChooseTable:(ChooseTable*)view didSelectIndex:(NSInteger)index;

@end

@interface ChooseTable : UIView
{
    __weak id<ChooseTableDelegate>      _delegate;
}
@property (nonatomic,weak)id            delegate;

- (IBAction)chooseLawyerDone:(id)sender;

- (IBAction)chooseLawfirm:(id)sender;

@end
