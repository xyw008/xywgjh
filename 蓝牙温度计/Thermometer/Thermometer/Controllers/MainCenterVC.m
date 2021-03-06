//
//  MainCenterVC.m
//  Thermometer
//
//  Created by leo on 15/11/4.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "MainCenterVC.h"
#import "AppDelegate.h"
#import "TemperaturesShowView.h"
#import "PopupController.h"
#import "YSBLEManager.h"
#import "FSLineChart.h"
#import "ATTimerManager.h"
#import "CommonEntity.h"
#import "UserInfoModel.h"
#import "XLWelcomeAppView.h"
#import "AppPropertiesInitialize.h"
#import "LoginBC.h"
#import "UserInfoModel.h"
#import "AccountStautsManager.h"
#import "BaseNetworkViewController+NetRequestManager.h"
#import "XLChartView.h"

#import "AlarmSettingVC.h"
#import "LeftUserCenterVC.h"
#import "AboutVC.h"
#import "AddUserVC.h"
#import "SetupVC.h"
#import "LoginVC.h"
#import "RegViewController.h"
#import "TemperatureRecordVC.h"

#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

#define kBottomBtnStartTag 1000

@interface MainCenterVC ()<ATTimerManagerDelegate>
{
    LoginBC                     *_loginBC;
    
    UIImageView                 *_headIV;//头像
    UIScrollView                *_bgScrollView;
    TemperaturesShowView        *_temperaturesShowView;
    FSLineChart                 *_fsLineTemperatureView;//温度线条
    XLChartView                 *_chartView;
    
    UILabel                     *_searchLB;//线条位置的状态提示
    
    UIView                      *_popBgView;//启动弹出的选择模式视图
    
    YSBLEManager                *_ysBluethooth;

    NSInteger                   _countdownTimer;//温度组30秒倒计时计算
    
    BOOL                        _isFUnit;//是否是华氏温度（默认是摄氏）
    
    // BOOL                        _isVisitorType;//是否是游客模式
    XLWelcomeAppView            *_welcomeAppView;//第一次启动app
    
    NSTimer                     *_gourTime;
}

@property (nonatomic, assign) BOOL isVisitorType;

@end

@implementation MainCenterVC

- (void)dealloc
{
    [[ATTimerManager shardManager] stopTimerDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if ([[UserInfoModel getNoFirstGoApp] boolValue])
//    {
//        self.navigationController.navigationBarHidden = NO;
//    }
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // if ([[UserInfoModel getNoFirstGoApp] boolValue])
    {
        [self setSlideMenuVCEnablePan:[AccountStautsManager sharedInstance].isLogin];
    }
    
    if (_ysBluethooth) {
        if ([AccountStautsManager sharedInstance].isBluetoothType)
        {
            [self setGroupTemperatureCallBack];
        }
        else
            [self setRemoteTempCallBack];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    //[self setSlideMenuVCEnablePan:NO];
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self autoLogin];
    
    _countdownTimer = 30;
    _isFUnit = [[UserInfoModel getIsFUnit] boolValue];
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    //[self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(presentLeftMenuViewController:)];
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(leftMenuBtnTouch:)];
    
    
    //登陆成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:kLoginSuccessNotificationKey
                                               object:nil];
    
    //退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout:)
                                                 name:kLogoutNotificationKey
                                               object:nil];
    
    //切换成员
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUserSuccess:)
                                                 name:kChangeNowUserNotificationKey
                                               object:nil];
    
    //修改成员信息成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeUserInfoSuccess:)
                                                 name:kChangeUserSuccessNotificationKey
                                               object:nil];
    
    
    //蓝牙断开连接
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bluetoothDisconnect:)
                                                 name:BluetoothDisconnectNotificationKey
                                               object:nil];
    
    
    [self initBgScrollView];
    [self initTemperaturesShowView];
    [self initFsLineTemperatureView];
    [self initBottomBtnsView];
    
    
    //[self initPopView];
    
    CGFloat height = 38;
    _headIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_userhead"]];
    _headIV.frame = CGRectMake(0, 0, height, height);
    ViewRadius(_headIV, height/2);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    [bgView addSubview:_headIV];
    [_headIV addTarget:self action:@selector(goUserEidt)];
    bgView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = bgView;
    //self.view.backgroundColor = [UIColor redColor];
    [self judgeGoAppNum];
}

