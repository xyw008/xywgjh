//
//  BaseViewController.m
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseViewController.h"
#import "HUDManager.h"
#import "InterfaceHUDManager.h"
#import "LanguagesManager.h"
#import "CTAssetsPickerController.h"

@interface BaseViewController () <UINavigationControllerDelegate, CTAssetsPickerControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIScrollViewDelegate>
{
    PickPhotoFinishHandle _pickPhotoFinishHandle;
    PickPhotoCancelHandle _pickPhotoCancelHandle;
    BOOL                  _isCropped;
    
    UIButton              *_footerRefreshBtn;
}

@end

@implementation BaseViewController

- (void)dealloc
{
    // 注销本地语言切换通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:LanguageTypeDidChangedNotificationKey
                                                  object:nil];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = PageBackgroundColor;
    
    /*
     // 更改状态栏颜色
     #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
     self.edgesForExtendedLayout = UIRectEdgeNone;
     self.extendedLayoutIncludesOpaqueBars = NO;
     self.modalPresentationCapturesStatusBarAppearance = NO;
     #endif
     */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0X1E93DC) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    if (IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    /*
     if (IOS7)
     {
     // 在ios7的情况下setBarTintColor是设置导航栏颜色,setTintColor是设置系统BarButtonItem的字体和图片颜色
     [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
     [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Return_btn_3.png"]];
     [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Return_btn_3.png"]];
     }
     else
     {
     // 在ios7以下系统的情况下setTintColor才是设置导航栏颜色
     [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
     }
     */
    
    /*
     NSShadow *shadow = [[NSShadow alloc] init];
     shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
     shadow.shadowOffset = CGSizeMake(0, 1);
     [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
     shadow, NSShadowAttributeName,
     [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
     */
    
    // 注册本地语言切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPageLocalizableText)
                                                 name:LanguageTypeDidChangedNotificationKey
                                               object:nil];
    
    // 设置界面本地的所有文字显示(涉及多语言)
    [self setPageLocalizableText];
    
    /**
     *o2o返回键放在了低栏,这里屏蔽掉(默认是调用@selector(backViewController))
     */
    // 返回Btn
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left
                                 normalImg:[UIImage imageNamed:@"Return_btn_3.png"]
                            highlightedImg:[UIImage imageNamed:@"Return_btn_4.png"]
                                    action:NULL];
    
    // 加此代码可以在自定义leftBarButtonItem之后还保持IOS7以上系统自带的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IOS7)
    {
        [self setNeedsStatusBarAppearanceUpdate];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideHUD];
    
    /*
     * @捕捉设置给leftBarButtonItem的回调方法
     *
     if (![[self.navigationController viewControllers] containsObject:self])
     {
     // the view has been removed from the navigation stack, back is probably the cause
     // this will be slow with a large stack however.
     [self backViewController];
     }
     */
    
    [super viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////

- (float)subViewsOriginY
{
    if (IOS7)
    {
        if (self.navigationController && !self.navigationController.navigationBar.hidden)
            return 0.0;
        else
            return 20.0;
    }
    return 0.0;
}

- (CGPoint)viewFrameOrigin
{
    return self.view.frame.origin;
}

- (CGSize)viewFrameSize
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.subViewsOriginY);
}

- (CGSize)viewBoundsSize
{
    return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height - self.subViewsOriginY);
}

- (CGFloat)viewBoundsHeight
{
    return self.view.bounds.size.height - self.subViewsOriginY;
}

- (CGFloat)viewBoundsWidth
{
    return self.view.bounds.size.width;
}

- (CGFloat)viewFrameHeight
{
    return self.view.frame.size.height - self.subViewsOriginY;
}

- (CGFloat)viewFrameWidth
{
    return self.view.frame.size.width;
}

