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
    NSDate                          *_selectDate;//选择的时间
    NSDate                          *_beginDate;//一天开始时间
    NSDate                          *_endDate;//一天结束时间
    
    XLChartView                     *_chartView;
    
    BOOL                            _isFUnit;//是否是华氏温度（默认是摄氏）
    
    BOOL                            _isListType;//列表模式
    
    YSBLEManager                    *_ysBluethooth;
    
    NSArray                         *_todayBLTempArray;//当天的全部蓝牙返回数据
    NSMutableDictionary             *_allHourTempDic;//所有小时时段的温度数据
    NSMutableArray                  *_allHourKeyArray;//所有小时key 的数组
    NSMutableArray                  *_allHourAverageTempArray;//每个小时平均温度数组
}

@end

@implementation TemperatureRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectDate = [NSDate date];
    [self getOneDayTemp:_selectDate];
    
    _isFUnit = [[UserInfoModel getIsFUnit] boolValue];
    _isListType = YES;
    //[self configureTabHeaders];
    [self initialization];
    [self initChartView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [AppPropertiesInitialize setBackgroundColorToStatusBar:Common_ThemeColor];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
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
    [_tabHeadersArray removeAllObjects];
    
    _tabHeadersArray = [NSMutableArray array];
    
    for (int i = 0; i < _allHourKeyArray.count; ++i)
    {
        CGFloat averageTemp = [[_allHourAverageTempArray objectAtIndex:i] floatValue];
        UIColor *textColor = [self getTemperaturesColor:averageTemp];
        
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
        pointView.backgroundColor = textColor;
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
                                         [_allHourKeyArray objectAtIndex:i],
                                         kSystemFont_Size(16),
                                         Common_GrayColor,
                                         NO);
        [timeLabel sizeToFit];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(timeLabel.frameWidth, timeLabel.frameHeight));
            make.left.equalTo(pointView.mas_right).offset(@6);
            make.centerY.equalTo(pointView);
        }];
        
        if ([YSBLEManager sharedInstance].isFUnit) {
            averageTemp = [BLEManager getFTemperatureWithC:averageTemp];
        }
        
        NSString *averageStr = [NSString stringWithFormat:@"平均温度%.1lf度",averageTemp];
        UILabel *temperatureLabel = InsertLabel(headerBtn,
                                                CGRectZero,
                                                NSTextAlignmentLeft,
                                                averageStr,
                                                kSystemFont_Size(16),
                                                textColor,
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

//获取一天的数据
- (void)getOneDayTemp:(NSDate*)date
{
    _selectDate = date;
    
    if (!_ysBluethooth) {
        _ysBluethooth = [YSBLEManager sharedInstance];
    }

    NSString *dayString = [NSDate stringFromDate:date withFormatter:DataFormatter_Date];
    NSString *beginStr = [NSString stringWithFormat:@"%@ 00:00:00",dayString];
    NSString *endStr = [NSString stringWithFormat:@"%@ 23:59:59",dayString];
    _beginDate = [NSString dateFromString:beginStr withFormatter:DataFormatter_DateAndTime];
    _endDate = [NSString dateFromString:endStr withFormatter:DataFormatter_DateAndTime];
    
    //蓝牙模式
    if ([AccountStautsManager sharedInstance].isBluetoothType)
    {
        if ([date isToday])
        {
            if ([_allHourKeyArray isAbsoluteValid])
            {
                [_tableView reloadData];
                [_chartView loadDataArray:_todayBLTempArray startDate:_beginDate endDate:_endDate];
                return;
            }
            //组温度数据回调
            WEAKSELF
            [_ysBluethooth setGroupTemperatureCallBack:^(NSDictionary<NSString *, NSArray<BLECacheDataEntity *> *> *temperatureDic,BOOL is30Second){
                STRONGSELF
                if (strongSelf && !is30Second)
                {
                    NSMutableArray  *dataArray = [[NSMutableArray alloc] init];
                    NSArray *keyArray = temperatureDic.allKeys;
                    keyArray = [keyArray sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
                        return [obj1 compare:obj2 options:NSNumericSearch];
                    }];
                    
                    for (NSInteger i=0; i< keyArray.count; i++)
                    {
                        NSArray *oneGroupItemArray = [temperatureDic safeObjectForKey:[keyArray objectAtIndex:i]];
                        NSMutableArray *dayTempArray = [NSMutableArray new];
                        
                        for (BLECacheDataEntity *obj in oneGroupItemArray)
                        {
                            //不是当天的过滤掉
                            if ([obj.date isEqualToDateIgnoringTime:strongSelf->_endDate])
                            {
                                [dayTempArray addObject:obj];
                            }
                        }
                        [dataArray addObjectsFromArray:dayTempArray];
                    }
                    
                    strongSelf->_todayBLTempArray = dataArray;
                    [weakSelf handleGroupTemperature:dataArray needReverse:YES];
                }
            }];
            //[_ysBluethooth startScanPeripherals];
            [_ysBluethooth writeIs30Second:NO];
            [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self selector:@selector(getNewBluethoothData) userInfo:nil repeats:YES];
        }
        else
        {
            [_tableView reloadData];
            [_chartView loadDataArray:nil startDate:_beginDate endDate:_endDate];
        }
    }
    else
    {
        WEAKSELF
        [_ysBluethooth setRemoteTempCallBack:^(NSArray<RemoteTempItem *> *tempArray,NSArray<RemoteTempItem *> *fillingTempArray, NSDate *beginDate, NSDate *endDate){
            STRONGSELF
            if (tempArray && strongSelf)
            {
                NSMutableArray  *allArray = [[NSMutableArray alloc] init];
                
                NSDate *lastAddDate;
                
                for (NSInteger i=0; i < tempArray.count; i++)
                {
                    RemoteTempItem *item = [tempArray objectAtIndex:i];
                    
                    if (i == 0)
                    {
                        BLECacheDataEntity *dataItem = [BLECacheDataEntity new];
                        dataItem.temperature = item.temp;
                        dataItem.date = item.date;
                        [allArray addObject:dataItem];
                        
                        lastAddDate = dataItem.date;
                    }
                    else
                    {
                        //间隔5分钟才取数据
                        if ([lastAddDate minutesBeforeDate:item.date] > 5)
                        {
                            BLECacheDataEntity *dataItem = [BLECacheDataEntity new];
                            dataItem.temperature = item.temp;
                            dataItem.date = item.date;
                            [allArray addObject:dataItem];
                            
                            lastAddDate = dataItem.date;
                        }
                    }
                }
                
                [weakSelf handleGroupTemperature:allArray needReverse:NO];
                
                //[strongSelf->_amFsLineView clearChartData];
                //[strongSelf->_amFsLineView setChartData:amDataArray];
                
                //[strongSelf->_pmFsLineView clearChartData];
                //[strongSelf->_pmFsLineView setChartData:pmDataArray];
            }
        }];
        [_ysBluethooth getRemoteTempBegin:_beginDate end:_endDate];
    }
}