- (void)setLeftBtn
{
    if ([AccountStautsManager sharedInstance].isLogin) {
        [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(leftMenuBtnTouch:)];
    }
    else
    {
        [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left barButtonTitle:LocalizedStr(@"back") action:@selector(leftMenuBtnTouch:)];
    }
}

- (void)autoLogin
{
    
    NSString *userName = [UserInfoModel getUserDefaultLoginName];
    NSString *password = [UserInfoModel getUserDefaultPassword];
    if ([userName isAbsoluteValid]) {
        
        if (!_loginBC) {
            _loginBC = [[LoginBC alloc] init];
        }
        [_loginBC loginWithUserName:userName
                           password:password
                          autoLogin:YES
                            showHUD:NO
                      successHandle:^(id successInfoObj) {
                          
                      } failedHandle:^(NSError *error) {
                          
                      }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - welcome

- (void)setIsVisitorType:(BOOL)isVisitorType
{
    _isVisitorType = isVisitorType;
    
    [self setSlideMenuVCEnablePan:!_isVisitorType];
}

- (void)judgeGoAppNum
{
    if (![[UserInfoModel getUserDefaultLoginName] isAbsoluteValid])
    {
        [AccountStautsManager sharedInstance].highAndLowAlarm = YES;
        [AccountStautsManager sharedInstance].disconnectAlarm = YES;
        [AccountStautsManager sharedInstance].bellAlarm = YES;
        [AccountStautsManager sharedInstance].shakeAlarm = YES;
        
        
        [self hiddenNav:YES];
        NSArray *imageArray = @[@"lead_01.png",@"lead_02.png",@"lead_03.png"];
        
        // 判断系统语言
        NSString *curLang = [[NSLocale preferredLanguages] objectAtIndex:0];
        curLang = [curLang lowercaseString];
        if ([curLang hasPrefix:@"en"]) {
            if (iPhone4) {
                imageArray = @[@"i4_1",@"i4_2",@"i4_3"];
            } else {
                imageArray = @[@"i6p_1",@"i6p_2",@"i6p_3"];
            }
        }
         
        WEAKSELF
        _welcomeAppView = [XLWelcomeAppView showSuperView:self.view welcomeImage:imageArray callBack:^(NSInteger touchBtnIndex){
            STRONGSELF
            if (0 == touchBtnIndex)//注册
            {
                RegViewController *reg = [[RegViewController alloc] init];
                UINavigationController *regNav = [[UINavigationController alloc] initWithRootViewController:reg];
                
                [strongSelf presentViewController:regNav
                             modalTransitionStyle:UIModalTransitionStyleCoverVertical
                                       completion:^{
                                       }];
                
            }
            else if(1 == touchBtnIndex)//登录
            {
                [weakSelf goLoginViewShowCloseBtn:YES];
            }
            else if(2 == touchBtnIndex)//游客模式
            {
                [weakSelf removeWelcomeAppViewIsVisitorType:YES];
                strongSelf.isVisitorType = YES;
            }
        }];
    }
    else
        [self initPopView];
}

- (void)removeWelcomeAppViewIsVisitorType:(BOOL)isVisitorType
{
    [_welcomeAppView setViewX:-self.view.width];
    //[self initPopView];
    //[_welcomeAppView removeSelf];
    
    if (isVisitorType)
    {
        //游客模式默认开启蓝牙模式
        [self connectBluetoothBtnTouch:nil];
    }
    
    [self hiddenNav:NO];
    //[UserInfoModel setUserDefaultNoFirstGoApp:@(YES)];
}

- (void)hiddenNav:(BOOL)hidden
{
    self.navigationController.navigationBarHidden = hidden;
    [self setSlideMenuVCEnablePan:!hidden];
    
    // [AppPropertiesInitialize setBackgroundColorToStatusBar:hidden ? HEXCOLOR(0X3C3A47) : Common_ThemeColor];
}

- (void)setSlideMenuVCEnablePan:(BOOL)enable
{
    // [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC setEnabled:enable];
    if (enable)
    {
        SharedAppDelegate.slideMenuVC.panningMode = IIViewDeckPanningViewPanning;
    }
    else
    {
        SharedAppDelegate.slideMenuVC.panningMode = IIViewDeckNoPanning;
    }
}

- (NSArray*)getTempShowLBTextArray
{
    NSString *unit = @"°C";
    if (_isFUnit)
    {
        unit = @"°F";
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i=32; i<43; i++)
    {
        NSInteger value = i;
        if (_isFUnit)
            value = [BLEManager getFTemperatureWithC:i];
        
        [array addObject:[NSString stringWithFormat:@"%ld%@",value,unit]];
    }
    return array;
}

- (NSArray*)getDateShowLBTextArray
{
    NSDate *currDate = [NSDate date];
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i=0; i<6; i++) {
        NSDate *beforeDate = [currDate dateBySubtractingMinutes:(6 - i - 1) * 5];
        [array addObject:[NSDate stringFromDate:beforeDate withFormatter:DataFormatter_TimeNoSecond]];
    }
    return array;
}

#pragma mark - init method

- (void)initBgScrollView
{
    
    CGFloat height = iPhone4 ? DynamicWidthValue640(587) + 15 : DynamicWidthValue640(587) + 55;
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,height)];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    
    _bgScrollView.scrollEnabled = [AccountStautsManager sharedInstance].isLogin;
    
    [self.view addSubview:_bgScrollView];
}

