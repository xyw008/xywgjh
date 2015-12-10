//
//  TemperatureRecordVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/15.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "TemperatureRecordVC.h"
#import "TemperatureRecordTabHeaderView.h"
#import "FSLineChart.h"
#import "BLEManager.h"
#import "UserInfoModel.h"
#import "YSBLEManager.h"
#import "AppPropertiesInitialize.h"
#import "XLChartView.h"
#import "AccountStautsManager.h"

#define kTabHeaderHeight 55


@interface TemperatureRecordVC ()
{
    NSMutableArray<UIButton *>      *_tabHeadersArray;
    
    UIButton                        *_curSelectedTabHeaderBtn;
    
    TemperatureRecordTabHeaderView  *_headerView;
    
    XLChartView                     *_chartView;
    
    BOOL                            _isFUnit;//是否是华氏温度（默认是摄氏）
    
    BOOL                            _isListType;//列表模式
    
    YSBLEManager                    *_ysBluethooth;
}

@end

@implementation TemperatureRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getOneDayTemp:[NSDate date]];
    
    _isFUnit = [[UserInfoModel getIsFUnit] boolValue];
    _isListType = YES;
    [self configureTabHeaders];
    [self initialization];
    [self initChartView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppPropertiesInitialize setBackgroundColorToStatusBar:Common_ThemeColor];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [AppPropertiesInitialize setBackgroundColorToStatusBar:[UIColor clearColor]];

    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)initialization
{
    [self setupTableViewWithFrame:CGRectMake(0, 20, IPHONE_WIDTH, self.viewFrameHeight - 20)
                            style:UITableViewStyleGrouped
                  registerNibName:nil
                  reuseIdentifier:nil];
    
    _headerView = [TemperatureRecordTabHeaderView loadFromNib];
    
    WEAKSELF
    _headerView.operationHandle = ^(TemperatureRecordTabHeaderView *view, HeaderViewOperationType type,NSDate *nowDate) {
        
        [weakSelf getOneDayTemp:nowDate];
        if (HeaderViewOperationType_DatePre == type)
        {
            
        } else
        {
            
        }
    };
    _tableView.tableHeaderView = _headerView;
    
    // navigation buttons
    CGFloat btnSize = 40;
    [InsertImageButton(self.view,
                       CGRectMake(0, _tableView.frameOriginY, btnSize, btnSize),
                       1000,
                       nil,
                       nil,
                       self,
                       @selector(clickBackBtn:)) setImage:[UIImage imageNamed:@"navigationbar_icon_back"] forState:UIControlStateNormal];
    [InsertImageButton(self.view,
                       CGRectMake(self.viewFrameSize.width - btnSize, _tableView.frameOriginY, btnSize, btnSize),
                       1001,
                       nil,
                       nil,
                       self,
                       @selector(clickRecordShowTypeChooseBtn:)) setImage:[UIImage imageNamed:@"navigationbar_icon_chart"] forState:UIControlStateNormal];
}

- (void)configureTabHeaders
{
    _tabHeadersArray = [NSMutableArray array];
    
    for (int i = 0; i < 6; ++i) {
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.backgroundColor = HEXCOLOR(0XE4E4E4);
        [headerBtn addLineWithPosition:ViewDrawLinePostionType_Bottom
                             lineColor:CellSeparatorColor
                             lineWidth:ThinLineWidth];
        headerBtn.tag = i;
        [headerBtn addTarget:self
                      action:@selector(clickTabHeaderBtn:)
            forControlEvents:UIControlEventTouchUpInside];
        if (0 == i)
        {
            _curSelectedTabHeaderBtn = headerBtn;
            _curSelectedTabHeaderBtn.selected = YES;
        }
        
        UIView *pointView = [UIView new];
        pointView.backgroundColor = HEXCOLOR(0XFF4330);
        [pointView setRadius:9 / 2];
        [headerBtn addSubview:pointView];
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(9, 9));
            make.left.equalTo(headerBtn).offset(@20);
            make.centerY.equalTo(headerBtn);
        }];
        
        UILabel *timeLabel = InsertLabel(headerBtn,
                                         CGRectZero,
                                         NSTextAlignmentLeft,
                                         @"88:88",
                                         kSystemFont_Size(16),
                                         Common_GrayColor,
                                         NO);
        [timeLabel sizeToFit];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(timeLabel.frameWidth, timeLabel.frameHeight));
            make.left.equalTo(pointView.mas_right).offset(@6);
            make.centerY.equalTo(pointView);
        }];
        
        UILabel *temperatureLabel = InsertLabel(headerBtn,
                                                CGRectZero,
                                                NSTextAlignmentLeft,
                                                @"平均温度88.8度",
                                                kSystemFont_Size(16),
                                                Common_BlackColor,
                                                NO);
        [temperatureLabel sizeToFit];
        [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(temperatureLabel.frameWidth, temperatureLabel.frameHeight));
            make.left.equalTo(timeLabel.mas_right).offset(@24);
            make.centerY.equalTo(timeLabel);
        }];
        
        [_tabHeadersArray addObject:headerBtn];
    }
}