#pragma mark - 工具类方法    ////////////////////////////////////////////////////////////////////////////

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)viewController modalTransitionStyle:(UIModalTransitionStyle)style completion:(void (^)(void))completion
{
    if (viewController)
    {
        viewController.modalTransitionStyle = style;
        
        [self presentViewController:viewController animated:YES completion:completion];
    }
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage
{
    if (!backgroundStatusImgView)
    {
        backgroundStatusImgView = InsertImageView(self.view, self.view.bounds, nil, nil);
        backgroundStatusImgView.contentMode = UIViewContentModeScaleAspectFit;
        [backgroundStatusImgView keepAutoresizingInFull];
        
        [self.view insertSubview:backgroundStatusImgView atIndex:0];
    }
    backgroundStatusImgView.image = backgroundImage;
}

- (void)setupTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style registerNibName:(NSString *)nibName reuseIdentifier:(NSString *)identifier
{
    _tableView = InsertTableView(nil, frame, self, self, style);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    if ([nibName isAbsoluteValid] && [identifier isAbsoluteValid])
    {
        [_tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
    }
    
    [self.view addSubview:_tableView];
}

- (void)setupTabFooterRefreshStatusView:(UITableView *)tableView action:(SEL)action
{
    UIView *bgView = InsertView(nil, CGRectMake(0, 0, tableView.boundsWidth, 55));
    bgView.backgroundColor = [UIColor whiteColor];
    
    _footerRefreshBtn = InsertImageButtonWithTitle(bgView,
                                                   CGRectMake(10, 10, bgView.boundsWidth - 10 * 2, 55 - 10 * 2),
                                                   1000,
                                                   nil,
                                                   nil,
                                                   nil,
                                                   UIEdgeInsetsZero,
                                                   SP13Font,
                                                   [UIColor grayColor],
                                                   self,
                                                   action);
    _footerRefreshBtn.backgroundColor = [UIColor whiteColor];
    [_footerRefreshBtn addBorderToViewWitBorderColor:[UIColor grayColor]
                                         borderWidth:0.5];
    [_footerRefreshBtn setRadius:4];
    
    // 设置默认显示类型
    [self setupTabFooterRefreshStatusViewShowType:TabFooterRefreshStatusViewType_Loading];
    
    tableView.tableFooterView = bgView;
}

- (void)setupTabFooterRefreshStatusViewShowType:(TabFooterRefreshStatusViewType)type
{
    if (TabFooterRefreshStatusViewType_LoadMore == type)
    {
        [_footerRefreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_footerRefreshBtn setTitle:@"加载更多" forState:UIControlStateNormal];
        _footerRefreshBtn.userInteractionEnabled = YES;
    }
    else if (TabFooterRefreshStatusViewType_Loading == type)
    {
        [_footerRefreshBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_footerRefreshBtn setTitle:@"正在加载..." forState:UIControlStateNormal];
        _footerRefreshBtn.userInteractionEnabled = NO;
    }
    else if (TabFooterRefreshStatusViewType_NoMoreData == type)
    {
        [_footerRefreshBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_footerRefreshBtn setTitle:@"已无更多数据" forState:UIControlStateNormal];
        _footerRefreshBtn.userInteractionEnabled = NO;
    }
}

- (void)showHUDInfoByType:(HUDInfoType)type
{
    switch (type)
    {
        case HUDInfoType_Success:
        {
            /*
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:OperationSuccess showType:HUDOperationSuccess];
             */
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:OperationSuccess];
        }
            break;
        case HUDInfoType_Failed:
        {
            /*
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:OperationFailure showType:HUDOperationFailed];
             */
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:OperationFailure];
        }
            break;
        case HUDInfoType_Loading:
        {
            [HUDManager showHUDWithToShowStr:nil HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES];
        }
            break;
            case HUDInfoType_NoConnectionNetwork:
        {
            /*
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:NoConnectionNetwork showType:HUDOperationFailed];
             */
            [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:NoConnectionNetwork];
        }
            break;
        default:
            break;
    }
}

- (void)showHUDInfoByString:(NSString *)str
{
    /*
    [HUDManager showAutoHideHUDWithToShowStr:str HUDMode:MBProgressHUDModeText];
     */
    [[InterfaceHUDManager sharedInstance] showAutoHideAlertWithMessage:str];
}

- (void)hideHUD
{
    [HUDManager hideHUD];
}

- (void)configureBarbuttonItemByPosition:(BarbuttonItemPosition)position normalImg:(UIImage *)normalImg highlightedImg:(UIImage *)highlightedImg action:(SEL)action
{
    if (BarbuttonItemPosition_Left == position)
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 30, 30) normalImg:normalImg highlightedImg:highlightedImg target:self action:action];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 30, 30) normalImg:normalImg highlightedImg:highlightedImg target:self action:action];
    }
}

- (void)configureBarbuttonItemByPosition:(BarbuttonItemPosition)position barButtonTitle:(NSString *)title action:(SEL)action
{
    if (BarbuttonItemPosition_Left == position)
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 50, 30) tag:8888 normalImg:nil highlightedImg:nil title:title target:self action:action];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 50, 30) tag:8888 normalImg:nil highlightedImg:nil title:title target:self action:action];
    }
}

- (void)pickSinglePhotoFromCameraOrAlbumByIsCropped:(BOOL)isCropped cancelHandle:(PickPhotoCancelHandle)cancelHandle finishPickingHandle:(PickPhotoFinishHandle)finishHandle
{
    _pickPhotoFinishHandle = [finishHandle copy];
    _pickPhotoCancelHandle = [cancelHandle copy];
    _isCropped = isCropped;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LocalizedStr(All_Cancel) destructiveButtonTitle:nil otherButtonTitles:LocalizedStr(All_PickFromCamera), LocalizedStr(All_PickFromAlbum), nil];
    
    [sheet showInView:self.view];
}