- (void)initTemperaturesShowView
{
    _temperaturesShowView = [[TemperaturesShowView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,_bgScrollView.height)];
    //[_temperaturesShowView setTemperature:0];
    //[self.view addSubview:_temperaturesShowView];
    [_bgScrollView addSubview:_temperaturesShowView];
    _bgScrollView.backgroundColor = _temperaturesShowView.backgroundColor;
}

- (void)initFsLineTemperatureView
{
    _chartView = [[XLChartView alloc] initWithFrame:CGRectMake(IPHONE_WIDTH + 10, 0, IPHONE_WIDTH - 10, _temperaturesShowView.height)];
    _chartView.backgroundColor = _temperaturesShowView.backgroundColor;
    _chartView.linecolor = Common_BlueColor;
    _chartView.indexLBTextColor = [UIColor blackColor];
    _chartView.fillColor = [_chartView.linecolor colorWithAlphaComponent:0.3];
    _chartView.needVerticalLine = NO;
    _chartView.valueLBStrArray = [self getTempShowLBTextArray];
    _chartView.indexStrArray = [self getDateShowLBTextArray];
    
    [_bgScrollView addSubview:_chartView];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width*2, 0);
    
//    _searchLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
//    _searchLB.center = _fsLineTemperatureView.center;
//    _searchLB.textColor = Common_GreenColor;
//    _searchLB.font = [UIFont systemFontOfSize:43];
//    _searchLB.text = @"搜索中";
//    [_bgScrollView addSubview:_searchLB];
    
    /*
    // Creating the line chart
    _fsLineTemperatureView = [[FSLineChart alloc] initWithFrame:CGRectMake(IPHONE_WIDTH + 10, 20, IPHONE_WIDTH - 10, _temperaturesShowView.height - 20)];
    _fsLineTemperatureView.backgroundColor = _temperaturesShowView.backgroundColor;
    _fsLineTemperatureView.gridStep = 32;
    _fsLineTemperatureView.verticalGridStep = 11;
    _fsLineTemperatureView.horizontalGridStep = 5; // 151,187,205,0.2
    _fsLineTemperatureView.color = Common_BlueColor;
    _fsLineTemperatureView.fillColor = [_fsLineTemperatureView.color colorWithAlphaComponent:0.3];
    _fsLineTemperatureView.valueLabelBackgroundColor = [UIColor clearColor];
    _fsLineTemperatureView.margin = 35;
    _fsLineTemperatureView.needVerticalLine = NO;
    
    NSDate *currDate = [NSDate date];
    
    _fsLineTemperatureView.labelForIndex = ^(NSUInteger item) {
        NSDate *beforeDate = [currDate dateBySubtractingMinutes:(6 - item - 1) * 5];
        return [NSDate stringFromDate:beforeDate withFormatter:DataFormatter_TimeNoSecond];
    };

    WEAKSELF
    _fsLineTemperatureView.labelForValue = ^(CGFloat value) {
        STRONGSELF
        CGFloat lastValue = value - 1;
        NSString *unit = @"°C";
        
        if (strongSelf->_isFUnit)
        {
            lastValue = [BLEManager getFTemperatureWithC:lastValue];
            unit = @"°F";
        }
        return [NSString stringWithFormat:@"%.0f%@", lastValue,unit];
    };
    [_fsLineTemperatureView setChartData:@[@(36.3),@(36.3),@(36.4),@(36.3),@(36.3),@(36.0),@(36.1),@(36.5),@(36.1),@(36.1),@(36.1),@(36.1),@(36.2),@(36.2),@(36.3),@(36.5)]];
    [_fsLineTemperatureView loadLabelForValue];
    //_fsLineTemperatureView.hidden = YES;
    [_bgScrollView addSubview:_fsLineTemperatureView];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width*2, 0);
    
    _searchLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    _searchLB.center = _fsLineTemperatureView.center;
    _searchLB.textColor = Common_GreenColor;
    _searchLB.font = [UIFont systemFontOfSize:43];
    _searchLB.text = @"搜索中";
    [_bgScrollView addSubview:_searchLB];
     */
}