- (void)initChartView
{
    _chartView = [[XLChartView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_headerView.frame) + 21, self.view.width - 20, DynamicWidthValue640(600))];
    _chartView.backgroundColor = [UIColor whiteColor];
    _chartView.linecolor = Common_BlueColor;
    _chartView.fillColor = nil;
    _chartView.needVerticalLine = NO;
    _chartView.valueLBStrArray = [self getTempShowLBTextArray];
    _chartView.indexStrArray = [self getDateShowLBTextArray];
    _chartView.hidden = YES;
    [self.view addSubview:_chartView];
    
//    _fsLineBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerView.frame) + 20, self.view.width, self.view.height - _headerView.height - 20)];
//    //_fsLineBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - _headerView.height - 40)];
//
//    _fsLineBgScrollView.pagingEnabled = YES;
//    _fsLineBgScrollView.hidden = YES;
//    _fsLineBgScrollView.showsHorizontalScrollIndicator = NO;
//    _fsLineBgScrollView.backgroundColor = [UIColor whiteColor];
//    [_fsLineBgScrollView keepAutoresizingInMiddle];
//    [self.view addSubview:_fsLineBgScrollView];
//    
//    _amFsLineView = [self createFSLineChartView:CGRectMake(10, 0, _fsLineBgScrollView.width - 10, _fsLineBgScrollView.height)];
//    
//    _pmFsLineView = [self createFSLineChartView:CGRectMake(_fsLineBgScrollView.width + 10, 0, _amFsLineView.width, _amFsLineView.height)];
//    
//    NSDate *currDate = [NSDate date];
//    NSArray *amString = @[@"00:00",@"02:00",@"04:00",@"06:00",@"08:00",@"10:00",@"12:00"];
//    NSArray *pmString = @[@"12:00",@"14:00",@"16:00",@"18:00",@"20:00",@"22:00",@"24:00"];
//    
//    _amFsLineView.labelForIndex = ^(NSUInteger item) {
//        return amString[item];
//    };
//    
//    //上午
//    WEAKSELF
//    _amFsLineView.labelForValue = ^(CGFloat value) {
//        STRONGSELF
//        CGFloat lastValue = value - 1;
//        NSString *unit = @"°C";
//        
//        if (strongSelf->_isFUnit)
//        {
//            lastValue = [BLEManager getFTemperatureWithC:lastValue];
//            unit = @"°F";
//        }
//        return [NSString stringWithFormat:@"%.0f%@", lastValue,unit];
//    };
//    [_amFsLineView setChartData:@[@(36.3),@(36.3),@(36.4),@(36.3),@(36.3),@(36.0),@(36.1),@(36.5),@(36.1),@(36.1),@(36.1),@(36.1),@(36.2),@(36.2),@(36.3),@(36.5)]];
//    [_amFsLineView loadLabelForValue];
//    
//    
//    //下午
//    _pmFsLineView.labelForIndex = ^(NSUInteger item) {
//        return pmString[item];
//    };
//    
//    _pmFsLineView.labelForValue = ^(CGFloat value) {
//        STRONGSELF
//        CGFloat lastValue = value - 1;
//        NSString *unit = @"°C";
//        
//        if (strongSelf->_isFUnit)
//        {
//            lastValue = [BLEManager getFTemperatureWithC:lastValue];
//            unit = @"°F";
//        }
//        return [NSString stringWithFormat:@"%.0f%@", lastValue,unit];
//    };
//    [_pmFsLineView setChartData:@[@(36.3),@(36.3),@(36.4),@(36.3),@(36.3),@(36.0),@(36.1),@(36.5),@(36.1),@(36.1),@(36.1),@(36.1),@(36.2),@(36.2),@(36.3),@(36.5)]];
//    [_pmFsLineView loadLabelForValue];
//    
//    _fsLineBgScrollView.contentSize = CGSizeMake(_fsLineBgScrollView.width*2, 0);
}

