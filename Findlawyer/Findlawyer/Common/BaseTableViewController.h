//
//  BaseTableViewController.h
//  Findlawyer
//
//  Created by macmini01 on 14-7-6.
//  Copyright (c) 2014年 Kevin. All rights reserved.


//这个是本工程 UITableViewController 的基类


#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (strong, nonatomic) UILabel *nodataLabel;
@property (strong, nonatomic) UIImageView *nodataIcon;

- (void)initialize;  // 子类的初始化工作请放到该方法中执行，同时记得先调用[super initialize]
- (void)showNodataIndicatorWithText:(NSString *)text image:(UIImage *)image;// 当Table 中没有数据时可以显示此Lable
- (void)hideNodataIndicator;// 隐藏提示Lable

- (void)setLeftBarbuttonTitle:(NSString *)titile; // 设置导航栏返回按钮的文字

@end