- (void)initBottomBtnsView
{
    CGFloat startX = DpToPx(24)/2;
    
    CGFloat startY = iPhone4 ? CGRectGetMaxY(_bgScrollView.frame) + 15 : CGRectGetMaxY(_bgScrollView.frame) + 38;
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, IPHONE_WIDTH - startX * 2, DynamicWidthValue640(150))];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    NSArray *titleArray = @[LocalizedStr(alarm_setting),LocalizedStr(history),LocalizedStr(data_sync),LocalizedStr(toggle_units)];
    NSArray *imageArray = @[@"home_icon_alarm",@"home_icon_histroy",@"home_icon_cloud_f",@"home_icon_unit_f"];
    NSArray *selectImageArray = @[@"home_icon_alarm",@"home_icon_histroy",@"home_icon_cloud_n",@"home_icon_unit_c"];
    
    CGFloat btnWidth = (bottomBgView.width - startX * 5) / 4;
    
    UIButton *lastBtn;
    for (NSInteger i=0; i<titleArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = kBottomBtnStartTag + i;
        //[btn setTitle:titleArray[i] forState:UIControlStateNormal];
        //[btn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImageArray[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(bottomBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        //btn.titleLabel.font = [UIFont systemFontOfSize:10];
        //btn.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
        //默认同步数据
        if (2 == i)
            btn.selected = YES;
        
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.font = SP12Font;
        titleLB.tintColor = Common_BlackColor;
        titleLB.text = titleArray[i];
        titleLB.textAlignment = NSTextAlignmentCenter;
        
        [bottomBgView addSubview:titleLB];
        [bottomBgView addSubview:btn];
        
        
        if (lastBtn)
        {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastBtn.mas_top);
                make.height.equalTo(lastBtn.mas_height);
                make.width.equalTo(lastBtn.mas_width);
                make.left.equalTo(lastBtn.mas_right).offset(startX);
            }];
        }
        else
        {
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bottomBgView.mas_top).offset(DpToPx(12)/2);
                make.bottom.equalTo(bottomBgView.mas_bottom).offset(-(DpToPx(8)/2));
                make.left.equalTo(bottomBgView.mas_left).offset(startX);
                make.width.equalTo(btnWidth);
            }];
        }
        
        CGFloat bottom = DynamicWidthValue640(12);
        
        
        [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn.mas_bottom).offset(-bottom);
            make.left.equalTo(btn.mas_left);
            make.right.equalTo(btn.mas_right);
            make.height.equalTo(13);
        }];
        lastBtn = btn;
    }
}

