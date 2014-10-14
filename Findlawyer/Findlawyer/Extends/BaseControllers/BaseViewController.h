//
//  BaseViewController.h
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HUDInfoType)
{
    HUDInfoType_Success = 0,
    HUDInfoType_Failed,
    HUDInfoType_Loading,
    HUDInfoType_NoConnectionNetwork
};

typedef NS_ENUM(NSInteger, BarbuttonItemPosition)
{
    BarbuttonItemPosition_Left = 0,
    BarbuttonItemPosition_Right
};

@interface BaseViewController : UIViewController
{
    UIImageView *backgroundStatusImgView; // 背景图
}

/// 布局子视图的Y坐标的起点(IOS7为20,IOS7以下为0)
@property (nonatomic, assign, readonly) float subViewsOriginY;

/// 相当于self.view.frame.origin
@property (nonatomic, assign, readonly) CGPoint viewFrameOrigin;
/// 相当于self.view.frame.size(有做IOS7系统下如果view的尺寸没有navigationBar情况的全屏,除去statusBar状态栏20个像素的判断)
@property (nonatomic, assign, readonly) CGSize  viewFrameSize;
/// 相当于self.bounds.size(有做IOS7系统下如果view的尺寸没有navigationBar情况的全屏,除去statusBar状态栏20个像素的判断)
@property (nonatomic, assign, readonly) CGSize  viewBoundsSize;

/// 相当于self.view.bounds.size.height(有做IOS7系统下如果view的尺寸没有navigationBar情况的全屏,除去statusBar状态栏20个像素的判断)
@property (nonatomic, assign, readonly) CGFloat viewBoundsHeight;
/// 相当于self.view.bounds.size.width
@property (nonatomic, assign, readonly) CGFloat viewBoundsWidth;

/// 相当于self.view.frame.size.height(有做IOS7系统下如果view的尺寸没有navigationBar情况的全屏,除去statusBar状态栏20个像素的判断)
@property (nonatomic, assign, readonly) CGFloat viewFrameHeight;
/// 相当于self.view.frame.size.width
@property (nonatomic, assign, readonly) CGFloat viewFrameWidth;

/////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    push新的控制器到导航控制器
 @ 输入参数    viewController: 目标新的控制器对象
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)pushViewController:(UIViewController *)viewController;

/**
 @ 方法描述    present一个新的控制器
 @ 输入参数    viewController: 目标新的控制器对象
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)presentViewController:(UIViewController *)viewController modalTransitionStyle:(UIModalTransitionStyle)style completion:(void (^)(void))completion;

/////////////////////////////////////////////////////////////////////////////////////////

/**
 @ 方法描述    设置背景图片
 @ 输入参数    backgroundImage: 背景图片
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 @ 方法描述    HUD显示文字信息
 @ 输入参数    HUDInfoType: 显示类型
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)showHUDInfoByType:(HUDInfoType)type;

/**
 @ 方法描述    HUD显示文字信息
 @ 输入参数    String: 需要显示的文字内容
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)showHUDInfoByString:(NSString *)str;

/**
 @ 方法描述    隐藏HUD显示
 @ 输入参数    无
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)hideHUD;

/**
 @ 方法描述    配置导航栏按钮
 @ 输入参数    BarbuttonItemPosition: 位置
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)configureBarbuttonItemByPosition:(BarbuttonItemPosition)position normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg action:(SEL)action;

/**
 @ 方法描述    配置导航栏按钮
 @ 输入参数    BarbuttonItemPosition: 位置
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)configureBarbuttonItemByPosition:(BarbuttonItemPosition)position barButtonTitle:(NSString *)title action:(SEL)action;

/**
 @ 方法描述    设置界面本地的所有文字显示(例如:导航栏标题、设置页文字等,涉及多语言),子类实现
 @ 输入参数    无
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)setPageLocalizableText;

/**
 @ 方法描述    设置导航栏标题
 @ 输入参数    titleStr: 标题
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void) setNavigationItemTitle:(NSString *)titleStr;

/**
 @ 方法描述    设置导航栏标题
 @ 输入参数    titleStr: 标题
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)setNavigationItemTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;

/**
 @ 方法描述    返回上一页
 @ 输入参数    无
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)backViewController;

/**
 @ 方法描述    添加返回上一页滑动手势
 @ 输入参数    无
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)addBackSwipeGesture;

/////////////////////////////////////////////////////////////////////////////////////////////////////////

@property (strong, nonatomic) UILabel *nodataLabel;
@property (strong, nonatomic) UIImageView *nodataIcon;


- (void)initialize;  // 子类的初始化工作请放到该方法中执行，同时记得先调用[super initialize]
- (void)showNodataIndicatorWithText:(NSString *)text image:(UIImage *)image;// 当Table 中没有数据时可以显示此Lable
- (void)hideNodataIndicator; // 隐藏提示Lable
- (void)setLeftBarbuttonTitle:(NSString *)titile; //设置导航栏返回按钮的文字

@end