/**
 *  处理蓝牙返回的一天数据
 *
 *  @param tempArray 数据
 *  @param reverse   是否需要倒序，蓝牙数据需要倒序
 */
- (void)handleGroupTemperature:(NSArray<BLECacheDataEntity*>*)tempArray needReverse:(BOOL)needReverse
{
    if ([tempArray isAbsoluteValid])
    {
        //所有小时数组
        _allHourTempDic = [NSMutableDictionary new];
        _allHourKeyArray = [NSMutableArray new];
        _allHourAverageTempArray = [NSMutableArray new];
        
        NSMutableArray *oneHourArray = [NSMutableArray new];
        NSInteger nowHour = -1;
        CGFloat oneHourTotalTemp = 0.0 ;//一个小时的总温度
        
        //对所有数据根据小时时间来分组
        for (NSInteger i=0;i<tempArray.count;i++)
        {
            BLECacheDataEntity *item = [tempArray objectAtIndex:i];
            
            NSString *dateString = [NSDate stringFromDate:item.date withFormatter:DataFormatter_TimeNoSecond];
            NSString *hourStr = [dateString substringToIndex:2];
            NSInteger hour = [hourStr integerValue];
            
            if (nowHour != hour)
            {
                if ([oneHourArray isAbsoluteValid])
                {
                    //倒序
                    //NSArray *tempArray = [[oneHourArray reverseObjectEnumerator] allObjects];
                    NSArray *tempArray = needReverse ? [[oneHourArray reverseObjectEnumerator] allObjects] : oneHourArray;
                    
                    NSString *keyStr = [NSString stringWithFormat:@"%ld:00",nowHour];
                    [_allHourTempDic setObject:tempArray forKey:keyStr];
                    [_allHourKeyArray addObject:keyStr];
                    CGFloat averageTemp = oneHourTotalTemp / oneHourArray.count;
                    [_allHourAverageTempArray addObject:@(averageTemp)];
                }
                oneHourArray = [NSMutableArray new];
                oneHourTotalTemp = 0.0;
                nowHour = hour;
            }
            else
            {
                //超出当天的不用显示
                if ([item.date compare:_beginDate] == NSOrderedAscending || [item.date compare:_endDate] == NSOrderedDescending)
                {
                }
                else
                {
                    oneHourTotalTemp += item.temperature;
                    [oneHourArray addObject:item];
                }
                
                //如果是最后一个了
                if (i == tempArray.count - 1)
                {
                    //倒序
                    //NSArray *tempArray = [[oneHourArray reverseObjectEnumerator] allObjects];
                    NSArray *tempArray = needReverse ? [[oneHourArray reverseObjectEnumerator] allObjects] : oneHourArray;
                    
                    NSString *keyStr = [NSString stringWithFormat:@"%ld:00",nowHour];
                    [_allHourTempDic setObject:tempArray forKey:keyStr];
                    [_allHourKeyArray addObject:keyStr];
                    CGFloat averageTemp = oneHourTotalTemp / oneHourArray.count;
                    [_allHourAverageTempArray addObject:@(averageTemp)];
                    
                }
            }
        }
        
        //倒序
        NSArray *keyArray = needReverse ? [[_allHourKeyArray reverseObjectEnumerator] allObjects] :_allHourKeyArray;
        _allHourKeyArray = [NSMutableArray arrayWithArray:keyArray];
        
        NSArray *tempArray = needReverse ? [[_allHourAverageTempArray reverseObjectEnumerator] allObjects] : _allHourAverageTempArray;
        _allHourAverageTempArray = [NSMutableArray arrayWithArray:tempArray];
        
        [self configureTabHeaders];
    }
    
    [_tableView reloadData];
    [_chartView loadDataArray:tempArray startDate:_beginDate endDate:_endDate];
}

