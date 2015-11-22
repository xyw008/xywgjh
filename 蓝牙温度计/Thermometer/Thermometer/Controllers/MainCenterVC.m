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

#import "AlarmSettingVC.h"
#import "LeftUserCenterVC.h"
#import "AboutVC.h"


#define channelOnPeropheralView @"peripheralView"
#define channelOnCharacteristicView @"CharacteristicView"

#define kBottomBtnStartTag 1000

@interface MainCenterVC ()<ATTimerManagerDelegate>
{
    UIImageView                 *_headIV;//头像
    UIScrollView                *_bgScrollView;
    TemperaturesShowView        *_temperaturesShowView;
    FSLineChart                 *_fsLineTemperatureView;//温度线条
    
    UIView                      *_popBgView;//启动弹出的选择模式视图
    
    YSBLEManager                *_ysBluethooth;
    NSInteger                   _countdownTimer;//温度组30秒倒计时计算
}
@end

@implementation MainCenterVC

- (void)dealloc
{
    [[ATTimerManager shardManager] stopTimerDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC setEnablePan:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC setEnablePan:NO];
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _countdownTimer = 30;
    
    
    self.view.backgroundColor = HEXCOLOR(0XF7F7F7);
    
    //[self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(presentLeftMenuViewController:)];
    [self configureBarbuttonItemByPosition:BarbuttonItemPosition_Left normalImg:[UIImage imageNamed:@"navigationbar_icon_menu"] highlightedImg:[UIImage imageNamed:@"navigationbar_icon_menu"] action:@selector(leftMenuBtnTouch:)];
    
    
    
    [self initBgScrollView];
    [self initTemperaturesShowView];
    [self initFsLineTemperatureView];
    [self initBottomBtnsView];
    
    
    [self initPopView];
    
    CGFloat height = 38;
    _headIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height, height)];
    _headIV.backgroundColor = [UIColor redColor];
    ViewRadius(_headIV, height/2);
    self.navigationItem.titleView = _headIV;
    //self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init method

- (void)initBgScrollView
{
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,DynamicWidthValue640(587) + 55)];
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
}

- (void)initTemperaturesShowView
{
    _temperaturesShowView = [[TemperaturesShowView alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH,DynamicWidthValue640(587) + 55)];
    //[_temperaturesShowView setTemperature:0];
    //[self.view addSubview:_temperaturesShowView];
    [_bgScrollView addSubview:_temperaturesShowView];
}

- (void)initFsLineTemperatureView
{
    // Creating the line chart
    _fsLineTemperatureView = [[FSLineChart alloc] initWithFrame:CGRectMake(IPHONE_WIDTH + 10, 20, IPHONE_WIDTH - 10, _temperaturesShowView.height - 20)];
    _fsLineTemperatureView.backgroundColor = _temperaturesShowView.backgroundColor;
    _fsLineTemperatureView.gridStep = 32;
    _fsLineTemperatureView.verticalGridStep = 11;
    _fsLineTemperatureView.horizontalGridStep = 6; // 151,187,205,0.2
    _fsLineTemperatureView.color = Common_BlueColor;
    _fsLineTemperatureView.fillColor = [_fsLineTemperatureView.color colorWithAlphaComponent:0.3];
    _fsLineTemperatureView.valueLabelBackgroundColor = [UIColor clearColor];
    _fsLineTemperatureView.margin = 35;
    _fsLineTemperatureView.needVerticalLine = NO;
    
    _fsLineTemperatureView.labelForIndex = ^(NSUInteger item) {
        return @"18:00";
    };
    
    _fsLineTemperatureView.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.0f°C", value - 1];
    };
    //[_fsLineTemperatureView setChartData:@[@(33),@(35),@(36),@(36.3),@(36.5),@(36.6),@(36.6),@(36.8),@(36.1),@(36.1),@(36.1),@(36.1),@(33),@(40),@(33),@(36.1)]];
    
    [_bgScrollView addSubview:_fsLineTemperatureView];
    _bgScrollView.contentSize = CGSizeMake(_bgScrollView.width*2, 0);
}

