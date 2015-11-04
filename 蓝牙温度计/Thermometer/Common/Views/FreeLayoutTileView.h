//
//  FreeLayoutTileView.h
//  KKDictionary
//
//  Created by 龚俊慧 on 15/10/19.
//  Copyright © 2015年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FreeLayoutTileView : UIView

/**
 * @method  初始化,一行按照最大显示个数布局,并自动换行(每一行的个数可能不一致,根据字数长度决定)
 * @param   titlesArray: 文字数组
 * @creat   2015-10-19
 * @创建人   龚俊慧
 * @return  实例
 */
- (instancetype)initWithOrigin:(CGPoint)origin
                         width:(CGFloat)width
                   titlesArray:(nullable NSArray<NSString *> *)titlesArray;
/**
 * @method  配置界面,会自动调整控件的高度
 * @param   无
 * @creat   2015-10-19
 * @创建人   龚俊慧
 * @return  void
 */
- (void)configureUI;

@property (nonatomic, strong) NSArray<NSString *> *titlesArray;

@property (nonatomic, assign, readonly) CGFloat height;     // 高度
@property (nonatomic, strong) UIFont *textFont;             // 默认为系统15号字体
@property (nonatomic, strong) UIColor *textColor;           // 默认为黑色

@property (nonatomic, assign) UIEdgeInsets contentInset;    // 默认为UIEdgeInsetsMake(10, 10, 10, 10);
@property (nonatomic, assign) CGFloat lineSpacing;          // 行距,默认为10
@property (nonatomic, assign) CGFloat interitemSpacing;     // 列距,默认为10

@property (nonatomic, assign) CGFloat textToBorderHorizontalSpace;  // 中心文字到边框的水平距离,默认为10
@property (nonatomic, assign) CGFloat textToBorderVerticalSpace;    // 中心文字到边框的垂直距离,默认为5
@property (nonatomic, assign) BOOL isFillItemWidth;                 // 把剩下没有填满的宽度平分给每一个item default is YES

@property (nonatomic, copy) void (^itemStyleHandle) (UIButton *item);
@property (nonatomic, copy) void (^actionHandle) (UIButton *sender, NSInteger index);

@end

NS_ASSUME_NONNULL_END