- (void)getNewBluethoothData
{
    [_ysBluethooth writeIs30Second:NO];
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
    NSString *keyStr = [_allHourKeyArray objectAtIndex:indexPath.section];
    NSArray *oneHourArray = [_allHourTempDic safeObjectForKey:keyStr];
    BLECacheDataEntity *item = [oneHourArray objectAtIndex:indexPath.row];
    
    NSString *timeStr = [NSDate stringFromDate:item.date withFormatter:DataFormatter_TimeNoSecond];
    
    CGFloat averageTemp = item.temperature;
    UIColor *textColor = [self getTemperaturesColor:averageTemp];
    
    if ([YSBLEManager sharedInstance].isFUnit) {
        averageTemp = [BLEManager getFTemperatureWithC:averageTemp];
    }
    NSString *tempStr = [NSString stringWithFormat:@"%.1lf度",averageTemp];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [cell addLineWithPosition:ViewDrawLinePostionType_Bottom
                    lineColor:CellSeparatorColor
                    lineWidth:ThinLineWidth];
    UIView *superView = cell.contentView;
    
    UILabel *timeLabel = InsertLabel(superView,
                                     CGRectZero,
                                     NSTextAlignmentLeft,
                                     timeStr,
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
                                            tempStr,
                                            kSystemFont_Size(16),
                                            textColor,
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
    if (_isListType)
    {
        if ([AccountStautsManager sharedInstance].isBluetoothType)
        {
            if ([_selectDate isToday])
                return _tabHeadersArray.count;
            
            return 0;
        }
        else
            return _tabHeadersArray.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIButton *headerBtn = _tabHeadersArray[section];
    
    if (headerBtn.selected) {
        NSString *keyStr = [_allHourKeyArray objectAtIndex:section];
        NSArray *oneHourArray = [_allHourTempDic safeObjectForKey:keyStr];
        return oneHourArray.count;
    }
    return 0;
    //return headerBtn.selected ? 8 : 0;
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



- (UIColor*)getTemperaturesColor:(CGFloat)temperature
{
    if (temperature == 0) {
        return Common_GrayColor;
    }
    else if (temperature <= 35.9)//蓝色
    {
        return HEXCOLOR(0X38b6ff);
    }
    else if(temperature <= 37.4)//绿色
    {
        return Common_BlackColor;
        //return HEXCOLOR(0X12B98E);
    }
    else if(temperature <= 37.9)//橙色
    {
        return HEXCOLOR(0Xfa9d4d);
    }
    else//红色
    {
        return HEXCOLOR(0XFF4330);
    }
}

@end