- (void)initBottomBtnsView
{
    CGFloat startX = DpToPx(24)/2;
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(_bgScrollView.frame) + 38, IPHONE_WIDTH - startX * 2, DynamicWidthValue640(150))];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgView];
    
    NSArray *titleArray = @[@"预警",@"记录",@"佩戴方式",@"单位切换"];
    NSArray *imageArray = @[@"home_icon_alarm",@"home_icon_histroy",@"home_icon_wear_hand",@"home_icon_unit_c"];
    NSArray *selectImageArray = @[@"home_icon_alarm",@"home_icon_histroy",@"home_icon_wear_head",@"home_icon_unit_f"];
    
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
        
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.font = SP10Font;
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
        [titleLB mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn.mas_bottom).offset(-12);
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
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    
    _popBgView = [[UIView alloc] initWithFrame:superView.bounds];
    _popBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    [superView addSubview:_popBgView];

    
    UIView *contentView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 170)];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.center = CGPointMake(_popBgView.center.x, _popBgView.center.y - 40);
    ViewRadius(contentView, 5);
    [_popBgView addSubview:contentView];
    
    UILabel *titleLB = [[UILabel alloc] initWithText:@"选择使用模式" font:SP15Font];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = Common_BlackColor;
    [contentView addSubview:titleLB];
    
    UIButton *bluetoothBtn = InsertButton(contentView, CGRectZero, 89877, @"蓝牙连接", self, @selector(connectBluetoothBtnTouch:));
    bluetoothBtn.titleLabel.font = SP14Font;
    bluetoothBtn.backgroundColor = Common_GreenColor;
    [bluetoothBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *monitorBtn = InsertButton(contentView, CGRectZero, 89878, @"远程监控", self, @selector(monitorBtnTouch:));
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
        make.bottom.equalTo(contentView.mas_bottom).offset(-10);
        make.width.equalTo(105);
        make.height.equalTo(28);
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
    [((AppDelegate*)[UIApplication sharedApplication].delegate).slideMenuVC toggleMenu];
}


- (void)connectBluetoothBtnTouch:(UIButton*)btn
{
    [_popBgView removeFromSuperview];
    _popBgView = nil;
    
    _ysBluethooth = [YSBLEManager sharedInstance];
    
    WEAKSELF
    
    //实时温度
    [_ysBluethooth setActualTimeValueCallBack:^(CGFloat newTemperature,CGFloat newBettey){
        STRONGSELF
        if (!strongSelf->_temperaturesShowView.isShowTemperatureStatus) {
            strongSelf->_temperaturesShowView.isShowTemperatureStatus = YES;
            
            //开始获取30秒的6组温度数据
            [[YSBLEManager sharedInstance] writeIs30Second:YES];
        }
        [strongSelf->_temperaturesShowView setTemperature:newTemperature];
        [strongSelf->_temperaturesShowView setBettey:newBettey];
    }];
    
    //组温度数据回调
    [_ysBluethooth setGroupTemperatureCallBack:^(NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic){
        STRONGSELF
        NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
        for (NSInteger i=1; i<= temperatureDic.allKeys.count; i++)
        {
            NSArray *oneGroupItemArray = [temperatureDic safeObjectForKey:[NSString stringWithInt:i]];
            for (BLECacheDataEntity *item in oneGroupItemArray)
            {
                [dataArray addObject:@(item.temperature + 9)];
            }
        }
    
        if ([dataArray isAbsoluteValid])
        {
            [strongSelf->_fsLineTemperatureView setChartData:dataArray];
            
            [weakSelf start30SecondCountdownTimer];
        }
    }];
    
    [_ysBluethooth startScanPeripherals];

}

- (void)monitorBtnTouch:(UIButton*)btn
{
    [_popBgView removeFromSuperview];
    _popBgView = nil;
}


- (void)bottomBtnTouch:(UIButton*)btn
{
    NSInteger index = btn.tag - kBottomBtnStartTag;
    
    switch (index)
    {
        case 0://预警
        {
            AlarmSettingVC *vc = [[AlarmSettingVC alloc] init];
            [self pushViewController:vc];
        }
            break;
        case 1://记录
            
            break;
        case 2://佩戴方式
            btn.selected = !btn.selected;
            break;
        case 3://单位切换
            btn.selected = !btn.selected;
            _temperaturesShowView.isFTypeTemperature = btn.selected;
            break;
        default:
            break;
    }
}


// 开启30秒倒计时
- (void)start30SecondCountdownTimer
{
    if ([[ATTimerManager shardManager] hasTimerDelegate:self])
    {
        [[ATTimerManager shardManager] stopTimerDelegate:self];
    }
    [[ATTimerManager shardManager] addTimerDelegate:self interval:1];
}

#pragma mark - ATTimerManagerDelegate methods

- (void)timerManager:(ATTimerManager *)manager timerFireWithInfo:(ATTimerStepInfo)info
{
    _countdownTimer--;
    
    if (0 == _countdownTimer)
    {
        [[YSBLEManager sharedInstance] writeIs30Second:YES];
        _countdownTimer = 30;
        [[ATTimerManager shardManager] stopTimerDelegate:self];
    }
}

#pragma mark - LeftUserCenterVCDelegate
- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc didTouchUserItem:(UserItem*)item
{
    [self leftMenuBtnTouch:nil];
}

- (void)LeftUserCenterVC:(LeftUserCenterVC*)vc touchType:(LeftMenuTouchType)type
{
    [self leftMenuBtnTouch:nil];
    switch (type)
    {
        case LeftMenuTouchType_AddUser:
            
            break;
        case LeftMenuTouchType_Setting:
            
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


@end