//启动时候弹出选择模式视图
- (void)initPopView
{
    [_popBgView removeFromSuperview];
    
    //UIView *superView = [[[UIApplication sharedApplication] delegate] window];
    UIView *superView = self.navigationController.view;
    
    _popBgView = [[UIView alloc] initWithFrame:superView.bounds];
    [_popBgView keepAutoresizingInFull];
    _popBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [superView addSubview:_popBgView];
    
    UIView *contentView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 170)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = CGPointMake(_popBgView.center.x, _popBgView.center.y - 40);
    ViewRadius(contentView, 5);
    [_popBgView addSubview:contentView];
    
    UILabel *titleLB = [[UILabel alloc] initWithText:LocalizedStr(select_mode) font:SP15Font];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = Common_BlackColor;
    [contentView addSubview:titleLB];
    
    UIButton *bluetoothBtn = InsertButton(contentView, CGRectZero, 89877, LocalizedStr(connect_BLE), self, @selector(connectBluetoothBtnTouch:));
    bluetoothBtn.titleLabel.font = SP14Font;
    bluetoothBtn.backgroundColor = Common_GreenColor;
    [bluetoothBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *monitorBtn = InsertButton(contentView, CGRectZero, 89878, LocalizedStr(remote_monitor), self, @selector(monitorBtnTouch:));
    monitorBtn.titleLabel.font = bluetoothBtn.titleLabel.font;
    monitorBtn.backgroundColor = Common_GreenColor;
    [monitorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(8);
        make.right.equalTo(contentView.mas_right).offset(-8);
        make.height.equalTo(20);
        make.centerY.equalTo(contentView.mas_centerY).offset(-20);
    }];
    
    [bluetoothBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(15);
        make.bottom.equalTo(contentView.mas_bottom).offset(-15);
        make.width.equalTo(105);
        make.height.equalTo(35);
    }];
    
    [monitorBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-15);
        make.bottom.equalTo(bluetoothBtn.mas_bottom);
        make.width.equalTo(bluetoothBtn.mas_width);
        make.height.equalTo(bluetoothBtn.mas_height);
    }];
}


#pragma mark - btn touch

- (void)leftMenuBtnTouch:(UIButton*)btn
{
    if ([AccountStautsManager sharedInstance].isLogin)
        [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC toggleLeftView];
    else
    {
        if (_welcomeAppView)
        {
            [self hiddenNav:YES];
            [_welcomeAppView setViewX:0];
        }
        else
        {
            [self judgeGoAppNum];
        }
    }
}

- (void)goUserEidt
{
    if ([AccountStautsManager sharedInstance].isLogin && [AccountStautsManager sharedInstance].nowUserItem) {
        AddUserVC *vc = [[AddUserVC alloc] init];
        vc.userItem = [AccountStautsManager sharedInstance].nowUserItem;
        [self pushViewController:vc];
    }
}


- (void)bottomBtnTouch:(UIButton*)btn
{
    NSInteger index = btn.tag - kBottomBtnStartTag;
    if (index != 3 && (_isVisitorType || ![AccountStautsManager sharedInstance].isLogin))
    {
        [self showHUDInfoByString:LocalizedStr(please_login)];
        return;
    }
    
    
    //    if (index != 3)
    //    {
    //        //没登陆
    //        if (![AccountStautsManager sharedInstance].isLogin) {
    //            [self goLoginView];
    //            return;
    //        }
    //
    //        //登陆成功但是没有成员
    //        if (![AccountStautsManager sharedInstance].nowUserItem)
    //        {
    //            [self goAddUserVC];
    //            return;
    //        }
    //    }
    
    switch (index)
    {
        case 0://预警
        {
            AlarmSettingVC *vc = [[AlarmSettingVC alloc] init];
            [self pushViewController:vc];
        }
            break;
        case 1://记录
        {
            TemperatureRecordVC *vc = [TemperatureRecordVC new];
            [self pushViewController:vc];
        }
            break;
        case 2://数据同步
            btn.selected = !btn.selected;
            [AccountStautsManager sharedInstance].uploadTempData = btn.selected;
            break;
        case 3://单位切换
            btn.selected = !btn.selected;
            _temperaturesShowView.isFTypeTemperature = btn.selected;
            _isFUnit = btn.selected;
            //[_fsLineTemperatureView loadLabelForValue];
            _chartView.valueLBStrArray = [self getTempShowLBTextArray];
            _chartView.indexStrArray = [self getDateShowLBTextArray];
            [YSBLEManager sharedInstance].isFUnit = _isFUnit;
            break;
        default:
            break;
    }
}