- (void)pickPhotoFromAlbumWithMaxNumberOfSelection:(NSInteger)maxNumber isCropped:(BOOL)isCropped cancelHandle:(PickPhotoCancelHandle)cancelHandle finishPickingHandle:(PickPhotoFinishHandle)finishHandle
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        _pickPhotoFinishHandle = [finishHandle copy];
        _pickPhotoCancelHandle = [cancelHandle copy];
        
        if (1 == maxNumber)
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = isCropped;
            [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:Common_ThemeColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
            
            [self presentViewController:imagePicker modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:^{
                
            }];
        }
        else
        {
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.maximumNumberOfSelection = maxNumber;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.delegate = self;
            picker.showsCancelButton = YES;
            [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:Common_ThemeColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
            
            [self presentViewController:picker modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:nil];
        }
    }
}

- (void)pickPhotoFromCameraByIsCropped:(BOOL)isCropped cancelHandle:(PickPhotoCancelHandle)cancelHandle finishPickingHandle:(PickPhotoFinishHandle)finishHandle
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        _pickPhotoFinishHandle = [finishHandle copy];
        _pickPhotoCancelHandle = [cancelHandle copy];
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = isCropped;
        [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:Common_ThemeColor size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
        
        [self presentViewController:imagePicker modalTransitionStyle:UIModalTransitionStyleCoverVertical completion:^{
            
        }];
    }
}

- (void)clearPickPhotoCallBackHandle
{
    _pickPhotoFinishHandle = nil;
    _pickPhotoCancelHandle = nil;
    _isCropped = NO;
}

#pragma mark - 设置基本属性

- (void)setPageLocalizableText
{
    // 子类实现,设置界面本地的所有文字显示(例如:导航栏标题、设置页文字等,涉及多语言)
}

- (void)setNavigationItemTitle:(NSString *)titleStr
{
    [self setNavigationItemTitle:titleStr titleFont:[UIFont boldSystemFontOfSize:NavTitleFontSize] titleColor:[UIColor whiteColor]];
}

- (void)setNavigationItemTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color
{
    /*
     CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(IPHONE_WIDTH, 44) lineBreakMode:NSLineBreakByWordWrapping];
     
     UILabel *navTitleLabel = InsertLabelWithShadowAndContentOffset(nil, CGRectMake(0, 0, size.width, size.height), NSTextAlignmentCenter, title, font, color, NO, IOS7 ? NO : YES, [UIColor darkGrayColor], CGSizeMake(0, -1), CGSizeMake(0, 0));
     self.navigationItem.titleView = navTitleLabel;
     */
    
    self.navigationItem.title = title;
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : color, UITextAttributeFont : font};
}

- (void)addBackSwipeGesture
{
    // 加右滑动的手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(responesSwipeGesture:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
}

// 响应滑动事件
- (void)responesSwipeGesture:(UISwipeGestureRecognizer *)gesture
{
    [self backViewController];
}

- (void)backViewController
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    // 根据viewControllers的个数来判断此控制器是被present的还是被push的
    if (1 <= viewControllers.count && 0 < [viewControllers indexOfObject:self])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do nothing
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    /*
    if (UIImagePickerControllerSourceTypeCamera == picker.sourceType)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
    }
    */
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
     if (_pickPhotoFinishHandle) _pickPhotoFinishHandle(@[image]);
    [self clearPickPhotoCallBackHandle];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_pickPhotoCancelHandle) _pickPhotoCancelHandle();
    [self clearPickPhotoCallBackHandle];
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *selectedImageArray = [NSMutableArray arrayWithCapacity:assets.count];
    
    for (ALAsset *asset in assets)
    {
        UIImage *selectedImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        [selectedImageArray addObject:selectedImage];
    }
    if (_pickPhotoFinishHandle) _pickPhotoFinishHandle(selectedImageArray);
    
    [self clearPickPhotoCallBackHandle];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker
{
    if (_pickPhotoCancelHandle) _pickPhotoCancelHandle();
    
    [self clearPickPhotoCallBackHandle];
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *butTitleStr = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([butTitleStr isEqualToString:LocalizedStr(All_PickFromCamera)])
    {
        [self pickPhotoFromCameraByIsCropped:_isCropped
                                cancelHandle:_pickPhotoCancelHandle
                         finishPickingHandle:_pickPhotoFinishHandle];
    }
    else if ([butTitleStr isEqualToString:LocalizedStr(All_PickFromAlbum)])
    {
        [self pickPhotoFromAlbumWithMaxNumberOfSelection:1
                                               isCropped:_isCropped
                                            cancelHandle:_pickPhotoCancelHandle
                                     finishPickingHandle:_pickPhotoFinishHandle];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        // 滚动到了最底部
        float value = fabsf(scrollView.contentOffset.y - (scrollView.contentSize.height - _tableView.boundsHeight));
        if (value < 0.5)
        {
            if (_tabScrollToBottomOperationHandle) _tabScrollToBottomOperationHandle(scrollView);
        }
    }
}

@end
