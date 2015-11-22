//
//  SlideActionSheet.m
//  Sephome
//
//  Created by leo on 14/12/12.
//  Copyright (c) 2014年 com.gjh. All rights reserved.
//

#import "SlideActionSheet.h"
#import "PopupController.h"

#define kCellHeight 44.0

@interface SlideActionSheet ()<UITableViewDataSource,UITableViewDelegate>
{
    PopupController                 *_popView;//弹出底图
    NSArray                         *_dataArray;//数据源数组
    SlideActionSheetSelectHandle    _selectHandle;
    
    UIColor                         *_optionColor;//选项字体颜色
    UIFont                          *_optionFont;//选项字体大小
}

@end

@implementation SlideActionSheet

DEF_SINGLETON(SlideActionSheet);

- (void)showActionSheetTitleString:(NSString *)titleStr stringArray:(NSArray *)stringArray selectHnadle:(SlideActionSheetSelectHandle)selectHandle
{
    if ([stringArray isAbsoluteValid])
    {
        [self showActionSheetTitleString:titleStr stringArray:stringArray titleColor:Common_GrayColor titleFont:SP14Font optionColor:Common_BlackColor optionFont:SP14Font selectHnadle:selectHandle];
    }
}

- (void)showActionSheetTitleString:(NSString*)titleStr
                       stringArray:(NSArray*)stringArray
                        titleColor:(UIColor*)titleColor
                         titleFont:(UIFont*)titleFont
                       optionColor:(UIColor*)optionColor
                        optionFont:(UIFont*)optionFont
                      selectHnadle:(SlideActionSheetSelectHandle)selectHandle
{
    _dataArray = stringArray;
    _selectHandle = selectHandle;
    _optionColor = optionColor;
    _optionFont = optionFont;
    
    //默认高度
    CGFloat bgViewDefaultHeight = iPhone4 ? IPHONE_HEIGHT * 0.718 : IPHONE_HEIGHT * 0.618;
    //实际内容的高度（内容高度加上 title高度）
    CGFloat contentHeight = (stringArray.count + 1)*kCellHeight;
    
    //如果内容高度没有达到默认高度的话，按照实际内容高度弹出
    if (bgViewDefaultHeight > contentHeight )
        bgViewDefaultHeight = contentHeight;
    
    //底部视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT - bgViewDefaultHeight, IPHONE_WIDTH, bgViewDefaultHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
    //标题
    UILabel *titleLB = [[UILabel alloc] initWithText:titleStr font:titleFont];
    titleLB.frame = CGRectMake(0, 0, bgView.width, kCellHeight);
    titleLB.textColor = titleColor;
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:titleLB];
    
    //标题底部分割线
    UIView *titleBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLB.frame) - LineWidth, bgView.width, LineWidth)];
    titleBottomLineView.backgroundColor = CellSeparatorColor;
    [bgView addSubview:titleBottomLineView];
    
    //选项tableView
    UITableView *optionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLB.frame), bgView.width, bgView.height - titleLB.height)];
    optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    optionTableView.showsVerticalScrollIndicator = NO;
    optionTableView.dataSource = self;
    optionTableView.delegate = self;
    [bgView addSubview:optionTableView];
    
    //如果tableView的内容高度大于frame高度就可以滚动
    optionTableView.scrollEnabled = (contentHeight - kCellHeight) > optionTableView.height ? YES : NO;
    
    //全屏弹出视图
    _popView = [[PopupController alloc] initWithContentView:bgView];
    _popView.delegate = self;
    _popView.behavior = PopupBehavior_AutoHidden;
    [_popView showInView:[UIApplication sharedApplication].keyWindow animatedType:PopAnimatedType_CurlDown];
}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = SP15Font;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = CellSeparatorColor;
        [cell.contentView addSubview:lineView];
        [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.contentView.mas_bottom);
            make.left.equalTo(cell.contentView.mas_left);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.equalTo(LineWidth);
        }];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataArray objectAtIndex:indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = _optionColor;
    cell.textLabel.font = _optionFont;
    //[cell addLineWithPosition:ViewDrawLinePostionType_Bottom lineColor:CellSeparatorColor lineWidth:LineWidth];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_popView hide];
    if (_selectHandle) {
        _selectHandle (indexPath.row,[_dataArray objectAtIndex:indexPath.row]);
    }
}

#pragma mark - PopupControllerDelegate
- (void) PopupControllerDidHidden:(PopupController *)aController
{
    _popView.delegate = nil;
    _popView = nil;
}

@end