//- (FSLineChart*)createFSLineChartView:(CGRect)frame
//{
//    FSLineChart *fsView = [[FSLineChart alloc] initWithFrame:frame];
//    fsView.backgroundColor = [UIColor whiteColor];
//    fsView.gridStep = 32;
//    fsView.verticalGridStep = 11;
//    fsView.horizontalGridStep = 6;
//    fsView.color = Common_BlueColor;
//    fsView.fillColor = [_amFsLineView.color colorWithAlphaComponent:0.3];
//    fsView.valueLabelBackgroundColor = [UIColor clearColor];
//    fsView.margin = 35;
//    fsView.needVerticalLine = NO;
//    [_fsLineBgScrollView addSubview:fsView];
//    return fsView;
//}

#pragma mark - get temp
- (NSArray*)getTempShowLBTextArray
{
    NSString *unit = @"°C";
    if (_isFUnit)
    {
        unit = @"°F";
    }
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i=32; i<43; i += 2)
    {
        [array addObject:[NSString stringWithFormat:@"%ld%@",i,unit]];
    }
    return array;
}

- (NSArray*)getDateShowLBTextArray
{
    NSDate *currDate = [NSDate date];
    
    NSString *dayString = [NSDate stringFromDate:currDate withFormatter:DataFormatter_Date];
    //NSDate *beginDate = [NSString dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dayString] withFormatter:DataFormatter_DateAndTime];
    NSDate *endDate = [NSString dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",dayString] withFormatter:DataFormatter_DateAndTime];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSInteger i=0; i<7; i++) {
        NSDate *beforeDate = [endDate dateBySubtractingHours:(7 - i - 1) * 4];
        if (6 == i)
            [array addObject:@"24:00"];
        else
            [array addObject:[NSDate stringFromDate:beforeDate withFormatter:DataFormatter_TimeNoSecond]];
        
    }
    return array;
}


- (void)getOneDayTemp:(NSDate*)date
{
    if (!_ysBluethooth) {
        _ysBluethooth = [YSBLEManager sharedInstance];
    }

    NSString *dayString = [NSDate stringFromDate:date withFormatter:DataFormatter_Date];
    NSString *beginStr = [NSString stringWithFormat:@"%@ 00:00:00",dayString];
    NSString *endStr = [NSString stringWithFormat:@"%@ 23:59:59",dayString];
    NSDate *beginDate = [NSString dateFromString:beginStr withFormatter:DataFormatter_DateAndTime];
    NSDate *endDate = [NSString dateFromString:endStr withFormatter:DataFormatter_DateAndTime];
    
    //蓝牙模式
    if ([AccountStautsManager sharedInstance].isBluetoothType)
    {
        //组温度数据回调
        WEAKSELF
        [_ysBluethooth setGroupTemperatureCallBack:^(NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic){
            STRONGSELF
            NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
            NSArray *keyArray = temperatureDic.allKeys;
            keyArray = [keyArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            
            for (NSInteger i=0; i< keyArray.count; i++)
            {
                NSArray *oneGroupItemArray = [temperatureDic safeObjectForKey:[keyArray objectAtIndex:i]];
                [dataArray addObjectsFromArray:oneGroupItemArray];
            }
            
            if ([dataArray isAbsoluteValid])
            {
                NSDate *endDate = [NSDate date];
                [strongSelf->_chartView loadDataArray:dataArray startDate:beginDate endDate:endDate];
                
                //            [strongSelf->_fsLineTemperatureView clearChartData];
                //            [strongSelf->_fsLineTemperatureView setChartData:dataArray];
                
            }
        }];
        //[_ysBluethooth startScanPeripherals];
        [_ysBluethooth writeIs30Second:NO];
    }
    else
    {
        WEAKSELF
        [_ysBluethooth setRemoteTempCallBack:^(NSArray<RemoteTempItem *> *tempArray,NSArray<RemoteTempItem *> *fillingTempArray, NSDate *beginDate, NSDate *endDate){
            STRONGSELF
            if (tempArray && strongSelf)
            {
                NSMutableArray  *amDataArray = [[NSMutableArray alloc] init];
                NSMutableArray  *pmDataArray = [[NSMutableArray alloc] init];
                NSDate *date12 = [NSString dateFromString:[NSString stringWithFormat:@"%@ 12:00:00",dayString] withFormatter:DataFormatter_DateAndTime];
                for (NSInteger i=0; i < tempArray.count; i++)
                {
                    RemoteTempItem *item = [tempArray objectAtIndex:i];
                    item.temp += 14.0;
                    NSMutableString *timeString = [NSMutableString stringWithString:item.time];
                    [timeString replaceCharactersInRange:NSMakeRange(10, 1) withString:@" "];
                    NSDate *timeDate = [NSString dateFromString:timeString withFormatter:DataFormatter_DateAndTime];
                    if ([timeDate compare:date12] == NSOrderedAscending)
                    {
                        [amDataArray addObject:[NSNumber numberWithFloat:item.temp]];
                    }
                    else
                    {
                        [pmDataArray addObject:[NSNumber numberWithFloat:item.temp]];
                    }
                }
                
                //[strongSelf->_amFsLineView clearChartData];
                //[strongSelf->_amFsLineView setChartData:amDataArray];
                
                //[strongSelf->_pmFsLineView clearChartData];
                //[strongSelf->_pmFsLineView setChartData:pmDataArray];
            }
        }];
        [_ysBluethooth getRemoteTempBegin:beginDate end:endDate];
    }
}

#pragma mark - btn touch
- (void)clickTabHeaderBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender != _curSelectedTabHeaderBtn)
    {
        _curSelectedTabHeaderBtn.selected = NO;
       
        _curSelectedTabHeaderBtn = sender;
    }
    
    [_tableView reloadData];
    
    NSInteger numberOfRowInSection = [_tableView numberOfRowsInSection:sender.tag];

    if (sender.selected && numberOfRowInSection > 0)
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRowInSection - 1 inSection:sender.tag]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
    }
}


