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

typedef NS_ENUM(NSInteger, TabFooterRefreshStatusViewType)
{
    /// 加载更多
    TabFooterRefreshStatusViewType_LoadMore = 0,
    /// 正在加载
    TabFooterRefreshStatusViewType_Loading,
    /// 已无更多数据
    TabFooterRefreshStatusViewType_NoMoreData,
};

typedef void (^PickPhotoFinishHandle) (NSArray *pickedImageArray);
typedef void (^PickPhotoCancelHandle) (void);

@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
@protected
    UIImageView *backgroundStatusImgView; // 背景图
    
    UITableView *_tableView;              // default is nil
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

/// tab滚到到最底部要执行的回调
@property (nonatomic, copy) void (^tabScrollToBottomOperationHandle) (UIScrollView *scrollView);

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
 @ 方法描述    设置tableView
 @ 输入参数    registerNibName: cell的注册名 reuseIdentifier: cell的重用标识符
 @ 创建人      龚俊慧
 @ 创建时间    2014-07-18
 */
- (void)setupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style registerNibName:(NSString *)nibName reuseIdentifier:(NSString *)identifier;

/**
 @ 方法描述    设置tableView滚动到最底部加载更多时的状态视图
 @ 输入参数    tableView: 要加状态图的tab
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-05
 */
- (void)setupTabFooterRefreshStatusView:(UITableView *)tableView action:(SEL)action;

/**
 @ 方法描述    设置tableView滚动到最底部加载更多时的状态视图的显示类型
 @ 输入参数    type: 显示类型
 @ 创建人      龚俊慧
 @ 创建时间    2015-01-05
 */
- (void)setupTabFooterRefreshStatusViewShowType:(TabFooterRefreshStatusViewType)type;

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

/**
 @ 方法描述    从相机或者相册选取单张照片
 @ 输入参数    isCropped: 是否裁剪
 @ 创建人      龚俊慧
 @ 创建时间    2014-11-13
 */
- (void)pickSinglePhotoFromCameraOrAlbumByIsCropped:(BOOL)isCropped
                                       cancelHandle:(PickPhotoCancelHandle)cancelHandle
                                finishPickingHandle:(PickPhotoFinishHandle)finishHandle;

/**
 @ 方法描述    从相册选取照片
 @ 输入参数    isCropped: 是否裁剪(只选取1张时) maxNumberOfSelection: 最大选取张数
 @ 创建人      龚俊慧
 @ 创建时间    2014-11-13
 */
- (void)pickPhotoFromAlbumWithMaxNumberOfSelection:(NSInteger)maxNumber
                                         isCropped:(BOOL)isCropped
                                      cancelHandle:(PickPhotoCancelHandle)cancelHandle
                               finishPickingHandle:(PickPhotoFinishHandle)finishHandle;

/**
 @ 方法描述    从相机选取照片
 @ 输入参数    isCropped: 是否裁剪
 @ 创建人      龚俊慧
 @ 创建时间    2014-11-13
 */
- (void)pickPhotoFromCameraByIsCropped:(BOOL)isCropped
                          cancelHandle:(PickPhotoCancelHandle)cancelHandle
                   finishPickingHandle:(PickPhotoFinishHandle)finishHandle;

@end