//蓝牙模式
- (void)connectBluetoothBtnTouch:(UIButton*)btn
{
    _temperaturesShowView.isRemoteType = NO;
    _searchLB.text = LocalizedStr(searching);
    [AccountStautsManager sharedInstance].isBluetoothType = YES;
    
    [_popBgView removeFromSuperview];
    _popBgView = nil;
    
    if (!_ysBluethooth) {
        _ysBluethooth = [YSBLEManager sharedInstance];
    }
    [_ysBluethooth initBluetoothInfo];
    
    if (_gourTime == nil)
    {
        _gourTime = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getGourpTemp) userInfo:nil repeats:YES];
    }
    
    WEAKSELF
    //实时温度
    [_ysBluethooth setActualTimeValueCallBack:^(CGFloat newTemperature,CGFloat rssi, CGFloat newBettey){
        STRONGSELF
        if (!strongSelf->_temperaturesShowView.isShowTemperatureStatus) {
            strongSelf->_temperaturesShowView.isShowTemperatureStatus = YES;
            
            //开始获取30秒的6组温度数据
            [[YSBLEManager sharedInstance] writeIs30Second:YES];
        }
        [strongSelf->_temperaturesShowView setTemperature:newTemperature];
        [strongSelf->_temperaturesShowView setBettey:newBettey];
        [strongSelf->_temperaturesShowView setRssi:rssi];
        
    }];
    
    [self setGroupTemperatureCallBack];
    [_ysBluethooth startScanPeripherals];
}

//远程模式
- (void)monitorBtnTouch:(UIButton*)btn
{
    [_popBgView removeFromSuperview];
    _popBgView = nil;
    
    _temperaturesShowView.isRemoteType = YES;
    _searchLB.text = LocalizedStr(synchronizing);
    [AccountStautsManager sharedInstance].isBluetoothType = NO;
    
    if (!_ysBluethooth) {
        _ysBluethooth = [YSBLEManager sharedInstance];
    }
    
    [self setRemoteTempCallBack];
    
    [self getNetworkData];
    [self getRemoteTempGroup];
    //[self start30SecondCountdownTimer];
    
    if (_gourTime == nil)
    {
        _gourTime = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getGourpTemp) userInfo:nil repeats:YES];
    }
}

//设置温度组的callback  由于_ysBluethooth是单例，所以其他地方用来 这里要处理下
- (void)setGroupTemperatureCallBack
{
    WEAKSELF
    //组温度数据回调
    [_ysBluethooth setGroupTemperatureCallBack:^(NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic,NSArray<BLECacheDataEntity *> *tempArray,BOOL is30Second){
        STRONGSELF
        if (is30Second)
        {
            //            NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
            //            NSArray *keyArray = temperatureDic.allKeys;
            //            keyArray = [keyArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
            //                return [obj1 compare:obj2 options:NSNumericSearch];
            //            }];
            //
            //            for (NSInteger i=0; i< keyArray.count; i++)
            //            {
            //                NSArray *oneGroupItemArray = [temperatureDic safeObjectForKey:[keyArray objectAtIndex:i]];
            //                [dataArray addObjectsFromArray:oneGroupItemArray];
            //
            //                //            for (BLECacheDataEntity *item in oneGroupItemArray)
            //                //            {
            //                //                //[dataArray addObject:@(item.temperature)];
            //                //                [dataArray addObject:@(item.temperature + 9)];
            //                //            }
            //            }
            
            if ([tempArray isAbsoluteValid])
            {
                if (strongSelf->_searchLB)
                {
                    [strongSelf->_searchLB removeFromSuperview];
                    strongSelf->_searchLB = nil;
                    strongSelf->_fsLineTemperatureView.hidden = NO;
                }
                NSDate *endDate = [NSDate date];
                
                NSDate *startDate = [endDate dateBySubtractingMinutes:30];
                [strongSelf->_chartView loadDataArray:tempArray startDate:[startDate dateByAddingSecond:30] endDate:endDate];
                strongSelf->_chartView.indexStrArray = [weakSelf getDateShowLBTextArray];
                
                //            [strongSelf->_fsLineTemperatureView clearChartData];
                //            [strongSelf->_fsLineTemperatureView setChartData:dataArray];
            }
            //[weakSelf start30SecondCountdownTimer];
        }
    }];
}

- (void)setRemoteTempCallBack
{
    WEAKSELF
    [_ysBluethooth setRemoteTempCallBack:^(NSArray<RemoteTempItem *> *tempArray,NSArray<RemoteTempItem *> *fillingTempArray, NSDate *beginDate, NSDate *endDate){
        STRONGSELF
        if (tempArray && strongSelf)
        {
            NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
            for (NSInteger i=0; i < tempArray.count; i++)
            {
                RemoteTempItem *item = [tempArray objectAtIndex:i];
                BLECacheDataEntity *dataItem = [BLECacheDataEntity new];
                dataItem.temperature = item.temp;
                dataItem.date = item.date;
                
                [dataArray addObject:dataItem];
            }
            
            [strongSelf->_chartView loadDataArray:dataArray startDate:beginDate endDate:endDate];
            strongSelf->_chartView.indexStrArray = [weakSelf getDateShowLBTextArray];
        }
    }];
}



