//
//  EICheckBox.h
//  EInsure
//
//  Created by ivan on 14-5-9.
//  Copyright (c) 2014年 leo All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGButtonBox;

@protocol YGButtonBoxDelegate <NSObject>

@optional

- (void)YGButtonBox:(YGButtonBox *)checkbox didSelect:(BOOL)select;

@end

@interface YGButtonBox : UIButton {
    __weak id<YGButtonBoxDelegate> _delegate;
}

@property(nonatomic, weak)id            delegate;
@property(nonatomic, assign)BOOL        selectBtn;
@property(nonatomic, retain)id          userInfo;

- (id)initWithDelegate:(id)delegate;

/**
 *
 * 参数： frame:图片开始的X值:图片的宽度:图片和title之间的距离
 *
 */
- (id)initWithFrame:(CGRect)frame iconStartX:(CGFloat)iconStartX iconWidth:(CGFloat)iconWidth iconAndTitleSpaceBetween:(CGFloat)betweenWidth;


@end