- (void)clickBackBtn:(UIButton *)sender {
    [self backViewController];
}

- (void)clickRecordShowTypeChooseBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    _isListType = !_isListType;
    if (_chartView == nil) {
        [self initChartView];
    }
    
    if (_isListType) {
        _chartView.hidden = YES;
        _tableView.scrollEnabled = YES;
    }
    else{
        _chartView.hidden = NO;
        _tableView.scrollEnabled = NO;
    }
    
    
    [_tableView reloadData];
    
//    if (sender.selected)
//    {
//        _headerView.frameOriginY = 20;
//        [self.view addSubview:_headerView];
//        if (_fsLineBgScrollView == nil) {
//            [self initFsLineView];
//        }
//        _fsLineBgScrollView.hidden = NO;
//        _tableView.hidden = YES;
//    }
//    else
//    {
//        //_headerView.frameOriginY = 0;
//        [_headerView removeFromSuperview];
//        _tableView.tableHeaderView = _headerView;
//        _fsLineBgScrollView.hidden = YES;
//        _tableView.hidden = NO;
//    }
//    
//    for (UIView *subView in self.view.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            [self.view bringSubviewToFront:subView];
//        }
//    }
}


- (void)setupCellWithIndexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell
{
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:ThinLineWidth];
    UIView *superView = cell.contentView;
    
    UILabel *timeLabel = InsertLabel(superView,
                                     CGRectZero,
                                     NSTextAlignmentLeft,
                                     @"88:88",
                                     kSystemFont_Size(16),
                                     Common_GrayColor,
                                     NO);
    [timeLabel sizeToFit];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(timeLabel.frameWidth, timeLabel.frameHeight));
        make.left.equalTo(superView).offset(@45);
        make.centerY.equalTo(superView);
    }];
    
    UILabel *temperatureLabel = InsertLabel(superView,
                                            CGRectZero,
                                            NSTextAlignmentLeft,
                                            @"平均温度88.8度",
                                            kSystemFont_Size(16),
                                            Common_BlackColor,
                                            NO);
    [temperatureLabel sizeToFit];
    [temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(temperatureLabel.frameWidth, temperatureLabel.frameHeight));
        make.left.equalTo(timeLabel.mas_right).offset(@30);
        make.centerY.equalTo(timeLabel);
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isListType) {
        return _tabHeadersArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIButton *headerBtn = _tabHeadersArray[section];
        
    return headerBtn.selected ? 8 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTabHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _tabHeadersArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    [self setupCellWithIndexPath:indexPath cell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISCrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

@end