#pragma mark - request

- (void)setNetworkRequestStatusBlocks
{
    [self setStartedBlock:^(NetRequest *request){
    
    }];
    
    WEAKSELF
    [self setNetSuccessBlock:^(NetRequest *request, id successInfoObj) {
        
        if (successInfoObj && [successInfoObj isKindOfClass:[NSDictionary class]])
        {
            STRONGSELF
            switch (request.tag)
            {
                case NetTempRequestType_DownloadLastestTemp:
                {
                    NSArray *memberArray = [[successInfoObj safeObjectForKey:@"user"] safeObjectForKey:@"memberList"];
                    
                    if ([memberArray isAbsoluteValid])
                    {
                        NSDictionary *firstDic = [memberArray firstObject];
                        NSArray *tempArray = [firstDic safeObjectForKey:@"tempList"];
                        if ([tempArray isAbsoluteValid])
                        {
                            NSDictionary *firstTempDic = [tempArray firstObject];
                            if ([firstTempDic isSafeObject]) {
                                CGFloat newTemperature = [[firstTempDic safeObjectForKey:@"temp"] floatValue];
                                [strongSelf->_temperaturesShowView setTemperature:newTemperature];
                                strongSelf->_temperaturesShowView.isShowTemperatureStatus = YES;
                            }
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        }
    } failedBlock:^(NetRequest *request, NSError *error) {
        switch (request.tag)
        {
            
        }
    }];
}

//同步拿去服务器数据 30秒一次
- (void)getNetworkData
{
    if (![AccountStautsManager sharedInstance].isLogin || ![AccountStautsManager sharedInstance].nowUserItem)
    {
        //[self goAddUserVC];
        [self showHUDInfoByString:LocalizedStr(please_add_member)];
        return;
    }
    
    NSDictionary *memberDic = @{@"name":[AccountStautsManager sharedInstance].nowUserItem.userName};
    NSDictionary *dic = @{@"phone":[UserInfoModel getUserDefaultLoginName],@"memberList":@[memberDic]};
    [self sendRequest:[[self class] getRequestURLStr:NetTempRequestType_DownloadLastestTemp]
         parameterDic:dic
       requestHeaders:nil
    requestMethodType:RequestMethodType_POST
           requestTag:NetTempRequestType_DownloadLastestTemp];
}

- (void)getRemoteTempGroup
{
    NSDate *endDate = [NSDate date];
    NSDate *beginDate = [endDate dateBySubtractingMinutes:30];
    
    [_ysBluethooth getRemoteTempBegin:beginDate end:endDate];
}

#pragma mark - ATTimerManagerDelegate methods
// 开启30秒倒计时
- (void)start30SecondCountdownTimer
{
    if ([[ATTimerManager shardManager] hasTimerDelegate:self])
    {
        //[[ATTimerManager shardManager] stopTimerDelegate:self];
    }
    else
        [[ATTimerManager shardManager] addTimerDelegate:self interval:1];
}

- (void)timerManager:(ATTimerManager *)manager timerFireWithInfo:(ATTimerStepInfo)info
{
    _countdownTimer--;
    if (0 == _countdownTimer)
    {
        _countdownTimer = 30;
        
        //蓝牙模式
        if ([AccountStautsManager sharedInstance].isBluetoothType)
        {
            [[YSBLEManager sharedInstance] writeIs30Second:YES];
            //[[ATTimerManager shardManager] stopTimerDelegate:self];
        }
        else
        {
            [self getNetworkData];
            [self getRemoteTempGroup];
        }
    }
}

- (void)getGourpTemp
{
    //蓝牙模式
    if ([AccountStautsManager sharedInstance].isBluetoothType)
    {
        [[YSBLEManager sharedInstance] writeIs30Second:YES];
        
        _chartView.indexStrArray = [self getDateShowLBTextArray];
        //[[ATTimerManager shardManager] stopTimerDelegate:self];
    }
    else
    {
        [self getNetworkData];
        [self getRemoteTempGroup];
    }
}

#pragma mark - LeftUserCenterVCDelegate
- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc didTouchUserItem:(UserItem*)item
{
    [self leftMenuBtnTouch:nil];
    
    if ([item.userName isEqualToString:[AccountStautsManager sharedInstance].nowUserItem.userName]) {
        [self goUserEidt];
    }
}

- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc touchType:(LeftMenuTouchType)type
{
    [self leftMenuBtnTouch:nil];
    
    switch (type)
    {
        case LeftMenuTouchType_AddUser:
        {
            [self goAddUserVC];
        }
            break;
        case LeftMenuTouchType_Setting:
        {
            SetupVC *vc = [SetupVC new];
            [self pushViewController:vc];
        }
            break;
        case LeftMenuTouchType_About:
        {
            AboutVC *vc = [AboutVC loadFromNib];
            [self pushViewController:vc];
        }
            break;
        default:
            break;
    }
}

//没有成员通知
- (void)LeftUserCenterVCNoMember:(LeftUserCenterVC*)vc
{
    [self goAddUserVC];
    
//    UINavigationController *addNav = [[UINavigationController alloc] initWithRootViewController:addVC];
//    
//    [self presentViewController:addNav
//           modalTransitionStyle:UIModalTransitionStyleCoverVertical
//                     completion:^{
//                         
//                     }];
}


#pragma mark - push
- (void)goLoginViewShowCloseBtn:(BOOL)isShowCloseBtn
{
    LoginVC *login = [LoginVC loadFromNib];
    login.isShowCloseBtn = isShowCloseBtn;
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    
    [self presentViewController:loginNav
           modalTransitionStyle:UIModalTransitionStyleCoverVertical
                     completion:^{
                         
    }];
}

- (void)goAddUserVC
{
    AddUserVC *addVC = [[AddUserVC alloc] init];
    [self pushViewController:addVC];
}

#pragma mark - notification
- (void)loginSuccess:(NSNotification*)notification
{
    _bgScrollView.scrollEnabled = YES;
    [self setSlideMenuVCEnablePan:YES];
    self.isVisitorType = NO;
    
    if (_welcomeAppView) {
        [self removeWelcomeAppViewIsVisitorType:NO];
    }
    [self initPopView];
    
    
//    if ([AccountStautsManager sharedInstance].nowUserItem.image)
//    {
//        _headIV.image = [AccountStautsManager sharedInstance].nowUserItem.image;
//    }
//    else
//        _headIV.image = [UIImage imageNamed:@"icon_userhead"];
    
}

- (void)changeUserSuccess:(NSNotification*)notification
{
    
    if (![AccountStautsManager sharedInstance].isBluetoothType)
    {
        [_temperaturesShowView setSearchLBText:LocalizedStr(synchronizing)];
        //[_gourTime invalidate];
        //_gourTime = nil;
//        [self getNetworkData];
//        [self getRemoteTempGroup];
    }
    [_chartView loadDataArray:nil startDate:nil endDate:nil];
    
    if ([AccountStautsManager sharedInstance].nowUserItem.image)
    {
        _headIV.image = [AccountStautsManager sharedInstance].nowUserItem.image;
    }
    else
        _headIV.image = [UIImage imageNamed:@"icon_userhead"];
}

- (void)changeUserInfoSuccess:(NSNotification*)notification
{
    if ([AccountStautsManager sharedInstance].nowUserItem.image)
    {
        _headIV.image = [AccountStautsManager sharedInstance].nowUserItem.image;
    }
    else
        _headIV.image = [UIImage imageNamed:@"icon_userhead"];
}


- (void)logout:(NSNotification *)notification
{
    [_gourTime invalidate];
    _gourTime = nil;
    
    [_bgScrollView setContentOffset:CGPointZero];
    _bgScrollView.scrollEnabled = NO;
    _temperaturesShowView.isShowTemperatureStatus = NO;
    // 跳转到登录页
    [self goLoginViewShowCloseBtn:NO];
    
    [_temperaturesShowView setSearchLBText:LocalizedStr(searching)];
    [_chartView loadDataArray:nil startDate:nil endDate:nil];
}

- (void)bluetoothDisconnect:(NSNotification *)notification
{
    [_temperaturesShowView setSearchLBText:LocalizedStr(searching)];
    [_chartView loadDataArray:nil startDate:nil endDate:nil];
//    [_ysBluethooth initBluetoothInfo];
//    [_ysBluethooth startScanPeripherals];
}


@end
