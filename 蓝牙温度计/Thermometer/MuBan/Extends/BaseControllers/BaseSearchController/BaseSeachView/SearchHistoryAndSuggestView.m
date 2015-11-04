//
//  SearchHistoryView.m
//  o2o
//
//  Created by leo on 14-8-19.
//  Copyright (c) 2014年 com.ejushang. All rights reserved.
//

#import "SearchHistoryAndSuggestView.h"
#import "UserInfoModel.h"

@interface SearchHistoryAndSuggestView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView         *_historyTableView;//历史搜索记录列表
    UILabel             *_nothingHistoryLB;//没有任何搜索记录
    NSMutableArray      *_historyArray;//搜索历史数据
    
    UITableView         *_suggestTableView;//输入智能联想结果列表
}
@end

@implementation SearchHistoryAndSuggestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *history = [UserInfoModel getUserDefaultSearchHistoryArray];
        //有搜索记录
        if ([history isAbsoluteValid])
        {
            _historyArray = [[NSMutableArray alloc] initWithArray:history];
            [self initHistoryTableView];
        }
        else
        {
            [self initHistoryLB];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - init method
- (void)initHistoryTableView
{
    _historyTableView = [[UITableView alloc] initWithFrame:self.bounds];
    [_historyTableView keepAutoresizingInFull];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _historyTableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_historyTableView];
}

- (void)initHistoryLB
{
    _nothingHistoryLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    _nothingHistoryLB.center = CGPointMake(self.center.x, 100);
    _nothingHistoryLB.textAlignment = NSTextAlignmentCenter;
    _nothingHistoryLB.font = SP15Font;
    _nothingHistoryLB.text = [LanguagesManager getStr:Product_NoSearchHistoryShowInfoKey];
    _nothingHistoryLB.backgroundColor = [UIColor whiteColor];
    _nothingHistoryLB.textColor = Common_BlackColor;
    [self addSubview:_nothingHistoryLB];
}

- (void)initSuggestTableView
{
    _suggestTableView = [[UITableView alloc] initWithFrame:self.bounds];
    [_suggestTableView keepAutoresizingInFull];
    _suggestTableView.delegate = self;
    _suggestTableView.dataSource = self;
    _suggestTableView.backgroundColor = [UIColor whiteColor];
    _suggestTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_suggestTableView];
    [self bringSubviewToFront:_suggestTableView];
}

#pragma mark - set method
//对新的结果进行处理
- (void)setSuggestResultArray:(NSArray *)suggestResultArray
{
    if ([suggestResultArray isAbsoluteValid])
    {
        _suggestResultArray = suggestResultArray;
    }
    
    if (_suggestTableView == nil)
    {
        [self initSuggestTableView];
        _historyTableView.hidden = YES;
        _nothingHistoryLB.hidden = YES;
    }
    [_suggestTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_historyTableView])
        return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_historyTableView])
    {
        if (0 == section)
            return [_historyArray count];
        return 0;
    }
    if (_suggestResultArray == nil) {
        return 1;
    }
    return [_suggestResultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_historyTableView])
    {
        static NSString *identifierStr = @"historyCellIdentifierStr";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = Common_BlackColor;
            [cell addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:CellSeparatorColor lineWidth:LineWidth];
        }
        cell.textLabel.text = (NSString*)[_historyArray objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        static NSString *identifierStr = @"SuggestCellIdentifierStr";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = Common_BlackColor;
            [cell addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:CellSeparatorColor lineWidth:LineWidth];
        }
        
        if ([_suggestResultArray isAbsoluteValid])
            cell.textLabel.text = [self getSearchSuggestResult:indexPath.row];
        else
            cell.textLabel.text = @"搜索结果为0";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_historyTableView] && 1 == section) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_historyTableView] && 1 == section)
    {
        UIButton *clearHistoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearHistoryBtn.frame = CGRectMake(50, 2, 110, 28);
        [clearHistoryBtn setTitle:[LanguagesManager getStr:Product_ClearSearchHistoryShowInfoKey] forState:UIControlStateNormal];
        clearHistoryBtn.titleLabel.font = SP15Font;
        [clearHistoryBtn setTitleColor:Common_BlackColor forState:UIControlStateNormal];
        [clearHistoryBtn addTarget:self action:@selector(clearHistoryBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
        return clearHistoryBtn;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_delegate respondsToSelector:@selector(SearchHistoryAndSuggestView:didSelectHistoryOrSuggestString:)])
    {
        NSString *searchStr;
        if ([tableView isEqual:_historyTableView])
            searchStr = [_historyArray objectAtIndex:indexPath.row];
        else
            searchStr = [self getSearchSuggestResult:indexPath.row];
        
        [_delegate SearchHistoryAndSuggestView:self didSelectHistoryOrSuggestString:searchStr];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(theScrollViewDidScroll:)])
    {
        [_delegate theScrollViewDidScroll:scrollView];
    }
}

#pragma mark - Btn touch

- (void)clearHistoryBtnTouch:(UIButton*)btn
{
    [UserInfoModel setUserDefaultSearchHistoryArray:nil];
    _historyTableView.hidden = YES;
    if (_nothingHistoryLB == nil) {
        [self initHistoryLB];
    }
    _nothingHistoryLB.hidden = NO;
}

#pragma mark - custom method
/*
 * 获取智能联想的结果
 * 传入参数   需要获取对应数组的 index
 * 返回参数   联想到得字符串
 */
- (NSString*)getSearchSuggestResult:(NSInteger)index
{
    NSString *string = [_suggestResultArray objectAtIndex:index];
    if ([string isKindOfClass:[NSString class]])
        return string;

    return nil;
}

- (void)addNewSearchHistoryString:(NSString *)string
{
    if (string != nil)
    {
        [_historyArray insertObject:string atIndex:0];
        //保存到本地磁盘
        [UserInfoModel setUserDefaultSearchHistoryArray:_historyArray];
        
        if (_historyTableView == nil) {
            [self addSubview:_historyTableView];
            _nothingHistoryLB.hidden = YES;
        }
        [_historyTableView reloadData];
    }
}

- (void)changeViewAndTableViewHeight:(CGFloat)newHeight
{
    self.height = newHeight;
    _historyTableView.height = newHeight;
    _suggestTableView.height = newHeight;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"sdf");
//}

- (void)setTabShowStyle:(NSInteger)style
{
    if (0 == style)
    {
        _historyTableView.hidden = NO;
        _suggestTableView.hidden = YES;
        
        if ([UserInfoModel getUserDefaultSearchHistoryArray])
        {
            _historyArray = [NSMutableArray arrayWithArray:[UserInfoModel getUserDefaultSearchHistoryArray]];
        }
        else
        {
            _historyArray = nil;
        }
        [_historyTableView reloadData];
    }
    else
    {
        _historyTableView.hidden = YES;
        _suggestTableView.hidden = NO;
    }
}

@end


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
@implementation NoSearchResultView
{
    UILabel         *_remindLB;//提醒LB
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _remindLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, self.width - 30, 22)];
        _remindLB.backgroundColor = [UIColor whiteColor];
        _remindLB.text = @"搜索不到相关商品";
        _remindLB.textAlignment = NSTextAlignmentCenter;
        _remindLB.textColor = Common_BlackColor;
        _remindLB.font = SP15Font;
        [self addSubview:_remindLB];
    }
    return self;
}


@end
