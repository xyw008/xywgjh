//
//  BaseViewController.m
//  o2o
//
//  Created by swift on 14-7-18.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "BaseViewController.h"
#import "HUDManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0X037AFF) size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
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
    
    // 设置界面本地的所有文字显示(涉及多语言)
    [self setPageLocalizableText];
    
    // 返回Btn
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navBack"] highlightedImg:nil action:@selector(backViewController)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IOS7)
    {
        [self setNeedsStatusBarAppearanceUpdate];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideHUD];
    
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

- (void)showHUDInfoByType:(HUDInfoType)type
{
    switch (type)
    {
        case HUDInfoType_Success:
        {
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:OperationSuccess showType:HUDOperationSuccess];
        }
            break;
        case HUDInfoType_Failed:
        {
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:OperationFailure showType:HUDOperationFailed];
        }
            break;
        case HUDInfoType_Loading:
        {
            [HUDManager showHUDWithToShowStr:nil HUDMode:MBProgressHUDModeIndeterminate autoHide:NO afterDelay:0.0 userInteractionEnabled:YES];
        }
            break;
            case HUDInfoType_NoConnectionNetwork:
        {
            [HUDManager showAutoHideHUDOfCustomViewWithToShowStr:NoConnectionNetwork showType:HUDOperationFailed];
        }
            break;
        default:
            break;
    }
}

- (void)showHUDInfoByString:(NSString *)str
{
    [HUDManager showAutoHideHUDWithToShowStr:str HUDMode:MBProgressHUDModeText];
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
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 50, 40) tag:8888 normalImg:nil highlightedImg:nil title:title target:self action:action];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithFrame:CGRectMake(0, 0, 50, 40) tag:8888 normalImg:nil highlightedImg:nil title:title target:self action:action];
    }
}

#pragma mark - 设置基本属性

- (void)setPageLocalizableText
{
    // 子类实现,设置界面本地的所有文字显示(例如:导航栏标题、设置页文字等,涉及多语言)
}

- (void)setNavigationItemTitle:(NSString *)titleStr
{
    [self setNavigationItemTitle:titleStr titleFont:[UIFont boldSystemFontOfSize:NavTitleFontSize] titleColor:[UIColor blackColor]];
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initialize
{
    // Do any additional setup in subClass.
}

- (void)setLeftBarbuttonTitle:(NSString *)titile
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:titile
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(backToPrevious)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showNodataIndicatorWithText:(NSString *)text image:(UIImage *)image
{
    [self hideNodataIndicator];
    
    if (text)
    {
        self.nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 21)];
        self.nodataLabel.backgroundColor = [UIColor clearColor];
        self.nodataLabel.textColor = [UIColor grayColor];
        self.nodataLabel.text = text;
        self.nodataLabel.textAlignment = NSTextAlignmentCenter;
        self.nodataLabel.font = [UIFont systemFontOfSize:15.0];
        [self.view addSubview:self.nodataLabel];
        
        [self.nodataLabel sizeToFit];
        CGRect frame = self.nodataLabel.frame;
        frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width)/2.0, (self.view.frame.size.height - frame.size.height)/2.0);
        self.nodataLabel.frame = frame;
    }
    
    if (image)
    {
        self.nodataIcon = [[UIImageView alloc] initWithImage:image];
        [self.view addSubview:self.nodataIcon];
        
        [self.nodataIcon sizeToFit];
        CGFloat offset = (text ? 21 : 0);
        CGRect frame = self.nodataIcon.frame;
        frame.origin = CGPointMake((self.view.frame.size.width - frame.size.width)/2.0, (self.view.frame.size.height - frame.size.height)/2.0 - offset);
        self.nodataIcon.frame = frame;
    }
}

- (void)hideNodataIndicator
{
    if (self.nodataLabel)
    {
        [self.nodataLabel removeFromSuperview];
        self.nodataLabel = nil;
    }
    
    if (self.nodataIcon)
    {
        [self.nodataIcon removeFromSuperview];
        self.nodataIcon = nil;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
