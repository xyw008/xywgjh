//
//  TemperatureRecordVC.m
//  Thermometer
//
//  Created by 龚 俊慧 on 15/11/15.
//  Copyright © 2015年 com.gjh. All rights reserved.
//

#import "TemperatureRecordVC.h"
#import "TemperatureRecordTabHeaderView.h"

#define kTabHeaderHeight 55

@interface TemperatureRecordVC ()
{
    NSMutableArray<UIButton *>  *_tabHeadersArray;
    
    UIButton                    *_curSelectedTabHeaderBtn;
}

@end

@implementation TemperatureRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureTabHeaders];
    [self initialization];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    TemperatureRecordTabHeaderView *headerView = [TemperatureRecordTabHeaderView loadFromNib];
    _tableView.tableHeaderView = headerView;
    
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

- (void)clickRecordShowTypeChooseBtn:(UIButton *)sender {
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
    return _tabHeadersArray.count;
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
